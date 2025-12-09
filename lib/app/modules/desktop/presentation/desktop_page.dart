import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:my_code_place/app/core/common/extensions/color_extension.dart';
import 'package:my_code_place/app/core/common/extensions/context_extension.dart';
import 'package:my_code_place/app/core/shared/models/card_data.dart';
import 'package:my_code_place/app/core/shared/models/window_data.dart';
import 'package:my_code_place/app/modules/desktop/presentation/controller/desktop_controller.dart';
import 'package:my_code_place/app/ui/components/app_menu_bar.dart';
import 'package:my_code_place/app/ui/components/buy_us_coffe.dart';
import 'package:my_code_place/app/ui/components/windows/window_card.dart';
import 'package:my_code_place/app/ui/components/windows/window_drag_card.dart';
import 'package:signals/signals_flutter.dart';
import 'package:uuid/uuid.dart';

class DesktopPage extends StatefulWidget {
  const DesktopPage({super.key});

  @override
  State<DesktopPage> createState() => _DesktopPageState();
}

class _DesktopPageState extends State<DesktopPage> {
  final DesktopController controller = Modular.get();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.windows.value = [
        CardData(
          id: const Uuid().v4(),
          rect: Rect.fromLTWH((context.width - 196) / 2, context.height - 60, 180, 44),
          content: const AppMenuBar(),
        ),
        CardData(
          id: const Uuid().v4(),
          rect: Rect.fromLTWH(16, context.height - 60, 180, 44),
          content: const BuyUsCoffe(),
        ),
      ];
    });
    super.initState();
  }

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
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Text(
                      'my code place',
                      style: TextStyle(
                        color: Colors.white.changeOpacity(0.05),
                      ),
                    ),
                  ),
                  ...windowList.map((window) {
                    if (window is CardData) {
                      return WindowDragCard(
                        key: ValueKey(window.id),
                        data: window,
                        screenSize: screenSize,
                        onFocus: () => controller.bringToFront(window.id),
                        onUpdate: (rect) => controller.updateWindowRect(window.id, rect),
                      );
                    }
                    return WindowWidget(
                      key: ValueKey(window.id),
                      data: window as WindowData,
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
