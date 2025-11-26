// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
abstract class DraggableItem extends Equatable {
  final String id;
  Rect rect;
  double minWidth = 200;
  double minHeight = 44;

  DraggableItem({
    required this.id,
    required this.rect,
  });
}
