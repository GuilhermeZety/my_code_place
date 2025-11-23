import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_code_place/app/ui/components/loader.dart';
import 'package:my_code_place/app/ui/theme/app_fonts.dart';

class LoadingModal extends StatelessWidget {
  const LoadingModal({super.key, this.title = 'Carregando...'});

  final String title;

  Future show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => this,
    ).then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppFonts.headline1),
              const Gap(5),
              const Loader(size: 50),
            ],
          ),
        ),
      ),
    );
  }
}
