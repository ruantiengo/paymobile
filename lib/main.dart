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

void main() {
  final apiProvider = ApiProvider(AppConfig.apiBaseUrl);
  final loginRepository = AuthRepository(apiProvider);
  final loginUseCase = LoginUseCase(loginRepository);
  final loginBloc = LoginBloc(loginUseCase);

  final bankAccountProvider = BankAccountProvider();
  final bankAccountRepository =
      BankAccountRepository(provider: bankAccountProvider);
  final bankAccountUseCase = BankAccountUseCase(bankAccountRepository);

  runApp(MyApp(loginBloc: loginBloc, bankAccountUseCase: bankAccountUseCase));
}

class MyApp extends StatelessWidget {
  final LoginBloc loginBloc;
  final BankAccountUseCase bankAccountUseCase;

  const MyApp(
      {Key? key, required this.loginBloc, required this.bankAccountUseCase})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (_) => loginBloc),
        BlocProvider<BankAccountBloc>(
            create: (_) => BankAccountBloc(bankAccountUseCase)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minimal Dashboard',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginScreen(),
        routes: {
          '/home': (context) => const AuthenticatedNavigation(),
        },
      ),
    );
  }
}
