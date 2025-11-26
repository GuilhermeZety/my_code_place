import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_code_place/app/core/common/extensions/color_extension.dart';
import 'package:my_code_place/app/core/shared/models/window_data.dart';
import 'package:my_code_place/app/ui/theme/app_colors.dart';
import 'package:my_code_place/app/ui/theme/app_fonts.dart';

class WindowWidget extends StatefulWidget {
  final WindowData data;
  final Size screenSize;
  final VoidCallback onFocus;
  final Function(Rect) onUpdate;

  const WindowWidget({
    super.key,
    required this.data,
    required this.screenSize,
    required this.onFocus,
    required this.onUpdate,
  });

  @override
  State<WindowWidget> createState() => _WindowWidgetState();
}

class _WindowWidgetState extends State<WindowWidget> {
  late Rect localRect;
  // Variável para saber se o usuário está mexendo na janela agora
  bool _isDragging = false;

  final double handleSize = 5.0;

  double get minWidth => widget.data.minWidth;
  double get minHeight => widget.data.minHeight;
  double get maxWidth => widget.screenSize.width;
  double get maxHeight => widget.screenSize.height;

  @override
  void initState() {
    super.initState();
    localRect = widget.data.rect;
  }

  @override
  void didUpdateWidget(WindowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // --- CORREÇÃO AQUI ---
    // Verificamos se o rect que veio do Pai (Controller) é diferente do que temos Localmente.
    // E só atualizamos se o usuário NÃO estiver arrastando (para não interromper o movimento).
    if (!_isDragging && widget.data.rect != localRect) {
      setState(() {
        localRect = widget.data.rect;
      });
    }
  }

  void _finalizeDrag() {
    setState(() {
      _isDragging = false; // Soltou o mouse
    });
    widget.onUpdate(localRect);
    widget.onFocus();
  }

  void _startDrag() {
    setState(() {
      _isDragging = true; // Começou a mexer
    });
  }

  void _handleMove(Offset delta) {
    setState(() {
      double newLeft = localRect.left + delta.dx;
      double newTop = localRect.top + delta.dy;

      newLeft = newLeft.clamp(0.0, maxWidth - localRect.width);
      newTop = newTop.clamp(0.0, maxHeight - localRect.height);

      localRect = Rect.fromLTWH(newLeft, newTop, localRect.width, localRect.height);
    });
  }

  // --- Lógica de Resize ---
  void _handleResize(
    Offset delta, {
    bool left = false,
    bool right = false,
    bool top = false,
    bool bottom = false,
  }) {
    setState(() {
      double newLeft = localRect.left;
      double newTop = localRect.top;
      double newWidth = localRect.width;
      double newHeight = localRect.height;

      // ... (Lógica matemática igual à anterior) ...
      // --- Horizontal ---
      if (left) {
        double proposedLeft = newLeft + delta.dx;
        if (proposedLeft < 0) proposedLeft = 0;
        double appliedDelta = proposedLeft - newLeft;
        newLeft = proposedLeft;
        newWidth -= appliedDelta;
      } else if (right) {
        newWidth += delta.dx;
        if (newLeft + newWidth > maxWidth) {
          newWidth = maxWidth - newLeft;
        }
      }

      // --- Vertical ---
      if (top) {
        double proposedTop = newTop + delta.dy;
        if (proposedTop < 0) proposedTop = 0;
        double appliedDelta = proposedTop - newTop;
        newTop = proposedTop;
        newHeight -= appliedDelta;
      } else if (bottom) {
        newHeight += delta.dy;
        if (newTop + newHeight > maxHeight) {
          newHeight = maxHeight - newTop;
        }
      }

      if (newWidth < minWidth) {
        if (left) newLeft = localRect.right - minWidth;
        newWidth = minWidth;
      }
      if (newHeight < minHeight) {
        if (top) newTop = localRect.bottom - minHeight;
        newHeight = minHeight;
      }

      localRect = Rect.fromLTWH(newLeft, newTop, newWidth, newHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: localRect.left,
      top: localRect.top,
      width: localRect.width,
      height: localRect.height,
      child: GestureDetector(
        onTapDown: (_) => widget.onFocus(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildWindowStructure(),
            ..._resizeHandlers,
          ],
        ),
      ),
    );
  }

  List get _resizeHandlers => [
    _buildHandle(
      top: 0,
      left: 0,
      cursor: SystemMouseCursors.resizeUpLeft,
      onDrag: (d) => _handleResize(d, top: true, left: true),
    ),
    _buildHandle(
      top: 0,
      right: 0,
      cursor: SystemMouseCursors.resizeUpRight,
      onDrag: (d) => _handleResize(d, top: true, right: true),
    ),
    _buildHandle(
      bottom: 0,
      left: 0,
      cursor: SystemMouseCursors.resizeDownLeft,
      onDrag: (d) => _handleResize(d, bottom: true, left: true),
    ),
    _buildHandle(
      bottom: 0,
      right: 0,
      cursor: SystemMouseCursors.resizeDownRight,
      onDrag: (d) => _handleResize(d, bottom: true, right: true),
    ),
    _buildHandle(
      top: handleSize,
      bottom: handleSize,
      left: 0,
      width: handleSize,
      cursor: SystemMouseCursors.resizeLeft,
      onDrag: (d) => _handleResize(d, left: true),
    ),
    _buildHandle(
      top: handleSize,
      bottom: handleSize,
      right: 0,
      width: handleSize,
      cursor: SystemMouseCursors.resizeRight,
      onDrag: (d) => _handleResize(d, right: true),
    ),
    _buildHandle(
      left: handleSize,
      right: handleSize,
      top: 0,
      height: handleSize,
      cursor: SystemMouseCursors.resizeUp,
      onDrag: (d) => _handleResize(d, top: true),
    ),
    _buildHandle(
      left: handleSize,
      right: handleSize,
      bottom: 0,
      height: handleSize,
      cursor: SystemMouseCursors.resizeDown,
      onDrag: (d) => _handleResize(d, bottom: true),
    ),
  ];

  BorderRadius get _getComponentRadius {
    double range = 200;
    Radius defaultRadius = const Radius.circular(20);

    return BorderRadius.only(
      topLeft: localRect.left < range && localRect.top < range ? Radius.zero : defaultRadius,
      topRight: localRect.right > maxWidth - range && localRect.top < range
          ? Radius.zero
          : defaultRadius,
      bottomLeft: localRect.left < range && localRect.bottom > maxHeight - range
          ? Radius.zero
          : defaultRadius,
      bottomRight: localRect.right > maxWidth - range && localRect.bottom > maxHeight - range
          ? Radius.zero
          : defaultRadius,
    );
  }

  Widget _buildWindowStructure() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: AppColors.grey_800,
        borderRadius: _getComponentRadius,
        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          GestureDetector(
            onPanStart: (_) => _startDrag(),
            onPanUpdate: (details) => _handleMove(details.delta),
            onPanEnd: (_) => _finalizeDrag(),
            child: _buildWindowAppBar(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12, left: 12, bottom: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildWindowContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    double? width,
    double? height,
    required SystemMouseCursor cursor,
    required Function(Offset) onDrag,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      width: (left != null && right != null) ? null : (width ?? handleSize),
      height: (top != null && bottom != null) ? null : (height ?? handleSize),
      child: MouseRegion(
        cursor: cursor,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          // Adicionei onPanStart aqui também
          onPanStart: (_) => _startDrag(),
          onPanUpdate: (details) => onDrag(details.delta),
          onPanEnd: (_) => _finalizeDrag(),
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  Widget _buildWindowAppBar() {
    return Container(
      height: widget.data.minHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.data.logo ?? ''),
            ),
          ),
          Text(
            widget.data.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: AppFonts.semibold,
            ),
          ),
          const Icon(
            Icons.close_rounded,
            size: 20,
            color: AppColors.grey_700,
          ),
        ],
      ),
    );
  }

  Widget _buildWindowContent() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.changeOpacity(0.1),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
    );
  }
}
