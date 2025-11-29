import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_code_place/app/core/common/extensions/color_extension.dart';
import 'package:my_code_place/app/core/shared/mixins/window_base_mixin.dart';
// Importe seu Mixin
import 'package:my_code_place/app/core/shared/mixins/window_resize_drag_mixin.dart';
import 'package:my_code_place/app/core/shared/models/window_data.dart';
import 'package:my_code_place/app/ui/components/windows/window_handle.dart';
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

// 1. Adicione o Mixin
class _WindowWidgetState extends State<WindowWidget> with WindowBaseMixin, WindowResizeDragMixin {
  // --- Implementação dos Contratos do Mixin ---
  @override
  Size get screenSize => widget.screenSize;

  @override
  double get minWidth => widget.data.minWidth;
  @override
  double get minHeight => widget.data.minHeight;

  @override
  VoidCallback get onFocus => widget.onFocus;
  @override
  Function(Rect) get onUpdate => widget.onUpdate;
  // ---------------------------------------------

  @override
  void initState() {
    super.initState();
    initWindow(widget.data.rect);
  }

  @override
  void didUpdateWidget(WindowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncWindowIfChanged(widget.data.rect);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: windowRect.left,
      top: windowRect.top,
      width: windowRect.width,
      height: windowRect.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildWindowStructure(),
          ..._buildResizeHandlers(),
        ],
      ),
    );
  }

  Widget _buildWindowStructure() {
    return AnimatedContainer(
      duration: 300.ms,
      decoration: BoxDecoration(
        color: AppColors.grey_800,
        // getComponentRadius vem do Mixin
        borderRadius: getComponentRadius,
        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          MouseRegion(
            cursor: isDragging ? SystemMouseCursors.grabbing : MouseCursor.defer,
            child: GestureDetector(
              onPanStart: (_) => startDrag(),
              onPanUpdate: (details) => doMove(details.delta),
              onPanEnd: (_) => finalizeDrag(),
              child: _buildWindowAppBar(),
            ),
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

  List<Widget> _buildResizeHandlers() {
    return WindowHandle.buildHandlers(
      alignments: [
        Alignment.topLeft,
        Alignment.topCenter,
        Alignment.topRight,
        Alignment.centerRight,
        Alignment.bottomRight,
        Alignment.bottomCenter,
        Alignment.bottomLeft,
        Alignment.centerLeft,
      ],
      onStartDrag: startDrag,
      onEndDrag: finalizeDrag,
      onDrag: (delta, alignment) => doResize(
        delta,
        alignment,
      ),
    );
  }

  // _buildWindowAppBar e _buildWindowContent permanecem iguais
  Widget _buildWindowAppBar() {
    return Container(
      height: widget.data.minHeight, // ou valor fixo se preferir
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
      decoration: BoxDecoration(
        color: Colors.white.changeOpacity(0.1),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
      ),
    );
  }
}
