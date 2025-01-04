import "dart:async";
import "dart:convert";
import "dart:ffi";

import "package:trading_bot/core/apis/index.dart";
import "package:trading_bot/core/services/models/stream_data.model.dart";
import "package:web_socket_channel/web_socket_channel.dart";

class WebSocketService {
  static final WebSocketService shared = WebSocketService._internal();
  factory WebSocketService() => shared;

  WebSocketChannel? channel; // Made nullable to handle connection state
  final StreamController<List<StreamTicker>> _tickers =
      StreamController<List<StreamTicker>>.broadcast();
  final Set<String> _filteredSymbols =
      {}; // Changed to Set for better performance

  WebSocketService._internal();

  Future<bool> connect() async {
    try {
      Uri url = Uri.parse(API.shared.endpoints.websocketURL);
      channel = WebSocketChannel.connect(url);

      channel?.stream.listen(
        (event) {
          try {
            final List<dynamic> data = jsonDecode(event as String);
            _parseTickers(data);
          } catch (e) {
            _tickers.addError('Failed to parse websocket data: $e');
          }
        },
        onError: (error) {
          _tickers.addError('WebSocket error: $error');
          _reconnect();
        },
        cancelOnError: false,
      );

      return true; // Connection successful
    } catch (e) {
      _tickers.addError('Failed to connect to WebSocket: $e');
      _reconnect();
      return false; // Connection failed
    }
  }

  Future<void> _reconnect() async {
    await Future.delayed(const Duration(seconds: 5));
    if (channel?.closeCode != null) {
      connect();
    }
  }

  void close() {
    try {
      channel?.sink.close();
      channel = null;
    } catch (e) {
      _tickers.addError('Error closing connection: $e');
    }
  }

  Stream<List<StreamTicker>> get stream => _tickers.stream;

  void addSymbol(String symbol) {
    _filteredSymbols.add(symbol.toUpperCase()); // Normalize symbol case
  }

  void removeSymbol(String symbol) {
    _filteredSymbols.remove(symbol.toUpperCase());
  }

  List<StreamTicker> _filterSymbols(List<StreamTicker> tickers) {
    return tickers
        .where((ticker) => _filteredSymbols.contains(ticker.s))
        .toList();
  }

  void _parseTickers(List<dynamic> data) {
    try {
      List<StreamTicker> tickers =
          data.map((e) => StreamTicker.fromJson(e)).toList();

      if (_filteredSymbols.isNotEmpty) {
        tickers = _filterSymbols(tickers);
      }

      if (tickers.isNotEmpty) {
        _tickers.add(tickers);
      }
    } catch (e) {
      _tickers.addError('Error parsing tickers: $e');
    }
  }

  StreamSubscription<List<StreamTicker>> getMarketDataOfSymbol(
    String symbol,
    Function(StreamTicker) onData,
  ) {
    return stream.listen(
      (event) {
        for (var ticker in event) {
          if (ticker.s == symbol) {
            onData(ticker);
          }
        }
      },
      onError: (error) {
        // Handle errors here if needed
        print('Error in stream: $error');
      },
    );
  }
}
