import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pay/core/presentation/screens/bank_account/bank_account_screen.dart';
import 'package:pay/core/presentation/screens/bills/bank_slip_bloc.dart';
import 'package:pay/core/presentation/screens/bills/bank_slip_event.dart';
import 'package:pay/core/presentation/screens/bills/bank_slip_screen.dart';
import 'package:pay/core/presentation/screens/home/home_screen.dart';
import 'package:pay/core/presentation/settings/settings_screen.dart';
import 'package:pay/core/presentation/screens/bank_account/bank_account_bloc.dart';
import 'package:pay/core/presentation/screens/bank_account/bank_account_event.dart';

class AuthenticatedNavigation extends StatefulWidget {
  const AuthenticatedNavigation({Key? key}) : super(key: key);

  @override
  State<AuthenticatedNavigation> createState() =>
      _AuthenticatedNavigationState();
}

class _AuthenticatedNavigationState extends State<AuthenticatedNavigation> {
  int _selectedIndex = 0;
  bool _hasLoadedBankAccounts = false;

  final List<Widget> _screens = [
    const HomeScreen(),
    const BankSlipScreen(),
    const BankAccountScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      context.read<BankSlipBloc>().add(LoadBankSlips());
    }
    if (index == 2 && !_hasLoadedBankAccounts) {
      context.read<BankAccountBloc>().add(LoadBankAccounts());
      _hasLoadedBankAccounts = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Boletos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Contas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
