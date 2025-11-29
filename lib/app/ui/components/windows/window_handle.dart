import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WindowHandle extends StatelessWidget {
  const WindowHandle({
    super.key,
    required this.onStartDrag,
    required this.onEndDrag,
    required this.alignment,
    required this.onDrag,
  });

  static List<WindowHandle> buildHandlers({
    required List<Alignment> alignments,
    required VoidCallback onStartDrag,
    required VoidCallback onEndDrag,
    required Function(Offset delta, Alignment alignment) onDrag,
  }) {
    return alignments
        .map(
          (e) => WindowHandle(
            onStartDrag: onStartDrag,
            onEndDrag: onEndDrag,
            onDrag: onDrag,
            alignment: e,
          ),
        )
        .toList();
  }

  final double handleSize = 10;
  final VoidCallback onStartDrag;
  final VoidCallback onEndDrag;
  final Function(Offset delta, Alignment alignment) onDrag;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    // 1. Determina as direções baseadas no alinhamento (x: -1, 0, 1 | y: -1, 0, 1)
    final isTop = alignment.y == -1.0;
    final isBottom = alignment.y == 1.0;
    final isLeft = alignment.x == -1.0;
    final isRight = alignment.x == 1.0;

    // Verifica se é um handler de "lado" (meio) ou de "canto"
    final isVerticalSide = alignment.y == 0.0; // centerLeft, centerRight
    final isHorizontalSide = alignment.x == 0.0; // topCenter, bottomCenter

    return Positioned(
      top: isTop ? 0 : (isVerticalSide ? handleSize : null),
      bottom: isBottom ? 0 : (isVerticalSide ? handleSize : null),
      left: isLeft ? 0 : (isHorizontalSide ? handleSize : null),
      right: isRight ? 0 : (isHorizontalSide ? handleSize : null),
      width: isVerticalSide ? handleSize : (isHorizontalSide ? null : handleSize),
      height: isHorizontalSide ? handleSize : (isVerticalSide ? null : handleSize),
      child: MouseRegion(
        cursor: _getCursorForAlignment(alignment),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: (_) => onStartDrag(),
          onPanUpdate: (details) => onDrag(details.delta, alignment),
          onPanEnd: (_) => onEndDrag(),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }

  // Helper para pegar o cursor correto baseado no Alignment
  SystemMouseCursor _getCursorForAlignment(Alignment alignment) {
    if (alignment == Alignment.topLeft) return SystemMouseCursors.resizeUpLeft;
    if (alignment == Alignment.topRight) return SystemMouseCursors.resizeUpRight;
    if (alignment == Alignment.bottomLeft) return SystemMouseCursors.resizeDownLeft;
    if (alignment == Alignment.bottomRight) return SystemMouseCursors.resizeDownRight;
    if (alignment == Alignment.topCenter) return SystemMouseCursors.resizeUp;
    if (alignment == Alignment.bottomCenter) return SystemMouseCursors.resizeDown;
    if (alignment == Alignment.centerLeft) return SystemMouseCursors.resizeLeft;
    if (alignment == Alignment.centerRight) return SystemMouseCursors.resizeRight;
    return SystemMouseCursors.basic;
  }
}
