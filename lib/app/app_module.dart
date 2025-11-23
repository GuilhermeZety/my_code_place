import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:my_code_place/app/core/common/services/connection/connection_service.dart';
import 'package:my_code_place/app/core/common/services/connection/connection_service_impl.dart';
import 'package:my_code_place/app/modules/home/presentation/home_page.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton<ConnectionService>(() => ConnectionServiceImpl());
  }

  @override
  void routes(RouteManager r) {
    //CHILDS
    r.child(
      '/',
      child: (_) => const HomePage(),
      transition: TransitionType.fadeIn,
      duration: 500.ms,
    );
    // r.child(
    //   '/not_connected/',
    //   child: (args) => const NotConnectedPage(),
    //   transition: TransitionType.fadeIn,
    //   duration: 800.ms,
    // );
    // r.wildcard(
    //   child: (args) => const NotFoundPage(),
    //   transition: TransitionType.fadeIn,
    //   duration: 800.ms,
    // );
  }
}
