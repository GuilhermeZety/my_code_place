import 'package:flutter/material.dart';
import 'package:my_code_place/app/ui/components/anchored_menu_wrapper.dart';
import 'package:my_code_place/app/ui/components/app_menu_bar_config_content.dart';
import 'package:my_code_place/app/ui/components/windows/window_drag_card.dart';
import 'package:my_code_place/app/ui/theme/app_colors.dart';
import 'package:my_code_place/app/ui/theme/app_icons.dart';

class AppMenuBar extends StatelessWidget {
  const AppMenuBar({super.key, required this.windowKey});

  final GlobalKey<WindowDragCardState> windowKey;

  @override
  Widget build(BuildContext context) {
    double windowScale = windowKey.currentState?.scale ?? 1.0;
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          AppMenuBarItem(
            icon: AppIcons.apps,
            menuSize: const Size(200, 150),
            menuContent: _buildMenuContent('Perfil', ['Meus Dados', 'Sair']),
            windowScale: windowScale,
          ),
          AppMenuBarItem(
            icon: AppIcons.lightning,
            menuSize: const Size(200, 150),
            menuContent: _buildMenuContent('Perfil', ['Meus Dados', 'Sair']),
            windowScale: windowScale,
          ),
          AppMenuBarItem(
            icon: AppIcons.settings,
            menuSize: const Size(200, 150),
            menuContent: const AppMenuBarConfigContent(),
            windowScale: windowScale,
          ),
        ],
      ),
    );
  }

  // Apenas um helper para criar o visual do menu interno (o tooltip)
  Widget _buildMenuContent(String title, List<String> items) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.grey_800,
        border: Border.all(color: AppColors.grey_900, width: 2),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: items
            .map(
              (item) => ListTile(
                dense: true,
                title: Text(item, style: const TextStyle(color: AppColors.grey_600)),
                onTap: () {},
              ),
            )
            .toList(),
      ),
    );
  }
}

class AppMenuBarItem extends StatefulWidget {
  const AppMenuBarItem({
    super.key,
    required this.icon,
    required this.menuContent,
    required this.menuSize,
    required this.windowScale,
  });

  final IconData icon;
  final Widget menuContent;
  final Size menuSize;
  final double windowScale;

  @override
  State<AppMenuBarItem> createState() => _AppMenuBarItemState();
}

class _AppMenuBarItemState extends State<AppMenuBarItem> {
  bool _isHoovered = false;
  final GlobalKey<AnchoredMenuWrapperState> _menuStateKey = GlobalKey<AnchoredMenuWrapperState>();

  @override
  Widget build(BuildContext context) {
    final Color iconColor = _isHoovered ? AppColors.white : AppColors.grey_300;

    return AnchoredMenuWrapper(
      key: _menuStateKey,
      menuSize: widget.menuSize,
      menuContent: widget.menuContent,
      windowScale: widget.windowScale,
      child: IconButton(
        onPressed: () {
          var currentState = _menuStateKey.currentState!;
          if (currentState.isOpen) {
            currentState.closeOverlay();
          } else {
            currentState.showOverlay();
          }
        },
        onHover: (isHovered) {
          setState(() {
            _isHoovered = isHovered;
          });
        },
        icon: Icon(
          widget.icon,
          color: iconColor,
        ),
      ),
    );
  }
}
