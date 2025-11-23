import 'package:flutter/material.dart';
import 'package:my_code_place/app/core/common/extensions/context_extension.dart';

class DraggableCard extends StatefulWidget {
  const DraggableCard({
    super.key,
    this.backgroundColor,
    required this.child,
    this.borderRadius,
  });

  final Color? backgroundColor;
  final Widget child;
  final BorderRadius? borderRadius;

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {
  bool isDragging = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? context.theme.cardColor,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          widget.child,
          MouseRegion(
            cursor: isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab,
            child: GestureDetector(
              onTap: () {
                isDragging = !isDragging;
                setState(() {});
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                child: const Icon(Icons.apps),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
