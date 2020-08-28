import 'dart:convert';
import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import 'package:http/http.dart' as http;

class CounterService {
  AwsSigV4Client awsSigV4Client;

  CounterService(this.awsSigV4Client);

  /// Retrieve user's previous count from Lambda + DynamoDB
  Future<Counter> getCounter() async {
    final signedRequest =
        new SigV4Request(awsSigV4Client, method: 'GET', path: '/counter');
    final response =
        await http.get(signedRequest.url, headers: signedRequest.headers);
    return new Counter.fromJson(json.decode(response.body));
  }

  /// Increment user's count in DynamoDB
  Future<Counter> incrementCounter() async {
    final signedRequest =
        new SigV4Request(awsSigV4Client, method: 'PUT', path: '/counter');
    final response =
        await http.put(signedRequest.url, headers: signedRequest.headers);
    return new Counter.fromJson(json.decode(response.body));
  }
}

class Counter {
  int count;

  Counter(this.count);

  factory Counter.fromJson(json) {
    return new Counter(json['count']);
  }
}
