import 'package:flutter/material.dart';

/// Mixin Base: Gerencia APENAS o estado e o ciclo de vida da janela.
/// Não contém lógica matemática de movimento.
mixin WindowBaseMixin<T extends StatefulWidget> on State<T> {
  // --- Configurações Comuns ---
  final double handleSize = 10.0;

  // --- Estado ---
  late Rect windowRect;
  bool isDragging = false;

  // --- Contratos (Obrigatórios para todos) ---
  Size get screenSize;
  VoidCallback get onFocus;
  Function(Rect) get onUpdate;

  BorderRadius get getComponentRadius {
    double range = 200;
    Radius defaultRadius = const Radius.circular(20);

    double left = windowRect.left;
    double right = windowRect.right;
    double top = windowRect.top;
    double bottom = windowRect.bottom;

    return BorderRadius.only(
      topLeft: left < range && top < range ? Radius.zero : defaultRadius,
      topRight: right > screenSize.width - range && top < range ? Radius.zero : defaultRadius,
      bottomLeft: left < range && bottom > screenSize.height - range ? Radius.zero : defaultRadius,
      bottomRight: right > screenSize.width - range && bottom > screenSize.height - range
          ? Radius.zero
          : defaultRadius,
    );
  }

  void initWindow(Rect initialRect) {
    windowRect = initialRect;
  }

  void syncWindowIfChanged(Rect externalRect) {
    if (!isDragging && externalRect != windowRect) {
      setState(() {
        windowRect = externalRect;
      });
    }
  }

  void startDrag() {
    setState(() => isDragging = true);
    onFocus();
  }

  void finalizeDrag() {
    setState(() => isDragging = false);
    onUpdate(windowRect);
    onFocus();
  }
}
