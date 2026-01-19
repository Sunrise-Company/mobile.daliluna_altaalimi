import 'dart:io';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:daliluna_altaalimi/download_service.dart';

import 'package:daliluna_altaalimi/view/widget/comments_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as ytd;
// import 'package:better_player/better_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubePlayer extends StatefulWidget {
  final String videoId;
  final int lessonId;
  final String type;
  const YoutubePlayer({
    super.key,
    required this.videoId,
    required this.lessonId,
    required this.type,
  });
  @override
  State<YoutubePlayer> createState() => _YoutubePlayerState();
}

class _YoutubePlayerState extends State<YoutubePlayer> {
  bool _isLoading = true;
  String? _localVideoPath;
  bool _isFetchingQualities = false;
  bool _embedErrorDetected = false;
  String? _videoTitle;

  BetterPlayerController? _betterPlayerController;
  late final WebViewController _webViewController;
  bool _isPlayerReady = false;
  List<DownloadOption>? _prefetchedQualities;
  final DownloadService _downloadService = DownloadService.instance;

  bool _isFullScreen = false;

  bool _restoredUi = false;

  void _restoreSystemUI() {
    if (_restoredUi) return;
    _restoredUi = true;

    SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    _initializePlayer();
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();

    _restoreSystemUI();
    super.dispose();
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: SystemUiOverlay.values,
        );
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.black,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
        );
      }
    });
  }

  Future<void> _prefetchDownloadOptions() async {
    if (_localVideoPath != null || _prefetchedQualities != null) return;
    if (mounted) setState(() => _isFetchingQualities = true);

    final yt = ytd.YoutubeExplode();
    try {
      // جلب معلومات الفيديو (بما في ذلك العنوان) في الخلفية
      yt.videos
          .get(widget.videoId)
          .then((video) {
            if (mounted) setState(() => _videoTitle = video.title);
          })
          .catchError((_) {});

      final manifest = await yt.videos.streamsClient.getManifest(
        widget.videoId,
        ytClients: [YoutubeApiClient.safari, YoutubeApiClient.androidVr],
      );
      final List<DownloadOption> options = [];

      options.addAll(
        manifest.muxed
            .where((s) => s.container == ytd.StreamContainer.mp4)
            .map((s) => DownloadOption.muxed(s)),
      );
      final bestAudio = manifest.audioOnly
          .where((s) => s.container == ytd.StreamContainer.mp4)
          .withHighestBitrate();
      if (bestAudio != null) {
        options.addAll(
          manifest.videoOnly
              .where((s) => s.container == ytd.StreamContainer.mp4)
              .where(
                (v) => !options.any(
                  (o) => o.label.startsWith('${v.videoResolution.height}p'),
                ),
              )
              .map((v) => DownloadOption.separate(v, bestAudio)),
        );
      }
      options.sort((a, b) => b.streamInfo.size.compareTo(a.streamInfo.size));

      if (mounted) setState(() => _prefetchedQualities = options);
    } catch (e) {
      // معالجة الأخطاء مع عرض معلومات مفيدة
      debugPrint('Error fetching download options for ${widget.videoId}: $e');

      if (mounted) {
        String errorMessage = 'لا يمكن تحميل هذا الفيديو';

        // تخصيص الرسالة حسب نوع الخطأ
        if (e.toString().contains('VideoUnplayableException')) {
          errorMessage = 'هذا الفيديو غير متاح للتشغيل';
        } else if (e.toString().contains('VideoUnavailableException')) {
          errorMessage = 'هذا الفيديو غير متاح (قد يكون محذوفاً أو خاصاً)';
        } else if (e.toString().contains('VideoRequiresPurchaseException')) {
          errorMessage = 'هذا الفيديو يتطلب شراء';
        } else if (e.toString().contains('SocketException') ||
            e.toString().contains('TimeoutException')) {
          errorMessage = 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى';
        }

        // عرض الخطأ للمستخدم
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isFetchingQualities = false);
      yt.close();
    }
  }

  Future<void> _downloadVideo() async {
    if (_prefetchedQualities == null || _prefetchedQualities!.isEmpty) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'لا يمكن تحميل هذا الفيديو. حاول إعادة تشغيل الفيديو.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      return;
    }

    final selectedOption = await _showDownloadOptionsDialog(
      _prefetchedQualities!,
    );

    if (selectedOption != null) {
      await _downloadService.startDownload(
        widget.videoId,
        selectedOption,
        videoName: _videoTitle,
      );
    }
  }

  Future<String> _getLocalFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/${widget.videoId}.mp4';
  }

  Future<void> _initializePlayer() async {
    final localPath = await _getLocalFilePath();
    final localFile = File(localPath);

    if (await localFile.exists()) {
      _localVideoPath = localPath;
      var dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.file,
        localPath,
      );
      _betterPlayerController = BetterPlayerController(
        const BetterPlayerConfiguration(
          autoPlay: true,
          looping: true,
          fullScreenByDefault: false,
          autoDetectFullscreenDeviceOrientation: false,
          allowedScreenSleep: false,
          fit: BoxFit.contain,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            enableFullscreen: true,
          ),
        ),
      );
      _betterPlayerController!.setupDataSource(dataSource);
      _betterPlayerController!.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
          _initializePlayer();
        }
        // else if (event.betterPlayerEventType ==
        //     BetterPlayerEventType.openFullscreen) {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     _toggleFullScreen();
        //   });
        // } else if (event.betterPlayerEventType ==
        //     BetterPlayerEventType.hideFullscreen) {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     _toggleFullScreen();
        //   });
        // }
      });
      if (mounted) {
        setState(() {
          _isPlayerReady = true; // Fix here
        });
      }
    } else {
      await _initializeWebView();
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _initializeWebView() async {
    const String finalJsCommands = """
       // CRITICAL: Javascript Spoofing to match Windows User Agent
       // This prevents Google from detecting the 'OS Mismatch' (claiming Windows but running on Android/Linux)
       try {
         Object.defineProperty(navigator, 'platform', {get: function(){return 'Win32';}});
         Object.defineProperty(navigator, 'maxTouchPoints', {get: function(){return 0;}}); 
         Object.defineProperty(navigator, 'vendor', {get: function(){return 'Google Inc.';}});
       } catch(e) {}

       function cleanPlayer() {
         const css = `.ytp-chrome-top, .ytp-youtube-button, .ytp-impression-link, .iv-branding,
         .ytp-endscreen, .ytp-endscreen-content, .ytp-pause-overlay, .ytp-watermark,
         .ytp-contextmenu, .ytp-fullscreen-button, .ytp-next-button, .ytp-prev-button {
           display: none !important; visibility: hidden !important;
         }`;
         if (!document.getElementById('youtube-cleaner-style')) {
           const style = document.createElement('style');
           style.id = 'youtube-cleaner-style';
           style.type = 'text/css';
           style.appendChild(document.createTextNode(css));
           document.head.appendChild(style);
         }
       }
       const observer = new MutationObserver(cleanPlayer);
       const targetNode = document.body;
       if (targetNode) { observer.observe(targetNode, { childList: true, subtree: true }); }
       cleanPlayer();

       function detectEmbedError(){
         try{
           const text = (document.body && document.body.innerText) ? document.body.innerText : '';
           if(text.indexOf('Error 153') !== -1 || text.indexOf('Video player configuration error') !== -1){
             PlayerStatusChannel.postMessage('embed_error');
           }
           document.querySelectorAll('a').forEach(a=>{
             if(!a.__blocked_by_flutter){
               a.__blocked_by_flutter = true;
               a.addEventListener('click', function(e){ e.preventDefault(); PlayerStatusChannel.postMessage('blocked_link:'+this.href); }, {passive:false});
               a.setAttribute('target','_self');
             }
           });
         }catch(e){}
       }
       setInterval(detectEmbedError, 1000);
       detectEmbedError();
       PlayerStatusChannel.postMessage('ready');
     """;

    final String embedUrl =
        'https://www.youtube-nocookie.com/embed/${widget.videoId}?playsinline=1&modestbranding=1&iv_load_policy=3&fs=1&rel=0&origin=https://www.google.com';

    final Map<String, String> headers = {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.122 Safari/537.36',
      'Referer': 'https://www.google.com/',
    };

    late final PlatformWebViewControllerCreationParams params;
    params = const PlatformWebViewControllerCreationParams();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..enableZoom(false)
      ..addJavaScriptChannel(
        'PlayerStatusChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final msg = message.message ?? '';
          if (msg == 'ready' && mounted) {
            setState(() => _isPlayerReady = true);
            _prefetchDownloadOptions();
          } else if (msg == 'embed_error' && mounted) {
            setState(() {
              _embedErrorDetected = true;
            });
          }
        },
      )
      ..setUserAgent(
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.122 Safari/537.36",
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _webViewController.runJavaScript(finalJsCommands);
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            if (url.contains('youtube.com/watch') ||
                url.contains('youtu.be/')) {
              return NavigationDecision.prevent;
            }
            if (_embedErrorDetected &&
                (url.startsWith('http') || url.contains('youtube.com'))) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    // NOTE: Removed aggressive cache clearing. Real browsers keep cookies/cache to build trust.
    // Clearing them on every load flags the session as a "Bot/New User" repeatedly.

    await _webViewController.loadRequest(Uri.parse(embedUrl), headers: headers);
  }

  Future<void> _deleteVideo() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذا الفيديو من جهازك؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final localPath = await _getLocalFilePath();
      await File(localPath).delete();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم حذف الفيديو بنجاح.')));
        setState(() {
          _isLoading = true;
          _localVideoPath = null;
        });
        _initializePlayer();
      }
    } catch (e) {}
  }

  Widget _buildPlayerUI({
    required bool isDownloading,
    required double downloadProgress,
    required String downloadStatusText,
  }) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_localVideoPath != null && _betterPlayerController != null)
            BetterPlayer(controller: _betterPlayerController!)
          else
            AnimatedOpacity(
              opacity: _isPlayerReady ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: WebViewWidget(controller: _webViewController),
            ),
          if (_localVideoPath == null && !_isPlayerReady)
            const CircularProgressIndicator(color: Colors.white),
          Positioned(
            top: 16,
            left: 16,
            child: Material(
              color: Colors.black.withOpacity(0.5),
              shape: const CircleBorder(),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () {
                  _restoreSystemUI();
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          _isPlayerReady
              ? Positioned(
                  top: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Material(
                        color: Colors.black.withOpacity(0.5),
                        shape: const CircleBorder(),
                        child: _localVideoPath == null
                            ? _isFetchingQualities
                                  ? Container(
                                      width: 48,
                                      height: 48,
                                      padding: const EdgeInsets.all(12.0),
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.download,
                                        color: Colors.white,
                                      ),
                                      onPressed: isDownloading
                                          ? null
                                          : _downloadVideo,
                                    )
                            : IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                ),
                                onPressed: _deleteVideo,
                              ),
                      ),
                      const SizedBox(width: 8),
                      if (_localVideoPath == null)
                        Material(
                          color: Colors.black.withOpacity(0.5),
                          shape: const CircleBorder(),
                          child: IconButton(
                            icon: Icon(
                              _isFullScreen
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen,
                              color: Colors.white,
                            ),
                            onPressed: _toggleFullScreen,
                          ),
                        ),
                    ],
                  ),
                )
              : SizedBox(),
          if (isDownloading)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: downloadProgress,
                    backgroundColor: Colors.grey[700],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    downloadStatusText,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            _restoreSystemUI();
            return true;
          },
          child: StreamBuilder<Map<String, DownloadTask>>(
            stream: _downloadService.progressStream,
            initialData: {},
            builder: (context, snapshot) {
              final task = snapshot.data?[widget.videoId];
              final isDownloading =
                  task?.status == DownloadStatus.downloading ||
                  task?.status == DownloadStatus.merging;

              if (task?.status == DownloadStatus.completed &&
                  _localVideoPath == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Download complete! Playing video offline.',
                        ),
                      ),
                    );
                    setState(() => _isLoading = true);
                    _initializePlayer();
                  }
                });
              }

              final playerUI = _buildPlayerUI(
                isDownloading: isDownloading,
                downloadProgress: task?.progress ?? 0.0,
                downloadStatusText: task?.statusText ?? '',
              );

              if (_isFullScreen) {
                return playerUI;
              } else {
                return Column(
                  children: [
                    AspectRatio(aspectRatio: 16 / 9, child: playerUI),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: CommentsWidget(
                          lessonId: widget.lessonId.toString(),
                          type: widget.type,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<DownloadOption?> _showDownloadOptionsDialog(
    List<DownloadOption> options,
  ) async {
    if (options.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No downloadable formats found.')),
      );
      return null;
    }

    return showModalBottomSheet<DownloadOption>(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            final option = options[index];
            return ListTile(
              title: Text(option.label),
              onTap: () {
                Navigator.of(context).pop(option);
              },
            );
          },
        );
      },
    );
  }
}
