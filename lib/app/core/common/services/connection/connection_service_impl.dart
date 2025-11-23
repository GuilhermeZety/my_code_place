import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:my_code_place/app/core/common/services/connection/connection_service.dart';

class ConnectionServiceImpl extends ConnectionService {
  @override
  Future<bool> get isConnected async => [
    ConnectivityResult.mobile,
    ConnectivityResult.wifi,
  ].contains((await Connectivity().checkConnectivity()).first);

  @override
  Future<Stream<bool>> connectionStream() async => Connectivity().onConnectivityChanged.map<bool>(
    (event) => event.first == ConnectivityResult.mobile || event.first == ConnectivityResult.wifi,
  );
}

// mixin ConnectionMixin {
//   final connected = signal(false, debugLabel: 'CONNECTION_MIXIN');
//   StreamSubscription? connectionSubscription;

//   Future setupConnectionListener() async {
//     var service = Modular.get<ConnectionService>();
//     connected.value = await service.isConnected;
//     await service.connectionStream().then((stream) {
//       connectionSubscription = (stream).listen((event) {
//         log('connection changed: $event', name: 'ConnectionService');
//         connected.value = event;
//       });
//     });
//   }

//   void disposeMixin() {
//     connectionSubscription?.cancel();
//     connectionSubscription = null;
//   }
// }
