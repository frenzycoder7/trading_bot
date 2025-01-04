import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trading_bot/core/apis/endpoints.apis.dart';
import "package:http/http.dart" as http;
import 'package:trading_bot/core/apis/models/7_days_profit.model.dart';
import 'package:trading_bot/core/apis/models/coin.model.dart';
import 'package:trading_bot/core/apis/models/profit_summary.model.dart';
import 'package:trading_bot/modules/trades/models/trade.model.dart';

class API {
  static final API shared = API._internal();
  factory API() => shared;
  API._internal();
  final ApiEndPoints endpoints = ApiEndPoints();
  http.Client client = http.Client();

  Future<List<Coin>> fetchCoins() async {
    // debugPrint("URL: ${endpoints.fetchCoins}");
    // var response = await client.get(Uri.parse(endpoints.fetchCoins));
    final decodedData = jsonDecode(
        '{"coins":[{"_id":"66ddee731f7eafa6e0deb2e3","symbol":"BTCUSDT","leverage":5,"stopLossPercent":1,"takeProfitPercent":1,"reorder":true,"useStopLoss":false,"amount":0.002,"reorderPercent":1,"precision":2,"reorderOnSell":true,"maxTrade":3,"buyOnMarketAfterSell":true,"createdAt":"2024-09-08T18:35:31.808Z","updatedAt":"2024-12-14T03:22:42.999Z","__v":0},{"_id":"67571689dd6337cb2221c128","symbol":"BNBUSDT","leverage":3,"stopLossPercent":1,"takeProfitPercent":1,"reorder":false,"useStopLoss":false,"amount":0.04,"reorderPercent":1,"precision":2,"reorderOnSell":false,"maxTrade":3,"buyOnMarketAfterSell":false,"createdAt":"2024-12-09T16:10:49.469Z","updatedAt":"2024-12-31T18:11:38.043Z","__v":0},{"_id":"6757b315dd6337cb2221c168","symbol":"XRPUSDT","leverage":5,"stopLossPercent":1,"takeProfitPercent":2,"reorder":true,"useStopLoss":false,"amount":50,"reorderPercent":1,"precision":4,"reorderOnSell":true,"maxTrade":3,"buyOnMarketAfterSell":false,"createdAt":"2024-12-10T03:18:45.191Z","updatedAt":"2024-12-31T18:11:38.043Z","__v":0}],"message":"Coins fetched successfully"}');
    // debugPrint("Response: ${response.body}");
    // if (response.statusCode != 200) throw Exception(decodedData["message"]);

    if (decodedData["coins"] == null) return [];
    List<dynamic> coins = decodedData["coins"] as List<dynamic>;
    return coins.map((e) => Coin.fromJson(e)).toList();
  }

  Future<bool> createCoin(Map<String, dynamic> coin) async {
    // debugPrint("URL: ${endpoints.createCoin}");
    // var response =
    //     await client.post(Uri.parse(endpoints.createCoin), body: coin);
    // debugPrint("Response: ${response.body}");
    // final decodedData = jsonDecode(response.body);
    // if (response.statusCode != 201) throw Exception(decodedData["message"]);
    return true;
  }

  Future<bool> deleteCoin(String symbol) async {
    // debugPrint("URL: ${endpoints.deleteCoin}");
    // var response =
    //     await client.delete(Uri.parse("${endpoints.deleteCoin}/$symbol"));
    // debugPrint("Response: ${response.body}");
    // final decodedData = jsonDecode(response.body);
    // if (response.statusCode != 200) throw Exception(decodedData["message"]);
    return true;
  }

  Future<bool> updateCoin(Map<String, dynamic> body, String symbol) async {
    // debugPrint("URL: ${endpoints.updateCoin}");
    // var response = await client
    //     .patch(Uri.parse("${endpoints.updateCoin}/$symbol"), body: body);
    // debugPrint("Response: ${response.body} ${response.statusCode}");
    // final decodedData = jsonDecode(response.body);
    // if (response.statusCode != 200) throw Exception(decodedData["message"]);
    return true;
  }

  Future<TradeResponse> fetchTrades(Map<String, dynamic> query) async {
    // String endpoint = "${endpoints.fetchTrades}?";
    // for (var key in query.keys) {
    //   debugPrint("Key: $key Value: ${query[key]}");
    //   endpoint += "&$key=${query[key]}";
    // }

    // debugPrint("URL: $endpoint");
    // var response = await client.get(Uri.parse(endpoint));
    // debugPrint("Response: ${response.body}");

    // final decodedData = jsonDecode(response.body);
    const closedData =
        '{"orders":[{"_id":"67618947dd6337cb2221c615","symbol":"BNBUSDT","amount":0.04,"entryPrice":735.78,"exitPrice":738.23,"profit":0.06922140000000182,"leverage":3,"margin":9.8104,"ROE":0,"size":29.4312,"status":"CLOSED","tradeCount":1,"fee":0.0287786,"binanceProfit":-1.3014,"createdAt":"2024-12-17T14:23:03.125Z","updatedAt":"2024-12-31T19:58:48.865Z","__v":0},{"_id":"67618947dd6337cb2221c618","symbol":"BNBUSDT","amount":0.04,"entryPrice":735.59,"exitPrice":738.04,"profit":0.06922519999999727,"leverage":3,"margin":9.807866666666667,"ROE":0,"size":29.4236,"status":"CLOSED","tradeCount":1,"fee":0.028774800000000003,"binanceProfit":-1.3014,"createdAt":"2024-12-17T14:23:03.326Z","updatedAt":"2024-12-31T19:58:31.180Z","__v":0}],"count":2,"message":"Trades fetched successfully"}';
    const openData =
        '{"orders":[{"_id":"676188fcdd6337cb2221c60b","symbol":"BNBUSDT","amount":0.04,"entryPrice":733.03,"exitPrice":735.47,"profit":0,"leverage":3,"margin":9.773733333333334,"ROE":0,"size":29.3212,"status":"OPEN","tradeCount":1,"fee":0.0146606,"binanceProfit":0,"createdAt":"2024-12-17T14:21:48.688Z","updatedAt":"2024-12-17T14:21:48.688Z","__v":0},{"_id":"67607638dd6337cb2221c5c5","symbol":"BNBUSDT","amount":0.04,"entryPrice":728.28,"exitPrice":730.71,"profit":0,"leverage":3,"margin":9.7104,"ROE":0,"size":29.1312,"status":"OPEN","tradeCount":1,"fee":0.0145656,"binanceProfit":0,"createdAt":"2024-12-17T14:21:48.688Z","updatedAt":"2024-12-17T14:21:48.688Z","__v":0}],"count":2,"message":"Trades fetched successfully"}';
    final decodedData =
        jsonDecode(query["status"] == "OPEN" ? openData : closedData);
    // if (response.statusCode != 200) throw Exception(decodedData["message"]);

    if (decodedData["orders"] == null) {
      return TradeResponse(trades: [], total: 0);
    }
    List<dynamic> orders = decodedData["orders"] as List<dynamic>;
    return TradeResponse(
      trades: orders.map((e) => Trade.fromJson(e)).toList(),
      total: decodedData["count"],
    );
  }

  Future<ProfitSummary> fetchProfitSummary() async {
    // debugPrint("URL: ${endpoints.fetchProfitSummary}");
    // var response = await client.get(Uri.parse(endpoints.fetchProfitSummary));
    // debugPrint("Response: ${response.body}");
    final decodedData = jsonDecode(
        '{"data":{"total":{"profit":91.16,"tc":667},"today":{"profit":0,"tc":0},"week":{"profit":4.85,"tc":52},"month":{"profit":45.24,"tc":366}},"message":"Total profit fetched"}');
    // if (response.statusCode != 200) throw Exception(decodedData["message"]);
    return ProfitSummary.fromJson(decodedData["data"]);
  }

  Future<List<SevenDaysProfit>> fetch7DaysProfit() async {
    // debugPrint("URL: ${endpoints.fetch7DaysProfit}");
    // var response = await client.get(Uri.parse(endpoints.fetch7DaysProfit));
    // debugPrint("Response: ${response.body}");
    final decodedData = jsonDecode(
        '{"data":[{"_id":"2024-09-14","profit":0.08909844000000228,"tc":2},{"_id":"2024-09-15","profit":0.213613249999975,"tc":5},{"_id":"2024-09-16","profit":0.8277696999999972,"tc":19},{"_id":"2024-09-17","profit":0.6076880399999814,"tc":14},{"_id":"2024-09-18","profit":1.2755959899999982,"tc":17},{"_id":"2024-09-19","profit":4.715975630000017,"tc":33},{"_id":"2024-09-20","profit":1.0516271999999982,"tc":7}],"message":"Last 7 days profit fetched"}');
    // if (response.statusCode != 200) throw Exception(decodedData["message"]);
    List<dynamic> profits = decodedData["data"] as List<dynamic>;
    return profits.map((e) => SevenDaysProfit.fromJson(e)).toList();
  }
}
