import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class ChatVideoThumbnail extends StatefulWidget {
  final String videoUrl;
  final double height;
  final double width;

  const ChatVideoThumbnail({
    Key? key,
    required this.videoUrl,
    this.height = 200,
    this.width = 250,
  }) : super(key: key);

  @override
  _ChatVideoThumbnailState createState() => _ChatVideoThumbnailState();
}

class _ChatVideoThumbnailState extends State<ChatVideoThumbnail> {
  static final Map<String, String> _thumbnailCache = {};
  Future<String?>? _thumbnailFuture;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  void _loadThumbnail() {
    if (_thumbnailCache.containsKey(widget.videoUrl)) {
      _thumbnailFuture = Future.value(_thumbnailCache[widget.videoUrl]);
    } else {
      _thumbnailFuture = _generateThumbnail(widget.videoUrl);
    }
  }

  @override
  void didUpdateWidget(ChatVideoThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _loadThumbnail();
    }
  }

  Future<String?> _generateThumbnail(String videoPath) async {
    try {
      final String? cachedPath = _thumbnailCache[videoPath];
      if (cachedPath != null && File(cachedPath).existsSync()) {
        return cachedPath;
      }

      final String tempDir = (await getTemporaryDirectory()).path;
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: tempDir,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 200,
        quality: 75,
      );

      if (thumbnailPath != null) {
        _thumbnailCache[videoPath] = thumbnailPath;
      }
      return thumbnailPath;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _thumbnailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Image.file(
            File(snapshot.data!),
            height: widget.height,
            width: widget.width,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholder();
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        } else {
          return _buildPlaceholder();
        }
      },
    );
  }

  Widget _buildLoading() {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Icon(Icons.videocam_off, color: Colors.grey)),
    );
  }
}
