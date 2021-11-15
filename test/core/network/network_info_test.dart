import 'package:architecture/core/network/network_info.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'network_info_test.mocks.dart';

@GenerateMocks([DataConnectionChecker])
void main() {
  late MockDataConnectionChecker mockDataConnectionChecker;
  late NetworkInfoImbl networkInfo;
  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImbl(mockDataConnectionChecker);
  });
  group('isConnected', () {
    test(
      'should forward the call to DataConnectionChecker.hasConnection',
      () async {
        final tHasConnectionFuture = Future.value(true);

        when(mockDataConnectionChecker.hasConnection)
            .thenAnswer((_) => tHasConnectionFuture);

        final result = networkInfo.isConnected;
        // assert
        verify(mockDataConnectionChecker.hasConnection);

        expect(result, tHasConnectionFuture);
      },
    );
  });
}
