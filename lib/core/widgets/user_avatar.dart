import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserAvatar extends ConsumerStatefulWidget {
  final double size;
  final VoidCallback? onTap;

  const UserAvatar({super.key, this.size = 40, this.onTap});

  @override
  ConsumerState<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends ConsumerState<UserAvatar> {
  bool _imageLoadFailed = false;
  bool _loggedOnce = false;

  @override
  Widget build(BuildContext context) {
    final storage = ref.watch(secureStorageServiceProvider);

    // If image already failed, just show default icon
    if (_imageLoadFailed) {
      return _buildDefaultAvatar(context);
    }

    return FutureBuilder<String?>(
      future: storage.getUserImage(),
      builder: (context, snapshot) {
        final imageData = snapshot.data;

        if (imageData == null ||
            imageData.isEmpty ||
            imageData == 'No Image Found' ||
            _imageLoadFailed) {
          return _buildDefaultAvatar(context);
        }

        if (imageData.startsWith('http://') || imageData.startsWith('https://')) {
          if (kDebugMode && !_loggedOnce) {
            debugPrint('[USER_AVATAR] Loading image from URL: $imageData');
            _loggedOnce = true;
          }

          final avatarContent = CircleAvatar(
            radius: widget.size / 2,
            backgroundImage: NetworkImage(imageData),
            backgroundColor: Colors.white,
            onBackgroundImageError: (exception, stackTrace) {
              if (kDebugMode) {
                debugPrint('[USER_AVATAR] Failed to load image from URL: $exception');
              }
              if (mounted) {
                setState(() => _imageLoadFailed = true);
              }
            },
          );

          if (widget.onTap != null) {
            return GestureDetector(onTap: widget.onTap, child: avatarContent);
          }

          return avatarContent;
        }

        try {
          String cleanBase64 = imageData
              .replaceAll(RegExp(r'\s+'), '')
              .replaceAll('\n', '')
              .replaceAll('\r', '')
              .trim();

          if (cleanBase64.contains('base64,')) {
            cleanBase64 = cleanBase64.split('base64,').last;
          }

          final imageBytes = base64Decode(cleanBase64);

          final avatarContent = CircleAvatar(
            radius: widget.size / 2,
            backgroundImage: MemoryImage(imageBytes),
            backgroundColor: Colors.white,
            onBackgroundImageError: (exception, stackTrace) {
              if (kDebugMode && !_loggedOnce) {
                debugPrint('[USER_AVATAR] Image decode failed: $exception');
                _loggedOnce = true;
              }
              if (mounted) {
                setState(() => _imageLoadFailed = true);
              }
            },
          );

          if (widget.onTap != null) {
            return GestureDetector(onTap: widget.onTap, child: avatarContent);
          }

          return avatarContent;
        } catch (e) {
          if (kDebugMode && !_loggedOnce) {
            debugPrint('[USER_AVATAR] Failed to process image: $e');
            _loggedOnce = true;
          }
          _imageLoadFailed = true;
          return _buildDefaultAvatar(context);
        }
      },
    );
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    final avatarContent = CircleAvatar(
      radius: widget.size / 2,
      backgroundColor: Colors.white,
      child: Icon(
        Icons.person,
        size: widget.size * 0.6,
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    if (widget.onTap != null) {
      return GestureDetector(onTap: widget.onTap, child: avatarContent);
    }

    return avatarContent;
  }
}
