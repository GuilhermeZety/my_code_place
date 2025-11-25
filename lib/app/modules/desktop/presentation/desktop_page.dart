import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:my_code_place/app/core/common/extensions/context_extension.dart';
import 'package:my_code_place/app/modules/desktop/presentation/controller/desktop_controller.dart';
import 'package:my_code_place/app/ui/components/draggable_card.dart';
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
      appBar: AppBar(
        title: const Text('Card com Área de Drag'),
        actions: [
          IconButton(
            onPressed: controller.addItem,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Stack(
          children: [
            for (var item in controller.items.watch(context))
              DraggableCard(
                item: item,
                child: Container(
                  width: 20,
                  height: 20,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
