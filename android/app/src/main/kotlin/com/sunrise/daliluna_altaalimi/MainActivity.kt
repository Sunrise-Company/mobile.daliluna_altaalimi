package com.sunrise.daliluna_altaalimi

import android.content.Context
import android.hardware.display.DisplayManager
import android.os.Bundle
import android.view.Display
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.media.MediaCodec
import android.media.MediaExtractor
import android.media.MediaFormat
import android.media.MediaMuxer
import java.nio.ByteBuffer

class MainActivity : FlutterActivity() {
    private lateinit var displayManager: DisplayManager
    private var overlayView: View? = null

    private val displayListener = object : DisplayManager.DisplayListener {
        override fun onDisplayAdded(displayId: Int) {
            checkForExternalDisplays()
        }

        override fun onDisplayRemoved(displayId: Int) {
            checkForExternalDisplays()
        }

        override fun onDisplayChanged(displayId: Int) {
            checkForExternalDisplays()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // لا نزال نستخدم FLAG_SECURE كطبقة حماية أولى (لمنع لقطات الشاشة)
       window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)

        // تهيئة DisplayManager
        displayManager = getSystemService(Context.DISPLAY_SERVICE) as DisplayManager

        // إنشاء الشاشة السوداء التي سنعرضها عند الحاجة
        setupOverlayView()
    }

    override fun onNewIntent(intent: android.content.Intent) {
        super.onNewIntent(intent)
        // This is crucial for handling notification clicks when app is already running
        setIntent(intent)
    }
    

    override fun onResume() {
        super.onResume()
        // تسجيل الـ Listener عند عودة التطبيق للواجهة
        displayManager.registerDisplayListener(displayListener, null)
        // التحقق فورًا عند تشغيل التطبيق
        checkForExternalDisplays()
    }

    override fun onPause() {
        super.onPause()
        // إلغاء تسجيل الـ Listener عند خروج التطبيق من الواجهة لمنع تسريب الذاكرة
        displayManager.unregisterDisplayListener(displayListener)
    }

    private fun setupOverlayView() {
        // يمكنك هنا تصميم شاشة أكثر تعقيدًا إذا أردت
        overlayView = View(this)
        overlayView?.setBackgroundColor(resources.getColor(android.R.color.black))
    }

    private fun checkForExternalDisplays() {
        // الحصول على قائمة بكل الشاشات المتصلة
        val displays = displayManager.displays
        // شاشة الهاتف هي دائمًا Display.DEFAULT_DISPLAY

        if (displays.size > 1) {
            // إذا كان هناك أكثر من شاشة واحدة، فهذا يعني وجود شاشة خارجية
            // قم بإظهار الشاشة السوداء
            showOverlay()
        } else {
            // إذا كانت شاشة الهاتف هي الوحيدة، قم بإخفاء الشاشة السوداء
            hideOverlay()
        }
    }

    private fun showOverlay() {
        if (overlayView != null && overlayView?.parent == null) {
            val params = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT
            )
            window.addContentView(overlayView, params)
        }
    }

    private fun hideOverlay() {
        if (overlayView != null && overlayView?.parent != null) {
            (window.decorView as ViewGroup).removeView(overlayView)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.example.muxer"
        ).setMethodCallHandler { call, result ->
            if (call.method == "mux") {
                val video = call.argument<String>("video")!!
                val audio = call.argument<String>("audio")!!
                val out = call.argument<String>("out")!!
                try {
                    muxMp4(video, audio, out)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("MUX_ERR", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun muxMp4(video: String, audio: String, out: String) {
        val muxer = MediaMuxer(out, MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4)
        val vExt = MediaExtractor().apply { setDataSource(video) }
        val aExt = MediaExtractor().apply { setDataSource(audio) }

        fun pickTrack(prefix: String, ext: MediaExtractor): Pair<Int, MediaFormat> {
            for (i in 0 until ext.trackCount) {
                val f = ext.getTrackFormat(i)
                val mime = f.getString(MediaFormat.KEY_MIME) ?: ""
                if (mime.startsWith(prefix)) return i to f
            }
            throw IllegalArgumentException("Missing $prefix track")
        }

        val (vSrc, vFmt) = pickTrack("video/", vExt)
        val (aSrc, aFmt) = pickTrack("audio/", aExt)
        vExt.selectTrack(vSrc)
        aExt.selectTrack(aSrc)

        val vDst = muxer.addTrack(vFmt)
        val aDst = muxer.addTrack(aFmt)
        muxer.start()

        fun copy(ext: MediaExtractor, dst: Int) {
            val buf = ByteBuffer.allocate(1 shl 20)
            val info = MediaCodec.BufferInfo()
            while (true) {
                info.offset = 0
                val size = ext.readSampleData(buf, 0)
                if (size < 0) break
                info.size = size
                info.presentationTimeUs = ext.sampleTime
                info.flags = ext.sampleFlags
                muxer.writeSampleData(dst, buf, info)
                ext.advance()
            }
        }

        copy(vExt, vDst)
        copy(aExt, aDst)

        muxer.stop()
        muxer.release()
        vExt.release()
        aExt.release()
    }
}
