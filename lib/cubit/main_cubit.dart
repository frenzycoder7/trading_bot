import 'package:bloc/bloc.dart';
import 'package:trading_bot/core/apis/index.dart';
import 'package:trading_bot/core/services/Storage.service.dart';
import 'package:trading_bot/core/services/websocket.service.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  Future<void> initializeApp() async {
    emit(MainLoading());

    try {
      // Connect to WebSocket
      final bool isConnected = await WebSocketService.shared.connect();

      if (!isConnected) {
        emit(const MainError('Failed to connect to WebSocket'));
        return;
      }

      // Fetch coins
      final coins = await API.shared.fetchCoins();
      Storage.shared.setCoins(coins);

      emit(MainSuccess());
    } catch (e) {
      emit(MainError(e.toString()));
    }
  }
}
