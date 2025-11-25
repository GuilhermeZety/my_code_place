import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:my_code_place/app/modules/desktop/presentation/controller/desktop_controller.dart';
import 'package:my_code_place/app/modules/desktop/presentation/desktop_page.dart';

class DesktopModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton<DesktopController>(() => DesktopController());
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    //CHILDS
    r.child(
      '/',
      child: (_) => const DesktopPage(),
      transition: TransitionType.fadeIn,
      duration: 500.ms,
    );
  }
}
