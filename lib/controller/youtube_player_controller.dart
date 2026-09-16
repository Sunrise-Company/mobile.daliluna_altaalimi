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
    String? initialVideoTitle,
  }) : videoTitle = initialVideoTitle;

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
  final GlobalKey betterPlayerKey = GlobalKey();
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
          allowFullScreen: false,
          allowPlaybackSpeedChanging: true,
        );
      } else {
        final dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.file,
          localPath,
        );
        betterPlayerController = BetterPlayerController(
          BetterPlayerConfiguration(
            autoPlay: true,
            looping: true,
            fit: BoxFit.contain,
            controlsConfiguration: const BetterPlayerControlsConfiguration(
              enableFullscreen: false,
            ),
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

      // Resolve the title before exposing the download options so the task and
      // its notification always start with the correct video name.
      try {
        final video = await yt.videos.get(cleanId);
        videoTitle = video.title;
        update();
      } catch (_) {
        // Keep the title supplied by the lesson screen, when available.
      }

      final manifest = await yt.videos.streamsClient.getManifest(
        cleanId,
        ytClients: [ytd.YoutubeApiClient.androidSdkless],
        requireWatchPage: false,
      );
      final List<DownloadOption> options = [];

      options.addAll(
        manifest.muxed
            .where((s) => s.container == ytd.StreamContainer.mp4)
            .map((s) => DownloadOption.muxed(s)),
      );

      // Like the academy app, expose only ready-to-play MP4 streams that
      // already contain both video and audio. This avoids a second download
      // and native muxing step after the transfer finishes.
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
        lessonId: lessonId,
        type: type,
      );
    }
  }

  Future<DownloadOption?> _showDownloadOptionsBottomSheet() async {
    return Get.bottomSheet<DownloadOption>(
      Material(
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
      final downloadTask = downloadService.getTask(videoId);
      final isDownloadIncomplete =
          downloadTask != null &&
          downloadTask.status != DownloadStatus.completed;

      // A resumable muxed download writes directly to the final path. Do not
      // treat that partial file as a playable, completed video.
      if (await localFile.exists() && !isDownloadIncomplete) {
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
            allowFullScreen: false,
            allowPlaybackSpeedChanging: true,
          );
        } else {
          final dataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.file,
            localPath,
          );
          betterPlayerController = BetterPlayerController(
            BetterPlayerConfiguration(
              autoPlay: true,
              looping: true,
              fit: BoxFit.contain,
              controlsConfiguration: const BetterPlayerControlsConfiguration(
                enableFullscreen: false,
              ),
            ),
            betterPlayerDataSource: dataSource,
          );
        }

        isPlayerReady = true;
        update();
      } else {
        localVideoPath = null;
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

       // Disable browser-style extraction gestures and popup navigation.
       ['contextmenu', 'copy', 'cut', 'dragstart', 'selectstart'].forEach(function(eventName) {
         document.addEventListener(eventName, function(e) {
           e.preventDefault();
           e.stopPropagation();
         }, {passive: false, capture: true});
       });
       try {
         window.open = function() { return null; };
       } catch(e) {}

       var qualityMenuCheckTimer = null;
       var qualityMenuFailureCount = 0;
       var qualityMenuMaintenanceSent = false;
       var lastQualityMenuDebugSignature = '';

       function logQualityMenu(eventName, rows) {
         try {
           const details = rows.map(function(row) {
             return {
               tag: row.tagName || '',
               className: typeof row.className === 'string' ? row.className : '',
               role: row.getAttribute('role') || '',
               ariaLabel: row.getAttribute('aria-label') || '',
               title: row.getAttribute('title') || '',
               text: (row.innerText || row.textContent || '')
                 .replace(/\s+/g, ' ').trim().substring(0, 160),
               html: (row.outerHTML || '').substring(0, 500)
             };
           });
           const signature = eventName + '|' + JSON.stringify(details);
           if (signature === lastQualityMenuDebugSignature) return;
           lastQualityMenuDebugSignature = signature;
           DomDebugChannel.postMessage(JSON.stringify({
             event: eventName,
             url: location.href,
             rows: details
           }));
         } catch(e) {}
       }

       function hideSettingsRow(row) {
         row.style.setProperty('display','none','important');
         row.style.setProperty('pointer-events','none','important');
         row.style.setProperty('visibility','hidden','important');
         row.setAttribute('aria-hidden', 'true');
       }

       function reportUnknownPlayerMenu() {
         qualityMenuFailureCount++;
         if (qualityMenuFailureCount >= 2 && !qualityMenuMaintenanceSent) {
           qualityMenuMaintenanceSent = true;
           UiChangeChannel.postMessage('ui_changed');
         }
       }

       function secureQualityMenu() {
         if (location.hash !== '#bottom-sheet') {
           qualityMenuFailureCount = 0;
           return;
         }

         const container = document.querySelector(
           '.ytSpecBottomSheetLayoutBottomSheetContent > div'
         );
         if (!container) {
           logQualityMenu('missing_container', []);
           reportUnknownPlayerMenu();
           return;
         }

         const rows = Array.from(container.children);
         if (rows.length === 0) {
           logQualityMenu('empty_menu', rows);
           reportUnknownPlayerMenu();
           return;
         }

         const rowText = function(row) {
           return (
             (row.innerText || row.textContent || '') + ' ' +
             (row.getAttribute('aria-label') || '') + ' ' +
             (row.getAttribute('title') || '')
           ).replace(/\s+/g, ' ').trim().toLowerCase();
         };
         const texts = rows.map(rowText);

         // Root settings menu: prove that exactly one row is Quality, then
         // hide every sibling (Speed, Captions, More, and future additions).
         const isRootMenu = texts.some(function(text) {
           return text.indexOf('speed') !== -1 ||
             text.indexOf('captions') !== -1 ||
             text.indexOf('\u0627\u0644\u0633\u0631\u0639\u0629') !== -1 ||
             text.indexOf('\u0627\u0644\u062a\u0631\u062c\u0645\u0629') !== -1;
         });
         if (isRootMenu) {
           const qualityRows = rows.filter(function(row) {
             const text = rowText(row);
             return text.indexOf('quality') !== -1 ||
               text.indexOf('\u0627\u0644\u062c\u0648\u062f\u0629') !== -1;
           });
           if (qualityRows.length !== 1) {
             logQualityMenu('invalid_root_menu', rows);
             reportUnknownPlayerMenu();
             return;
           }

           rows.forEach(function(row) {
             if (row !== qualityRows[0]) hideSettingsRow(row);
           });
           logQualityMenu('root_menu', rows);
           qualityMenuFailureCount = 0;
           return;
         }

         // Quality submenu: allow YouTube's actual resolution choices.
         const qualityChoiceCount = texts.filter(function(text) {
           const firstToken = text.split(' ')[0].toLowerCase();
           const isNumericResolution = firstToken.endsWith('p') &&
             firstToken.length > 1 &&
             !isNaN(Number(firstToken.substring(0, firstToken.length - 1)));
           return firstToken === 'auto' ||
             isNumericResolution ||
             text.indexOf('higher picture quality') !== -1 ||
             text.indexOf('data saver') !== -1 ||
             text.indexOf('\u062a\u0644\u0642\u0627\u0626\u064a') !== -1 ||
             text.indexOf('\u062c\u0648\u062f\u0629 \u0635\u0648\u0631\u0629 \u0623\u0639\u0644\u0649') !== -1 ||
             text.indexOf('\u062a\u0648\u0641\u064a\u0631 \u0627\u0644\u0628\u064a\u0627\u0646\u0627\u062a') !== -1;
         }).length;
         if (qualityChoiceCount > 0) {
           logQualityMenu('quality_menu', rows);
           qualityMenuFailureCount = 0;
           return;
         }

         // Any other bottom sheet is an unknown/changed YouTube structure.
         logQualityMenu('unknown_menu', rows);
         reportUnknownPlayerMenu();
       }

       function scheduleQualityMenuCheck() {
         if (qualityMenuCheckTimer !== null) return;
         qualityMenuCheckTimer = setTimeout(function() {
           qualityMenuCheckTimer = null;
           secureQualityMenu();
         }, 800);
       }

       function cleanPlayer() {
         const css =
           'html,body,*{-webkit-user-select:none!important;user-select:none!important;-webkit-touch-callout:none!important}' +
           '.ytmVideoInfoVideoTitleContainer{display:none!important}' +
           '.ytmVideoInfoChannelLogo,.ytmVideoInfoChannelAvatar,.ytmVideoInfoLink{display:none!important}' +
           '.fullscreen-action-menu{display:none!important}' +
           '.ytp-chrome-top,.ytp-youtube-button,.ytp-impression-link,' +
           '.iv-branding,.ytp-endscreen,.ytp-endscreen-content,' +
           '.ytp-pause-overlay,.ytp-watermark,.ytp-contextmenu{display:none!important}' +
           '.ytp-fullscreen-button,.ytm-fullscreen-button,.fullscreen-icon,' +
           'button[aria-label*="Full screen"],button[title*="Full screen"]{display:none!important}' +
           /* ⑥ زر خيارات إضافية / More options بكل اللغات */
           '.ytp-overflow-button,.ytp-more-button,.ytp-overflow-button-container,' +
           '.ytp-settings-button,.ytm-settings-button,' +
           'button[aria-label*="More actions"],button[title*="More actions"],' +
           'button[aria-label*="More options"],button[title*="More options"],' +
           'button[aria-label*="المزيد"],button[title*="المزيد"]{display:none!important;pointer-events:none!important;visibility:hidden!important}' +
           '.ytp-panel,.ytp-panel-menu,.ytp-share-panel{display:none!important}' +
           '.ytp-share-button,.ytEmbedPlayerShareButton{display:none!important;pointer-events:none!important}' +
           /* CSS wildcard يغطي كل aria-label يحتوي options */
           '[aria-label*="options"],[aria-label*="Options"]{display:none!important;pointer-events:none!important}';

         let styleEl = document.getElementById('yt-flutter-cleaner');
         if (!styleEl) {
           styleEl = document.createElement('style');
           styleEl.id = 'yt-flutter-cleaner';
           styleEl.type = 'text/css';
           document.head.appendChild(styleEl);
         }
         styleEl.textContent = css;

         // ── فحص كل الأزرار بالـ aria-label (الحل الجذري لكل اللغات) ──
         var blockedTerms = [
           'more options', 'more option', 'more actions',
           'share', 'copy link', 'watch on youtube',
           'mas opciones', 'plus d', 'weitere', 'altre', 'mais op',
           '\u062e\u064a\u0627\u0631\u0627\u062a',
           '\u0627\u0644\u0645\u0632\u064a\u062f',
           '\u0645\u0634\u0627\u0631\u0643\u0629',
           '\u0646\u0633\u062e \u0627\u0644\u0631\u0627\u0628\u0637',
           '\u0634\u0627\u0647\u062f \u0639\u0644\u0649'
         ];
         document.querySelectorAll('button,[role="button"],[role="menuitem"]').forEach(function(btn) {
           var combined = (
             (btn.getAttribute('aria-label') || '') + ' ' +
             (btn.getAttribute('title') || '') + ' ' +
             (btn.innerText || btn.textContent || '')
           ).toLowerCase();
           for (var w = 0; w < blockedTerms.length; w++) {
             if (combined.indexOf(blockedTerms[w]) !== -1) {
               btn.style.setProperty('display','none','important');
               btn.style.setProperty('pointer-events','none','important');
               btn.style.setProperty('visibility','hidden','important');
               break;
             }
           }
         });

         // ── querySelectorAll بالنص الفعلي ──
         var sels = [
           '[aria-label="More options"]', '[aria-label="more options"]',
           '[aria-label="More actions"]', '[title="More actions"]',
           '[aria-label*="\u0627\u0644\u0645\u0632\u064a\u062f"]',
           '[aria-label="\u062e\u064a\u0627\u0631\u0627\u062a \u0625\u0636\u0627\u0641\u064a\u0629"]',
           '[aria-label="M\u00e1s opciones"]',
           '[aria-label="Weitere Optionen"]', '[aria-label="Altre opzioni"]',
           '[aria-label="Share"]', '[aria-label="\u0645\u0634\u0627\u0631\u0643\u0629"]',
           '[aria-label="Copy link"]', '[aria-label="Watch on YouTube"]',
           '.ytp-overflow-button', '.ytp-more-button', '.ytp-overflow-button-container',
           '.ytp-settings-button', '.ytm-settings-button'
         ];
         sels.forEach(function(sel) {
           try {
             document.querySelectorAll(sel).forEach(function(el) {
               el.style.setProperty('display','none','important');
               el.style.setProperty('pointer-events','none','important');
               el.style.setProperty('visibility','hidden','important');
               el.style.setProperty('opacity','0','important');
             });
           } catch(e) {}
         });

         // ── إخفاء menu items بالنص ──
         const bannedWords = ['more','share','copy','link','watch on',
           '\u062e\u064a\u0627\u0631','\u0645\u0634\u0627\u0631','\u0646\u0633\u062e'];
         document.querySelectorAll('[role="menuitem"],.ytp-menuitem').forEach(function(item) {
           const txt = (
             (item.innerText || item.textContent || '') + ' ' +
             (item.getAttribute('aria-label') || '')
           ).toLowerCase();
           const normalized = txt.replace(/\s/g, '');
           const isDotsOnly = /^[.\u2022\u2026\u00b7]{3,}\$/.test(normalized);
           if (isDotsOnly || bannedWords.some(function(w){ return txt.indexOf(w) !== -1; })) {
             item.style.setProperty('display','none','important');
             item.style.setProperty('pointer-events','none','important');
           }
         });

         scheduleQualityMenuCheck();

         // ── حظر الروابط الخارجية ──
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
       }

       const ytObserver = new MutationObserver(cleanPlayer);
       if (document.body) { ytObserver.observe(document.body, { childList: true, subtree: true, attributes: true }); }
       window.addEventListener('hashchange', scheduleQualityMenuCheck);
       document.addEventListener('click', scheduleQualityMenuCheck, true);
       cleanPlayer();

       function lightweightObserver() {
         try {
           cleanPlayer();
           const dangerElements = document.querySelectorAll(
             '.ytp-share-button,.ytp-share-panel,.ytEmbedPlayerShareButton,' +
             '.ytp-overflow-button,.ytp-more-button,.ytp-settings-button,.ytm-settings-button,' +
             '[aria-label*="Share"],[aria-label*="Copy"],[aria-label*="More options"],' +
             '[aria-label*="More actions"],[aria-label*="\u0627\u0644\u0645\u0632\u064a\u062f"],' +
             '[title*="Share"],[title*="Copy"]'
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
        ..addJavaScriptChannel(
          'DomDebugChannel',
          onMessageReceived: (JavaScriptMessage message) {
            debugPrint('[YT_DOM] ${message.message}', wrapWidth: 2048);
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
