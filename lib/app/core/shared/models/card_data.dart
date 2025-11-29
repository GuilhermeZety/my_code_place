import 'package:my_code_place/app/core/shared/entities/draggable_item.dart';

// ignore: must_be_immutable
class CardData extends DraggableItem {
  CardData({
    required super.id,
    required super.rect,
  });

  @override
  double get minWidth => 100;

  @override
  double get minHeight => 44;

  @override
  List<Object?> get props => [id, rect, minWidth, minHeight];
}
