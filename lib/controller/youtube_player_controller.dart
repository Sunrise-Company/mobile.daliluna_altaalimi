import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as ytd;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:better_player_plus/better_player_plus.dart';

import 'package:daliluna_altaalimi/download_service.dart';

class YoutubePlayerController extends GetxController {
  final String videoId;
  final int lessonId;
  final String type;

  YoutubePlayerController({
    required this.videoId,
    required this.lessonId,
    required this.type,
  });

  bool isLoading = true;
  String? localVideoPath;
  bool isFetchingQualities = false;
  bool embedErrorDetected = false;
  bool uiChangedDetected = false;
  String? videoTitle;

  StreamSubscription<Map<String, DownloadTask>>? _downloadSub;
  bool _isSwitchingToLocal = false;
  String? fetchError;

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  BetterPlayerController? betterPlayerController;
  WebViewController? webViewController;

  bool isPlayerReady = false;
  List<DownloadOption>? prefetchedQualities;
  final DownloadService downloadService = DownloadService.instance;

  bool isFullScreen = false;
  bool restoredUi = false;

  @override
  void onInit() {
    super.onInit();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _initializePlayer();
    _listenForDownloadCompletion();
  }

  /// يُراقب تحديثات التحميل مباشرةً — عندما يكتمل تحميل هذا الفيديو
  /// تحديداً نُعيد تهيئة المشغّل لعرض الملف المحلي.
  void _listenForDownloadCompletion() {
    _downloadSub = downloadService.progressStream.listen((tasks) {
      final task = tasks[videoId];
      if (task?.status == DownloadStatus.completed && localVideoPath == null) {
        _switchToLocalPlayer();
      }
    });
  }

  Future<void> _switchToLocalPlayer() async {
    if (_isSwitchingToLocal || localVideoPath != null) return;
    _isSwitchingToLocal = true;
    isLoading = true;
    update();

    try {
      final localPath = await getLocalFilePath();
      final localFile = File(localPath);
      if (!await localFile.exists()) {
        _isSwitchingToLocal = false;
        isLoading = false;
        update();
        return;
      }

      localVideoPath = localPath;

      videoPlayerController?.dispose();
      chewieController?.dispose();
      betterPlayerController?.dispose();

      if (Platform.isIOS) {
        videoPlayerController = VideoPlayerController.file(localFile);
        await videoPlayerController!.initialize();
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController!,
          autoPlay: true,
          looping: true,
          aspectRatio: videoPlayerController!.value.aspectRatio,
          allowFullScreen: true,
          allowPlaybackSpeedChanging: true,
        );
      } else {
        final dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.file,
          localPath,
        );
        betterPlayerController = BetterPlayerController(
          const BetterPlayerConfiguration(
            autoPlay: true,
            looping: true,
            fit: BoxFit.contain,
          ),
          betterPlayerDataSource: dataSource,
        );
      }

      isPlayerReady = true;
    } catch (e) {
      debugPrint("Error switching to local player: $e");
    } finally {
      _isSwitchingToLocal = false;
      isLoading = false;
      update();
    }
  }

  @override
  void onClose() {
    _downloadSub?.cancel();
    videoPlayerController?.dispose();
    chewieController?.dispose();
    betterPlayerController?.dispose();

    restoreSystemUI();
    super.onClose();
  }

  void restoreSystemUI() {
    if (restoredUi) return;
    restoredUi = true;

    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  void toggleFullScreen() {
    isFullScreen = !isFullScreen;
    if (isFullScreen) {
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
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    }
    update();
  }

  Future<void> prefetchDownloadOptions() async {
    if (localVideoPath != null || prefetchedQualities != null) return;

    isFetchingQualities = true;
    update();

    final yt = ytd.YoutubeExplode();
    try {
      String cleanId = videoId;
      try {
        cleanId = ytd.VideoId(videoId).value;
      } catch (_) {}

      yt.videos
          .get(cleanId)
          .then((video) {
            videoTitle = video.title;
            update();
          })
          .catchError((_) {});

      final manifest = await yt.videos.streamsClient.getManifest(
        cleanId,
        ytClients: [
          ytd.YoutubeApiClient.safari,
          ytd.YoutubeApiClient.androidVr,
        ],
      );
      final List<DownloadOption> options = [];

      options.addAll(
        manifest.muxed
            .where((s) => s.container == ytd.StreamContainer.mp4)
            .where((s) => s.videoResolution.height >= 480)
            .map((s) => DownloadOption.muxed(s)),
      );

      final bestAudio = manifest.audioOnly
          .where((s) => s.container == ytd.StreamContainer.mp4)
          .withHighestBitrate();

      // bestAudio is non-nullable after withHighestBitrate()
      options.addAll(
        manifest.videoOnly
            .where((s) => s.container == ytd.StreamContainer.mp4)
            .where((s) => s.videoResolution.height >= 480)
            .where(
              (v) => !options.any(
                (o) => o.label.startsWith('\${v.videoResolution.height}p'),
              ),
            )
            .map((v) => DownloadOption.separate(v, bestAudio)),
      );
      options.sort((a, b) => b.streamInfo.size.compareTo(a.streamInfo.size));

      prefetchedQualities = options;
    } catch (e) {
      debugPrint('Error fetching download options for $videoId: $e');
      fetchError = e.toString();
    } finally {
      isFetchingQualities = false;
      yt.close();
      update();
    }
  }

  Future<void> downloadVideo() async {
    if (prefetchedQualities == null || prefetchedQualities!.isEmpty) {
      Get.snackbar(
        'خطأ',
        fetchError != null
            ? 'فشل جلب خيارات التحميل: $fetchError'
            : 'لا يمكن تحميل هذا الفيديو. حاول إعادة تشغيل الفيديو.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final selectedOption = await _showDownloadOptionsBottomSheet();
    if (selectedOption != null) {
      await downloadService.startDownload(
        videoId,
        selectedOption,
        videoName: videoTitle,
      );
    }
  }

  Future<DownloadOption?> _showDownloadOptionsBottomSheet() async {
    return Get.bottomSheet<DownloadOption>(
      Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'اختر جودة التحميل',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              if (prefetchedQualities != null)
                ...prefetchedQualities!.map(
                  (option) => ListTile(
                    title: Text(
                      option.label,
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                    onTap: () {
                      Get.back(result: option);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getLocalFilePath() async {
    String cleanId = videoId;
    try {
      cleanId = ytd.VideoId(videoId).value;
    } catch (_) {
      cleanId = videoId.replaceAll(RegExp(r'[^\w\d_-]'), '');
    }
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$cleanId.mp4';
  }

  bool _isInitializing = false;

  Future<void> _initializePlayer() async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      final localPath = await getLocalFilePath();
      final localFile = File(localPath);

      if (await localFile.exists()) {
        localVideoPath = localPath;

        videoPlayerController?.dispose();
        chewieController?.dispose();
        betterPlayerController?.dispose();

        if (Platform.isIOS) {
          videoPlayerController = VideoPlayerController.file(localFile);
          await videoPlayerController!.initialize();

          chewieController = ChewieController(
            videoPlayerController: videoPlayerController!,
            autoPlay: true,
            looping: true,
            aspectRatio: videoPlayerController!.value.aspectRatio,
            allowFullScreen: true,
            allowPlaybackSpeedChanging: true,
          );
        } else {
          final dataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.file,
            localPath,
          );
          betterPlayerController = BetterPlayerController(
            const BetterPlayerConfiguration(
              autoPlay: true,
              looping: true,
              fit: BoxFit.contain,
            ),
            betterPlayerDataSource: dataSource,
          );
        }

        isPlayerReady = true;
        update();
      } else {
        await _initializeWebView();
      }
    } finally {
      _isInitializing = false;
      isLoading = false;
      update();
    }
  }

  Future<void> _initializeWebView() async {
    const String finalJsCommands = """
       // CRITICAL: Navigator spoofing to prevent OS mismatch detection
       try {
         Object.defineProperty(navigator, 'platform', {get: function(){return 'Win32';}});
         Object.defineProperty(navigator, 'maxTouchPoints', {get: function(){return 0;}});
         Object.defineProperty(navigator, 'vendor', {get: function(){return 'Google Inc.';}});
       } catch(e) {}

       function cleanPlayer() {
         const css = `
           /* ① الشريط العلوي: عنوان الفيديو + القناة */
           .ytmVideoInfoVideoTitleContainer { display: none !important; }

           /* ② صورة القناة العائمة على اليسار (absolute positioned) */
           .ytmVideoInfoChannelLogo, .ytmVideoInfoChannelAvatar, .ytmVideoInfoLink { display: none !important; }

           /* ③ شريط "Watch on YouTube" + "Copy link" السفلي */
           .fullscreen-action-menu { display: none !important; }

           /* ④ عناصر قديمة للتوافق فقط */
           .ytp-chrome-top, .ytp-youtube-button, .ytp-impression-link,
           .iv-branding, .ytp-endscreen, .ytp-endscreen-content,
           .ytp-pause-overlay, .ytp-watermark, .ytp-contextmenu { display: none !important; }

           /* ⑤ إخفاء زر التكبير الأصلي لليوتيوب (الاعتماد على الزر اليدوي فقط) */
           .ytp-fullscreen-button, .ytm-fullscreen-button, .fullscreen-icon,
           button[aria-label*="Full screen"], button[aria-label*="full screen"],
           button[title*="Full screen"], button[title*="full screen"] { display: none !important; }
         `;

         let styleEl = document.getElementById('yt-flutter-cleaner');
         if (!styleEl) {
           styleEl = document.createElement('style');
           styleEl.id = 'yt-flutter-cleaner';
           styleEl.type = 'text/css';
           document.head.appendChild(styleEl);
         }
         styleEl.textContent = css;

         document.querySelectorAll('a').forEach(function(a) {
           if (!a.__yt_blocked) {
             a.__yt_blocked = true;
             a.addEventListener('click', function(e) {
               e.preventDefault();
               e.stopPropagation();
               PlayerStatusChannel.postMessage('blocked_link:' + this.href);
             }, {passive: false, capture: true});
             a.setAttribute('target', '_self');
           }
         });

         const bannedWords = ['more', 'share', 'copy', 'link', 'watch on'];
         document.querySelectorAll('[role="menuitem"], .ytp-menuitem').forEach(function(item) {
           const text = (item.innerText || item.textContent || '').toLowerCase().trim();
           const aria = (item.getAttribute('aria-label') || '').toLowerCase();
           const isBanned = bannedWords.some(function(w) { return text.includes(w) || aria.includes(w); });
           if (isBanned) { item.style.setProperty('display', 'none', 'important'); }
         });

         [
           '[aria-label="More options"]', '[aria-label="more options"]',
           '[aria-label="Share"]', '[aria-label="Copy link"]', '[aria-label="Watch on YouTube"]'
         ].forEach(function(sel) {
           document.querySelectorAll(sel).forEach(function(el) {
             el.style.setProperty('display', 'none', 'important');
           });
         });
       }

       const ytObserver = new MutationObserver(cleanPlayer);
       if (document.body) { ytObserver.observe(document.body, { childList: true, subtree: true }); }
       cleanPlayer();

       function lightweightObserver() {
         try {
           const dangerElements = document.querySelectorAll(
             '.ytp-share-button, .ytp-share-panel, .ytEmbedPlayerShareButton, ' +
             '[aria-label*="Share"], [aria-label*="Copy"], [aria-label*="More options"], ' +
             '[title*="Share"], [title*="Copy"]'
           );
           for (let i = 0; i < dangerElements.length; i++) {
             const el = dangerElements[i];
             const style = window.getComputedStyle(el);
             if (style.display !== 'none' && style.visibility !== 'hidden' && style.opacity !== '0') {
               const rect = el.getBoundingClientRect();
               if (rect.width > 0 && rect.height > 0) {
                 UiChangeChannel.postMessage('ui_changed');
                 break;
               }
             }
           }
         } catch(e) {}
       }
       
       setInterval(lightweightObserver, 2000);

       function detectEmbedError() {
         try {
           const text = (document.body && document.body.innerText) ? document.body.innerText : '';
           if (text.indexOf('Error 153') !== -1 || text.indexOf('Video player configuration error') !== -1) {
             PlayerStatusChannel.postMessage('embed_error');
           }
         } catch(e) {}
       }
       setInterval(detectEmbedError, 1000);
       detectEmbedError();
       PlayerStatusChannel.postMessage('ready');
     """;

    final String embedUrl =
        'https://www.youtube-nocookie.com/embed/$videoId?playsinline=1&modestbranding=1&iv_load_policy=3&fs=1&rel=0&origin=https://www.google.com';

    final Map<String, String> headers = {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.122 Safari/537.36',
      'Referer': 'https://www.google.com/',
    };

    if (webViewController == null) {
      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFF000000))
        ..enableZoom(false)
        ..addJavaScriptChannel(
          'PlayerStatusChannel',
          onMessageReceived: (JavaScriptMessage message) {
            final msg = message.message;
            if (msg == 'ready') {
              isPlayerReady = true;
              update();
              prefetchDownloadOptions();
            } else if (msg == 'embed_error') {
              embedErrorDetected = true;
              update();
            }
          },
        )
        ..addJavaScriptChannel(
          'UiChangeChannel',
          onMessageReceived: (JavaScriptMessage message) {
            if (message.message == 'ui_changed') {
              uiChangedDetected = true;
              update();
            }
          },
        )
        ..setUserAgent(
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.122 Safari/537.36",
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              webViewController?.runJavaScript(finalJsCommands);
            },
            onNavigationRequest: (NavigationRequest request) {
              final url = request.url;
              if (url.contains('youtube.com/watch') ||
                  url.contains('youtu.be/')) {
                return NavigationDecision.prevent;
              }
              if (embedErrorDetected &&
                  (url.startsWith('http') || url.contains('youtube.com'))) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        );
    }

    await webViewController?.loadRequest(Uri.parse(embedUrl), headers: headers);
  }

  Future<void> deleteVideo() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('تأكيد الحذف', style: TextStyle(fontFamily: 'Cairo')),
        content: const Text(
          'هل أنت متأكد أنك تريد حذف هذا الفيديو من جهازك؟',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('حذف', style: TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await videoPlayerController?.pause();
      await betterPlayerController?.pause();

      if (videoPlayerController != null) {
        await videoPlayerController!.dispose();
        videoPlayerController = null;
      }
      if (chewieController != null) {
        chewieController!.dispose();
        chewieController = null;
      }
      if (betterPlayerController != null) {
        betterPlayerController!.dispose();
        betterPlayerController = null;
      }

      final localPath = await getLocalFilePath();
      await File(localPath).delete();

      Get.snackbar(
        'نجاح',
        'تم حذف الفيديو بنجاح.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      isLoading = true;
      localVideoPath = null;
      isPlayerReady = false;
      // hasAttemptedLocalLoad = false;
      update();

      await _initializePlayer();
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'خطأ في حذف الفيديو: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void reinitializePlayer() {
    isLoading = true;
    update();
    _initializePlayer();
  }
}
