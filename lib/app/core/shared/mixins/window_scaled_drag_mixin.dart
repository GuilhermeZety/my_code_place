import 'package:flutter/material.dart';
import 'package:my_code_place/app/core/shared/mixins/window_base_mixin.dart';

/// Mixin para janelas que podem ser redimensionadas proporcionalmente.
mixin WindowScaledDragMixin<T extends StatefulWidget> on State<T>, WindowBaseMixin<T> {
  double get minScale;
  double get maxScale;

  void doScaledMove(Offset delta, Size initialSize) {
    setState(() {
      final scale = windowRect.width / initialSize.width;
      double dx = delta.dx * scale;
      double dy = delta.dy * scale;

      double newLeft = windowRect.left + dx;
      double newTop = windowRect.top + dy;

      newLeft = newLeft.clamp(0.0, screenSize.width - (windowRect.width * (scale < 1 ? scale : 1)));
      newTop = newTop.clamp(0.0, screenSize.height - (windowRect.height * (scale < 1 ? scale : 1)));

      windowRect = Rect.fromLTWH(newLeft, newTop, windowRect.width, windowRect.height);
    });
  }

  void doScaledResize(
    Offset delta,
    Size initialSize,
    double aspectRatio,
    Alignment alignment,
  ) {
    setState(() {
      final double dx = delta.dx;
      final double dy = delta.dy;

      final bool isLeft = alignment.x == -1.0;
      final bool isRight = alignment.x == 1.0;
      final bool isTop = alignment.y == -1.0;
      final bool isBottom = alignment.y == 1.0;

      double newWidth = windowRect.width;

      if (isLeft) {
        newWidth -= dx;
      } else if (isRight) {
        newWidth += dx;
      } else if (isTop) {
        newWidth -= (dy * aspectRatio);
      } else if (isBottom) {
        newWidth += (dy * aspectRatio);
      }

      double minW = initialSize.width * minScale;
      double maxW = initialSize.width * maxScale;
      newWidth = newWidth.clamp(minW, maxW);

      double newHeight = newWidth / aspectRatio;

      if (isRight && (windowRect.left + newWidth > screenSize.width)) {
        newWidth = screenSize.width - windowRect.left;
        newHeight = newWidth / aspectRatio;
      }
      if (isBottom && (windowRect.top + newHeight > screenSize.height)) {
        newHeight = screenSize.height - windowRect.top;
        newWidth = newHeight * aspectRatio;
      }

      double newLeft = windowRect.left;
      double newTop = windowRect.top;

      if (isLeft) {
        newLeft = windowRect.right - newWidth;
      }

      if (isTop) {
        newTop = windowRect.bottom - newHeight;
      }

      if (newLeft < 0) {
        newLeft = 0;
        newWidth = windowRect.right;
        newHeight = newWidth / aspectRatio;
        if (isTop) newTop = windowRect.bottom - newHeight;
      }

      if (newTop < 0) {
        newTop = 0;
        newHeight = windowRect.bottom;
        newWidth = newHeight * aspectRatio;
        if (isLeft) newLeft = windowRect.right - newWidth;
      }

      windowRect = Rect.fromLTWH(newLeft, newTop, newWidth, newHeight);
    });
  }
}
