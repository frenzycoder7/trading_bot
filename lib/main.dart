// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trading_bot/core/theme/app.theme.dart';
import 'package:trading_bot/cubit/main_cubit.dart';
import 'package:trading_bot/modules/home/home.view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TradingBot());
}

class TradingBot extends StatelessWidget {
  const TradingBot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trading Bot',
      theme: AppTheme.shared.lightTheme,
      themeMode: ThemeMode.light,
      home: BlocProvider(
        create: (context) => MainCubit()..initializeApp(),
        child: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        if (state is MainLoading) {
          return const LoadingScreen();
        }

        if (state is MainError) {
          return ErrorScreen(
            message: state.message,
            onRetry: () => context.read<MainCubit>().initializeApp(),
          );
        }

        if (state is MainSuccess) {
          return const HomeView();
        }

        return const LoadingScreen();
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', // Add your logo here
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            const Text(
              'Initializing...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorScreen({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 20),
              Text(
                'Something went wrong!',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
