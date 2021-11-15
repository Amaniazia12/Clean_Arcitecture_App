import 'package:data_connection_checker_tv/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImbl implements NetworkInfo {
  final DataConnectionChecker con;

  NetworkInfoImbl(this.con);
  @override
  Future<bool> get isConnected => con.hasConnection;
}
