import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:my_code_place/app/core/shared/models/card_data.dart';
import 'package:my_code_place/app/core/shared/models/window_data.dart';
import 'package:my_code_place/app/modules/desktop/presentation/controller/desktop_controller.dart';
import 'package:my_code_place/app/ui/components/windows/window_card.dart';
import 'package:my_code_place/app/ui/components/windows/window_floating_card.dart';
import 'package:my_code_place/app/ui/theme/app_colors.dart';
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
                    if (window is CardData) {
                      return FloatingCard(
                        key: ValueKey(window.id),
                        data: window,
                        screenSize: screenSize,
                        onFocus: () => controller.bringToFront(window.id),
                        onUpdate: (rect) => controller.updateWindowRect(window.id, rect),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Icon(
                                Icons.apps,
                                color: AppColors.grey_300,
                              ),
                              Icon(
                                Icons.refresh,
                                color: AppColors.grey_300,
                              ),
                              Icon(
                                Icons.settings,
                                color: AppColors.grey_300,
                              ),
                            ],
                          ),
                        ),
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
