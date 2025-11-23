import 'package:flutter/material.dart';
import 'package:my_code_place/app/ui/components/draggable_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: DraggableCard(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
