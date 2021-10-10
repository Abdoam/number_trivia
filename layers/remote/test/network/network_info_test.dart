import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:remote/network/network_info_impl.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
 // late MockNetworkInfo networkInfo;
  late NetworkInfoImpl networkInfo;
  late MockClient client;
  //late MockConnectionChecker mockConnectionChecker;
  //late MockDataConnectionChecker mockDataConnectionChecker;


  setUp((){
   // mockConnectionChecker = MockConnectionChecker();
   // mockDataConnectionChecker = MockDataConnectionChecker();
   // networkInfo = NetworkInfoImpl(mockDataConnectionChecker);
    client = MockClient();
    //networkInfo = NetworkInfoImpl(client);
    networkInfo = NetworkInfoImpl(client: client);
  });

  group("isConnected", () {
    //test("should forward the call to DataConnectionChecker.hasConnection",
    test("should return ture when there is internet",
            () async {
              when(client
                  .get(Uri.parse('https://example.com/')))
                  .thenAnswer((_) async =>
                  http.Response('{"number": 1, "text": "Test Text"}', 200));
              // final tHasConnectionCheckerFuture = Future.value(true);
              // arrange
             // when(mockDataConnectionChecker.hasConnection)
              //when(networkInfo.isConnected)
               //   .thenAnswer((realInvocation) => tHasConnectionCheckerFuture);
              // act
                final result = await networkInfo.isConnected;
              // assert
              verify(client
                  .get(Uri.parse('https://example.com/')));
              expect(result, true);

              //verify(mockConnectionChecker.hasConnection);
            });

    test("should return false when there is no internet",
            () async{
          when(client
              .get(Uri.parse('https://example.com/')))
          .thenThrow(Exception());
            //  .thenAnswer((_) async =>
            //  http.Response('{"number": 1, "text": "Test Text"}', 400));
          // final tHasConnectionCheckerFuture = Future.value(true);
          // arrange
          // when(mockDataConnectionChecker.hasConnection)
          //when(networkInfo.isConnected)
          //   .thenAnswer((realInvocation) => tHasConnectionCheckerFuture);
          // act
          final result = await networkInfo.isConnected;
          // assert
          verify(client
              .get(Uri.parse('https://example.com/')));
          expect(result, false);
              //verify(mockConnectionChecker.hasConnection);
        });
    test("should return false when status code is not ok",
            () async{
          when(client
              .get(Uri.parse('https://example.com/')))
            .thenAnswer((_) async =>
            http.Response('{"number": 1, "text": "Test Text"}', 400));
          // final tHasConnectionCheckerFuture = Future.value(true);
          // arrange
          // when(mockDataConnectionChecker.hasConnection)
          //when(networkInfo.isConnected)
          //   .thenAnswer((realInvocation) => tHasConnectionCheckerFuture);
          // act
          final result = await networkInfo.isConnected;
          // assert
          verify(client
              .get(Uri.parse('https://example.com/')));
          expect(result, false);
          //verify(mockConnectionChecker.hasConnection);
        });
  });


}