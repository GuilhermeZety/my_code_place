import 'package:flutter/material.dart';
import 'package:my_code_place/app/core/shared/entities/draggable_item.dart';
import 'package:my_code_place/app/ui/components/windows/window_drag_card.dart';

// ignore: must_be_immutable
class CardData extends DraggableItem {
  CardData({
    required super.id,
    required super.rect,
    required this.content,
    GlobalKey<WindowDragCardState>? windowKey,
  }) : windowKey = windowKey ?? GlobalKey<WindowDragCardState>();

  final Widget content;
  final GlobalKey<WindowDragCardState> windowKey;

  @override
  double get minWidth => 100;

  @override
  double get minHeight => 44;

  @override
  List<Object?> get props => [id, rect, minWidth, minHeight];
}
