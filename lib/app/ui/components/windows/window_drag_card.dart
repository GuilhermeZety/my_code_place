import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_code_place/app/core/common/extensions/color_extension.dart';
import 'package:my_code_place/app/core/common/extensions/widget/widget_extension.dart';
import 'package:my_code_place/app/core/shared/mixins/window_base_mixin.dart';
import 'package:my_code_place/app/core/shared/mixins/window_scaled_drag_mixin.dart';
// Importe o seu mixin
import 'package:my_code_place/app/core/shared/models/card_data.dart';
import 'package:my_code_place/app/ui/components/windows/window_handle.dart';
import 'package:my_code_place/app/ui/theme/app_colors.dart';
import 'package:my_code_place/app/ui/theme/app_icons.dart';

class WindowDragCard extends StatefulWidget {
  final CardData data;
  final Size screenSize;
  final VoidCallback onFocus;
  final Function(Rect) onUpdate;

  const WindowDragCard({
    super.key,
    required this.data,
    required this.screenSize,
    required this.onFocus,
    required this.onUpdate,
  });

  @override
  State<WindowDragCard> createState() => WindowDragCardState();
}

// 1. Adicione o Mixin aqui
class WindowDragCardState extends State<WindowDragCard>
    with WindowBaseMixin, WindowScaledDragMixin {
  late Size initialSize;
  late double aspectRatio;

  // Implementar contratos Base
  @override
  Size get screenSize => widget.screenSize;
  @override
  VoidCallback get onFocus => widget.onFocus;
  @override
  Function(Rect) get onUpdate => widget.onUpdate;

  // Implementar contratos Scaled
  @override
  double get minScale => 0.9;
  @override
  double get maxScale => 2.0;

  double get scale => windowRect.width / initialSize.width;

  @override
  void initState() {
    super.initState();
    initialSize = Size(widget.data.rect.width, widget.data.rect.height);
    aspectRatio = initialSize.width / initialSize.height;

    initWindow(widget.data.rect);
  }

  @override
  void didUpdateWidget(WindowDragCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncWindowIfChanged(widget.data.rect);
  }

  @override
  Widget build(BuildContext context) {
    // windowRect vem do Mixin
    return Positioned(
      left: windowRect.left,
      top: windowRect.top,
      width: windowRect.width,
      height: windowRect.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildScaledContent(),
          ..._buildResizeHandlers(),
        ],
      ),
    );
  }

  Widget _buildScaledContent() {
    return Transform(
      transform: Matrix4.diagonal3Values(scale, scale, 1.0),
      alignment: Alignment.topLeft,
      child: AnimatedContainer(
        duration: 300.ms,
        width: initialSize.width,
        height: initialSize.height,
        decoration: BoxDecoration(
          color: AppColors.grey_800,
          borderRadius: getComponentRadius,
          border: Border.all(
            color: AppColors.grey_900,
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.changeOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.data.content.expanded(),

            MouseRegion(
              cursor: isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
              child: GestureDetector(
                onPanStart: (_) => startDrag(),
                onPanUpdate: (details) {
                  // 5. Usa o método de MOVE ESCALADO do Mixin
                  doScaledMove(details.delta, initialSize);
                },
                onPanEnd: (_) => finalizeDrag(),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  color: Colors.transparent,
                  child: const Icon(
                    AppIcons.grip,
                    size: 20,
                    color: AppColors.grey_700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildResizeHandlers() {
    return WindowHandle.buildHandlers(
      alignments: [
        Alignment.topLeft,
        Alignment.topCenter,
        Alignment.bottomCenter,
        Alignment.bottomLeft,
        Alignment.centerLeft,
      ],
      onStartDrag: startDrag,
      onEndDrag: finalizeDrag,
      onDrag: (delta, alignment) => doScaledResize(
        delta,
        initialSize,
        aspectRatio,
        alignment,
      ),
    );
  }
}
