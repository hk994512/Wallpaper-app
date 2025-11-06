import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:wallpaper_setter/wallpaper_setter.dart';

class PreviewScreen extends StatefulWidget {
  final String imagePath;

  const PreviewScreen({super.key, required this.imagePath});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final GlobalKey previewContainer = GlobalKey();

  Future<void> _handleSetWallpaper(String target) async {
    final success = await WallpaperPlugin.setWallpaperFromRepaintBoundary(
      previewContainer,
      target,
    );
    _showSnack(success ? 'Wallpaper set!' : 'Failed to set wallpaper');
  }

  Future<void> _handleUseAs() async {
    final success = await WallpaperPlugin.useAsImageFromRepaintBoundary(
      previewContainer,
    );
    _showSnack(success ? 'Sharing launched!' : 'Use As failed');
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          RepaintBoundary(
            key: previewContainer,
            child: SizedBox.expand(
              child: PhotoView(
                imageProvider: widget.imagePath.startsWith("http")
                    ? NetworkImage(widget.imagePath)
                    : FileImage(File(widget.imagePath)) as ImageProvider,
                backgroundDecoration: const BoxDecoration(color: Colors.black),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!Platform.isIOS) ...[
                  ElevatedButton(
                    onPressed: () => _handleSetWallpaper("home"),
                    child: const Text("Set as Home Screen"),
                  ),
                  ElevatedButton(
                    onPressed: () => _handleSetWallpaper("lock"),
                    child: const Text("Set as Lock Screen"),
                  ),
                  ElevatedButton(
                    onPressed: () => _handleSetWallpaper("both"),
                    child: const Text("Set Both"),
                  ),
                  const SizedBox(height: 10),
                ],
                ElevatedButton.icon(
                  onPressed: () => _handleUseAs(),
                  icon: const Icon(Icons.share),
                  label: const Text("Use As..."),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
