import 'package:flutter/material.dart';
import 'package:trading_bot/core/apis/models/coin.model.dart';

class Storage {
  static Storage shared = Storage._();
  Storage._();

  List<Coin> _coins = [];
  bool _refetchCoins = true;
  bool get shouldRefetchCoins => _refetchCoins;
  Map<String, Coin> _coinsMap = {};

  void addCoin(Coin coin) {
    _coins.add(coin);
  }

  void setCoins(List<Coin> coins) {
    _coins = coins;
    _coinsMap = {};
    for (var coin in coins) {
      _coinsMap[coin.symbol] = coin;
    }
  }

  void removeCoin(Coin coin) {
    _coins.remove(coin);
    _coinsMap.remove(coin.symbol);
  }

  void clearCoins() {
    _coins.clear();
    _coinsMap.clear();
  }

  void setRefetchCoins() {
    _refetchCoins = true;
  }

  void setFetchedCoins() {
    _refetchCoins = false;
  }

  List<Coin> fetchCoins() {
    debugPrint("FETCHING COINS FROM STATE STORAGE");
    return _coins;
  }

  void updateCoin(Coin coin) {
    _coins.removeWhere((element) => element.symbol == coin.symbol);
    _coins.add(coin);
    _coinsMap[coin.symbol] = coin;
  }

  Coin? fetchCoin(String symbol) {
    return _coinsMap[symbol];
  }

  List<String> fetchSymbols() {
    return _coins.map((e) => e.symbol).toList();
  }
}
