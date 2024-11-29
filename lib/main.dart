import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/core/data/provider/api_provider.dart';
import 'package:pay/core/data/provider/bank_account_provider.dart';
import 'package:pay/core/data/repository/auth_repository.dart';
import 'package:pay/core/data/repository/bank_account_repository.dart';
import 'package:pay/core/domain/usecase/bank_account_usecase.dart';
import 'package:pay/core/domain/usecase/login_usecase.dart';
import 'package:pay/core/presentation/screens/bank_account/bank_account_block.dart';
import 'package:pay/core/presentation/screens/login/authenticated_navigation.dart';
import 'package:pay/core/presentation/screens/login/login_bloc.dart';
import 'package:pay/core/presentation/screens/login/login_screen.dart';
import 'package:pay/config/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiProvider = ApiProvider(AppConfig.apiBaseUrl);
  final loginRepository = AuthRepository(apiProvider);
  final loginUseCase = LoginUseCase(loginRepository);
  final loginBloc = LoginBloc(loginUseCase);

  final bankAccountProvider = BankAccountProvider();
  final bankAccountRepository =
      BankAccountRepository(provider: bankAccountProvider);
  final bankAccountUseCase = BankAccountUseCase(bankAccountRepository);
  final bankAccountBloc = BankAccountBloc(bankAccountUseCase);
  final isTokenValid = await checkTokenValidity();

  runApp(MyApp(
    loginBloc: loginBloc,
    bankAccountBloc: bankAccountBloc,
    initialRoute: isTokenValid ? '/home' : '/',
  ));
}

Future<bool> checkTokenValidity() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final expirationDateStr = prefs.getString('expirationDate');

  if (token == null || expirationDateStr == null) {
    return false;
  }

  final expirationDate = DateTime.parse(expirationDateStr);
  if (DateTime.now().isAfter(expirationDate)) {
    return false;
  }

  return true;
}

class MyApp extends StatelessWidget {
  final LoginBloc loginBloc;
  final BankAccountBloc bankAccountBloc;

  final String initialRoute;
  const MyApp({
    super.key,
    required this.loginBloc,
    required this.bankAccountBloc,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => loginBloc),
        BlocProvider<BankAccountBloc>(create: (_) => bankAccountBloc),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minimal Dashboard',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: initialRoute,
        routes: {
          '/': (context) => const LoginScreen(),
          '/home': (context) => const AuthenticatedNavigation(),
        },
      ),
    );
  }
}
