import 'package:flutter/material.dart' show Rect, Size;
import 'package:my_code_place/app/core/shared/models/window_data.dart';
import 'package:signals/signals_flutter.dart';

class DesktopController {
  final windows = signal<List<WindowData>>([
    WindowData(
      id: '1',
      title: 'Spotify',
      logo: 'https://upload.wikimedia.org/wikipedia/commons/7/75/Spotify_icon.png',
      rect: const Rect.fromLTWH(50, 50, 300, 200),
    ),
  ]);

  void bringToFront(String id) {
    final currentList = [...windows.value];
    final index = currentList.indexWhere((w) => w.id == id);
    if (index == -1) return;

    final window = currentList.removeAt(index);
    currentList.add(window);
    windows.value = currentList;
  }

  void updateWindowRect(String id, Rect newRect) {
    // A validação de limites agora é feita visualmente no Widget,
    // aqui apenas salvamos o resultado final.
    final currentList = [...windows.value];
    final index = currentList.indexWhere((w) => w.id == id);
    if (index != -1) {
      currentList[index].rect = newRect;
      windows.value = currentList;
    }
  }

  /// Chamado automaticamente quando o tamanho da tela muda (ex: resize do navegador)
  void reorganizeWindows(Size newScreenSize) {
    final currentList = [...windows.value]; // Cópia da lista
    bool hasChanges = false;

    for (int i = 0; i < currentList.length; i++) {
      final window = currentList[i];
      Rect rect = window.rect;

      double newLeft = rect.left;
      double newTop = rect.top;
      double newWidth = rect.width;
      double newHeight = rect.height;

      // 1. A janela é maior que a nova tela? Redimensiona a janela.
      if (newWidth > newScreenSize.width) {
        newWidth = newScreenSize.width;
      }
      if (newHeight > newScreenSize.height) {
        newHeight = newScreenSize.height;
      }

      // 2. A janela está fora à DIREITA? Puxa de volta.
      // (rect.left + width) > screenWidth
      if (newLeft + newWidth > newScreenSize.width) {
        newLeft = newScreenSize.width - newWidth;
      }

      // 3. A janela está fora EMBAIXO? Puxa de volta.
      // (rect.top + height) > screenHeight
      if (newTop + newHeight > newScreenSize.height) {
        newTop = newScreenSize.height - newHeight;
      }

      // 4. Garantia final (nunca negativo)
      if (newLeft < 0) newLeft = 0;
      if (newTop < 0) newTop = 0;

      // Verifica se houve mudança matemática
      final newRect = Rect.fromLTWH(newLeft, newTop, newWidth, newHeight);

      if (rect != newRect) {
        currentList[i].rect = newRect;
        hasChanges = true;
      }
    }

    // Só notifica os listeners (tela) se houver mudança real
    // Isso evita loops infinitos de renderização
    if (hasChanges) {
      windows.value = currentList;
    }
  }
}
