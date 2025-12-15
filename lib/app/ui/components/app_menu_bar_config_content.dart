import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:my_code_place/app/core/common/extensions/context_extension.dart';
import 'package:my_code_place/app/core/shared/models/window_data.dart';
import 'package:my_code_place/app/modules/desktop/presentation/controller/desktop_controller.dart';
import 'package:my_code_place/app/ui/theme/app_colors.dart';
import 'package:uuid/uuid.dart';

class AppMenuBarConfigContent extends StatelessWidget {
  const AppMenuBarConfigContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<DesktopController>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.grey_800,
        border: Border.all(color: AppColors.grey_900, width: 2),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            dense: true,
            title: const Text('Configurações', style: TextStyle(color: AppColors.grey_600)),
            onTap: () {
              controller.addNewWindow(
                WindowData(
                  id: const Uuid().v4(),
                  title: 'Novo Janela',
                  rect: Rect.fromLTWH(context.width / 2, context.height / 2, 300, 200),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
