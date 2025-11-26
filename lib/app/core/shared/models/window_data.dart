import 'package:my_code_place/app/core/shared/entities/draggable_item.dart';

// ignore: must_be_immutable
class WindowData extends DraggableItem {
  String title;
  String? logo;

  WindowData({
    required super.id,
    required this.title,
    this.logo,
    required super.rect,
  });

  @override
  List<Object?> get props => [id, rect, minWidth, minHeight, title, logo];
}
