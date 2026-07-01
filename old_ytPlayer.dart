import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:daliluna_altaalimi/download_service.dart';
import 'package:daliluna_altaalimi/view/widget/comments_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as ytd;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import 'package:better_player_plus/better_player_plus.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

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
  bool _uiChangedDetected = false;
  String? _videoTitle;
  String? _fetchError;

  // iOS Specific
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  // Android Specific
  BetterPlayerController? _betterPlayerController;

  WebViewController? _webViewController;
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
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
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
      String cleanId = widget.videoId;
      try {
        cleanId = ytd.VideoId(widget.videoId).value;
      } catch (_) {}

      // جلب معلومات الفيديو (بما في ذلك العنوان) في الخلفية
      yt.videos
          .get(cleanId)
          .then((video) {
            if (mounted) setState(() => _videoTitle = video.title);
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
      if (bestAudio != null) {
        options.addAll(
          manifest.videoOnly
              .where((s) => s.container == ytd.StreamContainer.mp4)
              .where((s) => s.videoResolution.height >= 480)
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
      if (mounted) setState(() => _fetchError = e.toString());
    } finally {
      if (mounted) setState(() => _isFetchingQualities = false);
      yt.close();
    }
  }

  Future<void> _downloadVideo() async {
    if (_prefetchedQualities == null || _prefetchedQualities!.isEmpty) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _fetchError != null
                  ? 'فشل جلب خيارات التحميل: $_fetchError'
                  : 'لا يمكن تحميل هذا الفيديو. حاول إعادة تشغيل الفيديو.',
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
    String cleanId = widget.videoId;
    try {
      cleanId = ytd.VideoId(widget.videoId).value;
    } catch (_) {
      cleanId = widget.videoId.replaceAll(RegExp(r'[^\w\d_-]'), '');
    }
    return '${directory.path}/$cleanId.mp4';
  }

  Future<void> _initializePlayer() async {
    final localPath = await _getLocalFilePath();
    final localFile = File(localPath);

    if (await localFile.exists()) {
      _localVideoPath = localPath;

      _videoPlayerController?.dispose();
      _chewieController?.dispose();
      _betterPlayerController?.dispose();

      if (Platform.isIOS) {
        _videoPlayerController = VideoPlayerController.file(localFile);
        await _videoPlayerController!.initialize();

        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: true,
          looping: true,
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          allowFullScreen: true,
          allowPlaybackSpeedChanging: true,
        );
      } else {
        final dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.file,
          localPath,
        );
        _betterPlayerController = BetterPlayerController(
          const BetterPlayerConfiguration(
            autoPlay: true,
            looping: true,
            fit: BoxFit.contain,
          ),
          betterPlayerDataSource: dataSource,
        );
      }

      if (mounted) {
        setState(() {
          _isPlayerReady = true;
        });
      }
    } else {
      await _initializeWebView();
    }

    if (mounted) setState(() => _isLoading = false);
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
         // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
         // أخفي فقط العناصر الـ overlays التي تزيد على المشغّل
         // لا تلمس: أزرار التشغيل، الإعدادات، الجودة، السرعة
         // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
         const css = `
           /* ① الشريط العلوي: عنوان الفيديو + القناة */
           .ytmVideoInfoVideoTitleContainer {
             display: none !important;
           }

           /* ② صورة القناة العائمة على اليسار (absolute positioned) */
           .ytmVideoInfoChannelLogo,
           .ytmVideoInfoChannelAvatar,
           .ytmVideoInfoLink {
             display: none !important;
           }

           /* ③ شريط "Watch on YouTube" + "Copy link" السفلي */
           .fullscreen-action-menu {
             display: none !important;
           }

           /* ④ عناصر قديمة للتوافق فقط */
           .ytp-chrome-top,
           .ytp-youtube-button,
           .ytp-impression-link,
           .iv-branding,
           .ytp-endscreen,
           .ytp-endscreen-content,
           .ytp-pause-overlay,
           .ytp-watermark,
           .ytp-contextmenu {
             display: none !important;
           }

           /* ⑤ إخفاء زر التكبير الأصلي لليوتيوب (الاعتماد على الزر اليدوي فقط) */
           .ytp-fullscreen-button,
           .ytm-fullscreen-button,
           .fullscreen-icon,
           button[aria-label*="Full screen"],
           button[aria-label*="full screen"],
           button[title*="Full screen"],
           button[title*="full screen"] {
             display: none !important;
           }
         `;

         // دائماً استبدل المحتوى (لا تتحقق فقط إذا موجود)
         let styleEl = document.getElementById('yt-flutter-cleaner');
         if (!styleEl) {
           styleEl = document.createElement('style');
           styleEl.id = 'yt-flutter-cleaner';
           styleEl.type = 'text/css';
           document.head.appendChild(styleEl);
         }
         styleEl.textContent = css;

         // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
         // Block: قطع الروابط الخارجة فقط (yosutube.com/watch)
         // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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

         // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
         // Hide: خيارات "More options" / "Share" داخل Settings
         // بالبحث عن الـ menuitem بالنص بدل إخفاء القائمة كلها
         // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
         const bannedWords = ['more', 'share', 'copy', 'link', 'watch on'];
         document.querySelectorAll('[role="menuitem"], .ytp-menuitem').forEach(function(item) {
           const text = (item.innerText || item.textContent || '').toLowerCase().trim();
           const aria = (item.getAttribute('aria-label') || '').toLowerCase();
           const isBanned = bannedWords.some(function(w) {
             return text.includes(w) || aria.includes(w);
           });
           if (isBanned) {
             item.style.setProperty('display', 'none', 'important');
           }
         });

         // إخفاء بالـ aria-label الدقيق (للتأكيد)
         [
           '[aria-label="More options"]',
           '[aria-label="more options"]',
           '[aria-label="Share"]',
           '[aria-label="Copy link"]',
           '[aria-label="Watch on YouTube"]'
         ].forEach(function(sel) {
           document.querySelectorAll(sel).forEach(function(el) {
             el.style.setProperty('display', 'none', 'important');
           });
         });
       }

       // مراقبة أي تغيير في الـ DOM وإعادة التطبيق
       const ytObserver = new MutationObserver(cleanPlayer);
       if (document.body) {
         ytObserver.observe(document.body, { childList: true, subtree: true });
       }
       cleanPlayer();

       function detectEmbedError() {
         try {
           const text = (document.body && document.body.innerText) ? document.body.innerText : '';
           if (text.indexOf('Error 153') !== -1 || text.indexOf('Video player configuration error') !== -1) {
             PlayerStatusChannel.postMessage('embed_error');
           }
         } catch(e) {}
       }

       // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
       // كشف تغيير واجهة YouTube محذوف مؤقتاً
       // (الـ CSS يعمل بشكل صحيح - display:none مؤكد)
       // سيُعاد تفعيله بعد ضبط الـ selectors بدقة أكثر
       // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

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

    if (_webViewController == null) {
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
        ..addJavaScriptChannel(
          'UiChangeChannel',
          onMessageReceived: (JavaScriptMessage message) {
            if (message.message == 'ui_changed' && mounted) {
              setState(() => _uiChangedDetected = true);
            }
          },
        )
        ..setUserAgent(
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.6312.122 Safari/537.36",
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (String url) {
              _webViewController?.runJavaScript(finalJsCommands);
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
    }

    await _webViewController?.loadRequest(
      Uri.parse(embedUrl),
      headers: headers,
    );
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
      // CRITICAL: Pause and dispose ALL controllers BEFORE deleting the file
      // This prevents audio from continuing and fixes the "recreating_view" error

      // Pause the video first
      await _videoPlayerController?.pause();
      await _betterPlayerController?.pause();

      // Dispose iOS video controller
      if (_videoPlayerController != null) {
        await _videoPlayerController!.dispose();
        _videoPlayerController = null;
      }

      // Dispose iOS Chewie controller
      if (_chewieController != null) {
        _chewieController!.dispose();
        _chewieController = null;
      }

      // Dispose Android BetterPlayer controller
      if (_betterPlayerController != null) {
        _betterPlayerController!.dispose();
        _betterPlayerController = null;
      }

      // Now delete the file
      final localPath = await _getLocalFilePath();
      await File(localPath).delete();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم حذف الفيديو بنجاح.')));

        // Reset state
        setState(() {
          _isLoading = true;
          _localVideoPath = null;
          _isPlayerReady = false;
        });

        // Reinitialize the player (will switch to YouTube embed)
        await _initializePlayer();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ في حذف الفيديو: $e')));
      }
    }
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

    Widget? localPlayer;
    if (_localVideoPath != null) {
      if (Platform.isIOS) {
        localPlayer = _chewieController != null
            ? Chewie(controller: _chewieController!)
            : null;
      } else {
        localPlayer = _betterPlayerController != null
            ? BetterPlayer(controller: _betterPlayerController!)
            : null;
      }
    }

    // ── إذا تغيّرت واجهة YouTube أوقف المشغل وأظهر رسالة الدعم ──
    if (_uiChangedDetected) {
      return _buildUiChangedScreen();
    }

    return Padding(
      padding: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Video Player ──────────────────────────────────────
          if (localPlayer != null)
            localPlayer
          else
            AnimatedOpacity(
              opacity: _isPlayerReady ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: _webViewController != null
                  ? WebViewWidget(controller: _webViewController!)
                  : const SizedBox(),
            ),

          // ── Loading indicator ─────────────────────────────────
          if (_localVideoPath == null && !_isPlayerReady)
            const CircularProgressIndicator(color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildUiChangedScreen() {
    return Container(
      color: const Color(0xFF0D0D0D),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // أيقونة تحذير متحركة
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4444).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.construction_rounded,
                  color: Color(0xFFFF6B6B),
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),

              // العنوان
              const Text(
                'المشغّل يحتاج تحديثاً',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 12),

              // الوصف
              Text(
                'الفريق التقني يعمل على حل هذه المشكلة في أقرب وقت.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                  height: 1.7,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 32),

              // زر التواصل مع الدعم
              Material(
                color: const Color(0xFFFF4444),
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    // يمكن توجيه المستخدم لصفحة دعم أو إرسال بريد
                    // يمكن ربطه بـ url_launcher لفتح واتساب/تيليغرام/بريد
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.support_agent_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'التواصل مع الدعم الفني',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // زر الرجوع
              TextButton(
                onPressed: () {
                  _restoreSystemUI();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'رجوع',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// شريط التحكم الاحترافي بلمسة UI/UX عصرية
  Widget _buildControlBar({required bool isDownloading}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // ← زر الرجوع (يمين الشاشة لأن الاتجاه RTL)
          Expanded(
            child: _premiumActionButton(
              icon: Icons.arrow_back_rounded,
              label: 'رجوع',
              onTap: () {
                _restoreSystemUI();
                Navigator.of(context).pop();
              },
              color: AppColor.PrimaryColor,
            ),
          ),

          const SizedBox(width: 12),

          if (_localVideoPath == null && _isPlayerReady) ...[
            Expanded(
              child: _isFetchingQualities
                  ? _buildLoadingButton()
                  : _premiumActionButton(
                      icon: Icons.download_rounded,
                      label: 'تحميل',
                      onTap: isDownloading ? null : _downloadVideo,
                      color: AppColor.PrimaryColor,
                      isPrimary: true,
                    ),
            ),
            const SizedBox(width: 12),
          ] else if (_localVideoPath != null) ...[
            Expanded(
              child: _premiumActionButton(
                icon: Icons.delete_outline_rounded,
                label: 'حذف',
                onTap: _deleteVideo,
                color: Colors.redAccent,
                isWarning: true,
              ),
            ),
            const SizedBox(width: 12),
          ],

          // ⛶ تكبير الشاشة (يسار الشاشة)
          Expanded(
            child: _premiumActionButton(
              icon: _isFullScreen
                  ? Icons.fullscreen_exit_rounded
                  : Icons.fullscreen_rounded,
              label: _isFullScreen ? 'تصغير' : 'تكبير',
              onTap: _toggleFullScreen,
              color: AppColor.PrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// زر التحميل بحالة الانتظار (Loading)
  Widget _buildLoadingButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColor.SecondryColor2.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColor.PrimaryColor,
          ),
        ),
      ),
    );
  }

  /// شريط تقدم التحميل بتصميم احترافي (Premium UI)
  Widget _buildDownloadProgress(double progress, String statusText) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColor.PrimaryColor.withOpacity(0.03),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: AppColor.BackGround, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // أيقونة التحميل داخل دائرة
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.PrimaryColor.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_download_rounded,
                  color: AppColor.PrimaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              // النصوص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'جاري التنزيل...',
                      style: TextStyle(
                        color: AppColor.PrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // النسبة المئوية كـ Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColor.SecondryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: AppColor.PrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // شريط التقدم بتصميم عصري (دائري الأطراف + تدرج لوني)
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.BackGround2,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColor.SecondryColor, AppColor.PrimaryColor],
                      begin: Alignment.centerRight, // RTL Direction
                      end: Alignment.centerLeft,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.PrimaryColor.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _premiumActionButton({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    required Color color,
    bool isPrimary = false,
    bool isWarning = false,
  }) {
    final isDisabled = onTap == null;
    final bgColor = isDisabled
        ? Colors.grey.shade100
        : isWarning
        ? Colors.red.shade50
        : isPrimary
        ? AppColor.PrimaryColor
        : AppColor.SecondryColor2.withOpacity(0.3);

    final textColor = isDisabled
        ? Colors.grey.shade400
        : isWarning
        ? Colors.redAccent
        : isPrimary
        ? Colors.white
        : AppColor.PrimaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDisabled
                  ? Colors.transparent
                  : isWarning
                  ? Colors.red.shade200
                  : isPrimary
                  ? Colors.transparent
                  : AppColor.SecondryColor2,
              width: 1,
            ),
            boxShadow: isPrimary && !isDisabled
                ? [
                    BoxShadow(
                      color: AppColor.PrimaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBarButton({required IconData icon, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            color: onTap == null ? Colors.white38 : Colors.white,
            size: 24,
          ),
        ),
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
            if (_isFullScreen) {
              // إذا كان في وضع التكبير، قم بالتصغير فقط ولا تخرج من الصفحة
              _toggleFullScreen();
              return false;
            }
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

              return Stack(
                children: [
                  // ── المحتوى أسفل المشغّل (شريط التحكم والتعليقات) ──
                  if (!_isFullScreen)
                    SafeArea(
                      child: Column(
                        children: [
                          // مساحة محجوزة وهمية بنفس حجم المشغّل تماماً
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: const SizedBox(),
                          ),
                          _buildControlBar(isDownloading: isDownloading),
                          if (isDownloading)
                            Container(
                              color: Colors.white,

                              child: _buildDownloadProgress(
                                task?.progress ?? 0.0,
                                task?.statusText ?? '',
                              ),
                            ),
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
                      ),
                    ),

                  // ── المشغّل (ثابت دائماً في الشجرة لمنع الـ WebView من الانهيار) ──
                  SafeArea(
                    // نلغي الـ SafeArea في وضع التكبير ليملأ الشاشة
                    top: !_isFullScreen,
                    bottom: !_isFullScreen,
                    left: !_isFullScreen,
                    right: !_isFullScreen,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // حساب الحجم النهائي للمشغل بدقة لمنع تغيير حجمه المستمر أثناء دوران الشاشة
                          // التغيير المستمر للحجم هو ما يسبب استنفاذ ذواكر (Buffer) نظام أندرويد وانهيار التطبيق
                          final screenSize = MediaQuery.of(context).size;
                          final maxDim = math.max(
                            screenSize.width,
                            screenSize.height,
                          );
                          final minDim = math.min(
                            screenSize.width,
                            screenSize.height,
                          );

                          final targetWidth = _isFullScreen ? maxDim : minDim;
                          final targetHeight = _isFullScreen
                              ? minDim
                              : (minDim * 9 / 16);

                          return OverflowBox(
                            alignment: Alignment.topCenter,
                            maxWidth: double.infinity,
                            maxHeight: double.infinity,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              curve: Curves.easeInOutCubic,
                              width: _isFullScreen ? maxDim : minDim,
                              height: _isFullScreen
                                  ? minDim
                                  : (minDim * 9 / 16),
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: SizedBox(
                                  width: targetWidth,
                                  height: targetHeight,
                                  child: playerUI,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // ── زر التصغير اليدوي العائم بتأثير تلاشي ناعم ──
                  Positioned(
                    top: 24,
                    left: 24,
                    child: SafeArea(
                      child: AnimatedOpacity(
                        opacity: _isFullScreen ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 350),
                        child: IgnorePointer(
                          ignoring: !_isFullScreen,
                          child: Material(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: _toggleFullScreen,
                              child: const Padding(
                                padding: EdgeInsets.all(12),
                                child: Icon(
                                  Icons.fullscreen_exit_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
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
        const SnackBar(content: Text('لم يتم العثور على صيغ قابلة للتحميل.')),
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
