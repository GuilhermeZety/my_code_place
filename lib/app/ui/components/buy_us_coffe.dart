import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_code_place/app/ui/theme/app_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyUsCoffe extends StatelessWidget {
  const BuyUsCoffe({super.key});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          launchUrl(Uri.parse('https://www.buymeacoffee.com/guilherme.martins'));
        },
        child: ColoredBox(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/svgs/coffe.svg',
                  width: 24,
                  height: 24,
                ),

                const Text(
                  'Buy us a coffe?',
                  style: TextStyle(color: Colors.white, fontWeight: AppFonts.semibold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
