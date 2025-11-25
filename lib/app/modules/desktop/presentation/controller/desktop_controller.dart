import 'package:flutter/material.dart' show Offset;
import 'package:my_code_place/app/core/shared/models/desktop_item.dart';
import 'package:signals/signals_flutter.dart';

class DesktopController {
  final items = signal<List<DesktopItem>>([]);

  void addItem() {
    items.add(
      DesktopItem(
        id: items.value.length,
        position: const Offset(100, 100),
        width: 120,
        height: 50,
      ),
    );
  }

  void bringToFront(DesktopItem item) {
    items.remove(item);
    items.add(item);
  }
}
