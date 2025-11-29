import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:my_code_place/app/core/common/extensions/color_extension.dart';
import 'package:my_code_place/app/core/common/extensions/context_extension.dart';
import 'package:my_code_place/app/core/shared/models/card_data.dart';
import 'package:my_code_place/app/core/shared/models/window_data.dart';
import 'package:my_code_place/app/modules/desktop/presentation/controller/desktop_controller.dart';
import 'package:my_code_place/app/ui/components/buy_us_coffe.dart';
import 'package:my_code_place/app/ui/components/windows/window_card.dart';
import 'package:my_code_place/app/ui/components/windows/window_drag_card.dart';
import 'package:my_code_place/app/ui/theme/app_colors.dart';
import 'package:my_code_place/app/ui/theme/app_icons.dart';
import 'package:signals/signals_flutter.dart';

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
        WindowData(
          id: '1',
          title: 'Spotify',
          logo: 'https://upload.wikimedia.org/wikipedia/commons/7/75/Spotify_icon.png',
          rect: const Rect.fromLTWH(50, 50, 300, 200),
        ),
        CardData(
          id: '2',
          rect: Rect.fromLTWH(context.width - 196, context.height - 60, 180, 44),
          content: _buildMenuContent(),
        ),
        CardData(
          id: '3',
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

  Widget _buildMenuContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              AppIcons.apps,
              color: AppColors.grey_300,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              AppIcons.lightning,
              color: AppColors.grey_300,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              AppIcons.settings,
              color: AppColors.grey_300,
            ),
          ),
        ],
      ),
    );
  }
}
