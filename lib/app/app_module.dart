import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:my_code_place/app/core/common/services/connection/connection_service.dart';
import 'package:my_code_place/app/core/common/services/connection/connection_service_impl.dart';
import 'package:my_code_place/app/modules/desktop/desktop_module.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton<ConnectionService>(() => ConnectionServiceImpl());
  }

  @override
  void routes(RouteManager r) {
    //CHILDS
    r.module(
      '/',
      module: DesktopModule(),
      transition: TransitionType.fadeIn,
      duration: 500.ms,
    );
  }
}
