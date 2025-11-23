abstract class ConnectionService {
  Future<bool> get isConnected;
  Future<Stream<bool>> connectionStream();
}
