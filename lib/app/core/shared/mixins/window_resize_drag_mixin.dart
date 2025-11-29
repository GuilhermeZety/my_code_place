import 'package:flutter/material.dart';
import 'package:my_code_place/app/core/shared/mixins/window_base_mixin.dart'; // Importe a base

/// Mixin para janelas que podem ser redimensionadas linearmente.
mixin WindowResizeDragMixin<T extends StatefulWidget> on State<T>, WindowBaseMixin<T> {
  double get minWidth;
  double get minHeight;

  void doMove(Offset delta) {
    setState(() {
      double newLeft = windowRect.left + delta.dx;
      double newTop = windowRect.top + delta.dy;

      newLeft = newLeft.clamp(0.0, screenSize.width - windowRect.width);
      newTop = newTop.clamp(0.0, screenSize.height - windowRect.height);

      windowRect = Rect.fromLTWH(newLeft, newTop, windowRect.width, windowRect.height);
    });
  }

  void doResize(Offset delta, Alignment alignment) {
    setState(() {
      final bool isLeft = alignment.x == -1.0;
      final bool isRight = alignment.x == 1.0;
      final bool isTop = alignment.y == -1.0;
      final bool isBottom = alignment.y == 1.0;

      double newLeft = windowRect.left;
      double newTop = windowRect.top;
      double newWidth = windowRect.width;
      double newHeight = windowRect.height;

      if (isLeft) {
        double proposedLeft = newLeft + delta.dx;
        if (proposedLeft < 0) proposedLeft = 0;
        double appliedDelta = proposedLeft - newLeft;

        newLeft = proposedLeft;
        newWidth -= appliedDelta;
      } else if (isRight) {
        newWidth += delta.dx;
        if (newLeft + newWidth > screenSize.width) {
          newWidth = screenSize.width - newLeft;
        }
      }

      if (isTop) {
        double proposedTop = newTop + delta.dy;
        if (proposedTop < 0) proposedTop = 0;

        double appliedDelta = proposedTop - newTop;

        newTop = proposedTop;
        newHeight -= appliedDelta;
      } else if (isBottom) {
        newHeight += delta.dy;
        if (newTop + newHeight > screenSize.height) {
          newHeight = screenSize.height - newTop;
        }
      }

      if (newWidth < minWidth) {
        if (isLeft) {
          newLeft = windowRect.right - minWidth;
        }
        newWidth = minWidth;
      }

      if (newHeight < minHeight) {
        if (isTop) {
          newTop = windowRect.bottom - minHeight;
        }
        newHeight = minHeight;
      }

      windowRect = Rect.fromLTWH(newLeft, newTop, newWidth, newHeight);
    });
  }
}
