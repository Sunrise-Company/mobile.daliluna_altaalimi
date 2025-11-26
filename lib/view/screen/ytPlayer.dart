import 'dart:developer' as dev;
import 'dart:developer';
import 'dart:io';
import 'package:daliluna_altaalimi/download_service.dart';
import 'package:daliluna_altaalimi/view/widget/comments_widget.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as ytd;
import 'package:better_player/better_player.dart';
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
        log('FullScreen');
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        log('not full');
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
    } catch (e, stackTrace) {
      dev.log("Failed to prefetch qualities: $e  $stackTrace");
    } finally {
      if (mounted) setState(() => _isFetchingQualities = false);
      yt.close();
    }
  }

  Future<void> _downloadVideo() async {
    final hasPermission = await _handlePermissions();
    if (!hasPermission) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission is required.')),
        );
      return;
    }

    if (_prefetchedQualities == null || _prefetchedQualities!.isEmpty) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not fetch download options.')),
        );
      return;
    }

    final selectedOption = await _showDownloadOptionsDialog(
      _prefetchedQualities!,
    );

    if (selectedOption != null) {
      await _downloadService.startDownload(widget.videoId, selectedOption);
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
          fullScreenByDefault: true,
          allowedScreenSleep: false,
          fit: BoxFit.contain,
        ),
      );
      _betterPlayerController!.setupDataSource(dataSource);
      _betterPlayerController!.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
          _initializePlayer();
        }
      });
    } else {
      _initializeWebView();
    }

    if (mounted) setState(() => _isLoading = false);
  }

  void _initializeWebView() {
    dev.log(widget.videoId.toString());
    const String finalJsCommands = """
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
        'https://www.youtube.com/embed/${widget.videoId}?playsinline=1&modestbranding=1&iv_load_policy=3&fs=1&rel=0&origin=https://www.google.com';

    dev.log(embedUrl.toString());

    final Map<String, String> headers = {
      'User-Agent':
          'Mozilla/5.0 (Linux; Android 10; SM-G975F) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Mobile Safari/537.36',
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
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36",
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
      )
      ..loadRequest(Uri.parse(embedUrl), headers: headers);
  }

  Future<bool> _handlePermissions() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        status = await Permission.videos.request();
      } else {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.storage.request();
    }
    if (status.isGranted || status.isLimited) return true;
    if (status.isPermanentlyDenied && mounted) _showSettingsDialog();
    return false;
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Storage permission has been permanently denied. Please go to your device settings to enable it.',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteVideo() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
          'Are you sure you want to delete this video from your device?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final localPath = await _getLocalFilePath();
      await File(localPath).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video deleted successfully.')),
        );
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
