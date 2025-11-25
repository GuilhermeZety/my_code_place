// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show Offset;

class DesktopItem extends Equatable {
  final int id;
  Offset position;
  double width;
  double height;

  DesktopItem({
    required this.id,
    required this.position,
    required this.width,
    required this.height,
  });

  @override
  List<Object?> get props => [id, position];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'position': {
        'dx': position.dx,
        'dy': position.dy,
      },
      'width': width,
      'height': height,
    };
  }

  factory DesktopItem.fromMap(Map<String, dynamic> map) {
    return DesktopItem(
      id: map['id'] as int,
      position: Offset(
        map['position']['dx'] as double,
        map['position']['dy'] as double,
      ),
      width: map['width'] as double,
      height: map['height'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory DesktopItem.fromJson(String source) =>
      DesktopItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
