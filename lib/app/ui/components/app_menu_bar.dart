import 'package:flutter/material.dart';
import 'package:my_code_place/app/core/common/extensions/color_extension.dart';
import 'package:my_code_place/app/ui/components/anchored_menu_wrapper.dart';
import 'package:my_code_place/app/ui/theme/app_colors.dart';
import 'package:my_code_place/app/ui/theme/app_icons.dart';

class AppMenuBar extends StatelessWidget {
  const AppMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          AppMenuBarItem(
            icon: AppIcons.apps,
            menuSize: const Size(200, 150),
            menuContent: _buildMenuContent('Perfil', ['Meus Dados', 'Sair']),
          ),
          AppMenuBarItem(
            icon: AppIcons.lightning,
            menuSize: const Size(200, 150),
            menuContent: _buildMenuContent('Perfil', ['Meus Dados', 'Sair']),
          ),
          AppMenuBarItem(
            icon: AppIcons.settings,
            menuSize: const Size(200, 150),
            menuContent: _buildMenuContent('Perfil', ['Meus Dados', 'Sair']),
          ),
        ],
      ),
    );
  }

  // Apenas um helper para criar o visual do menu interno (o tooltip)
  Widget _buildMenuContent(String title, List<String> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey_800,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey_800.changeOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.grey_700,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: items
                  .map(
                    (item) => ListTile(
                      dense: true,
                      title: Text(item, style: const TextStyle(color: AppColors.grey_600)),
                      onTap: () {
                        print('Clicou em $item');
                        // Lógica para fechar o menu poderia ser injetada aqui
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
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
  });

  final IconData icon;
  final Widget menuContent;
  final Size menuSize;

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
