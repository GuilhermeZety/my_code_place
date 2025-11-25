import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:my_code_place/app/core/common/extensions/context_extension.dart';
import 'package:my_code_place/app/core/shared/models/desktop_item.dart';
import 'package:my_code_place/app/modules/desktop/presentation/controller/desktop_controller.dart';
import 'package:my_code_place/app/ui/theme/app_colors.dart';

class DraggableCard extends StatefulWidget {
  const DraggableCard({
    super.key,
    this.backgroundColor,
    required this.child,
    required this.item,
  });

  final Color? backgroundColor;
  final Widget child;
  final DesktopItem item;

  @override
  State<DraggableCard> createState() => DraggableCardState();
}

class DraggableCardState extends State<DraggableCard> {
  final DesktopController controller = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.item.position.dx,
      top: widget.item.position.dy,
      child: GestureDetector(
        onTapDown: (_) => controller.bringToFront(widget.item),
        child: AnimatedContainer(
          duration: 200.ms,
          width: widget.item.width,
          height: widget.item.height,
          decoration: BoxDecoration(
            color: AppColors.grey_800,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                child: widget.child,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanEnd: (details) {
                  controller.bringToFront(widget.item);
                },
                onPanUpdate: (details) {
                  setState(() {
                    final newX = widget.item.position.dx + details.delta.dx;
                    final newY = widget.item.position.dy + details.delta.dy;

                    widget.item.position = Offset(
                      newX.clamp(0, context.width - widget.item.width),
                      newY.clamp(0, context.height - widget.item.height),
                    );
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.grey_800,
                    borderRadius: .circular(20),
                  ),
                  child: const Icon(
                    Icons.drag_indicator_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
