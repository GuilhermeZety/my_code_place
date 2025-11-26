import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:my_code_place/app/modules/desktop/presentation/controller/desktop_controller.dart';
import 'package:my_code_place/app/ui/components/window_widget.dart';
import 'package:signals/signals_flutter.dart';

class DesktopPage extends StatefulWidget {
  const DesktopPage({super.key});

  @override
  State<DesktopPage> createState() => _DesktopPageState();
}

class _DesktopPageState extends State<DesktopPage> {
  final DesktopController controller = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenSize = Size(constraints.maxWidth, constraints.maxHeight);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.reorganizeWindows(screenSize);
          });

          return Watch.builder(
            builder: (context) {
              final windowList = controller.windows.value;
              return Stack(
                children: [
                  ...windowList.map((window) {
                    return WindowWidget(
                      key: ValueKey(window.id),
                      data: window,
                      screenSize: screenSize,
                      onFocus: () => controller.bringToFront(window.id),
                      onUpdate: (rect) => controller.updateWindowRect(window.id, rect),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
