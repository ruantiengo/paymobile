import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pay/core/presentation/screens/bank_account/bank_account_screen.dart';
import 'package:pay/core/presentation/screens/bills/bank_slip_bloc.dart';
import 'package:pay/core/presentation/screens/bills/bank_slip_event.dart';
import 'package:pay/core/presentation/screens/bills/bank_slip_screen.dart';
import 'package:pay/core/presentation/screens/bills/branch/branch_bloc.dart';
import 'package:pay/core/presentation/screens/bills/branch/branch_event.dart';
import 'package:pay/core/presentation/screens/home/home_screen.dart';
import 'package:pay/core/presentation/settings/settings_screen.dart';
import 'package:pay/core/presentation/screens/bank_account/bank_account_bloc.dart';
import 'package:pay/core/presentation/screens/bank_account/bank_account_event.dart';
import 'package:pay/utils/colors.dart';

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
      context.read<BranchBloc>().add(LoadBranches());
    }
    if (index == 2 && !_hasLoadedBankAccounts) {
      context.read<BankAccountBloc>().add(LoadBankAccounts());

      _hasLoadedBankAccounts = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Permite que o conteúdo ocupe todo o espaço, inclusive sob a área da bottom bar
      extendBody: true,
      body: Stack(
        children: [
          // Tela principal
          _screens[_selectedIndex],

          // Bottom bar personalizada
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                // Efeito blur no fundo (opcional)
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Icons.dashboard, 'Início', 0),
                      _buildNavItem(Icons.receipt, 'Boletos', 1),
                      _buildNavItem(Icons.account_balance, 'Contas', 2),
                      _buildNavItem(Icons.settings, 'Configurações', 3),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    final selectedColor = Colors.white;
    final unselectedColor = Colors.grey.withOpacity(0.9);

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? selectedColor : unselectedColor),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
