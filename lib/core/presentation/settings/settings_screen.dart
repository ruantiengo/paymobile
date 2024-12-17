import 'package:flutter/material.dart';
import 'package:pay/core/presentation/screens/login/authenticated_navigation.dart';
import 'package:pay/core/presentation/screens/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<dynamic> tenants = [];
  String? selectedTenantId;

  @override
  void initState() {
    super.initState();
    _loadTenants();
    _loadSelectedTenant();
  }

  Future<void> _loadTenants() async {
    final prefs = await SharedPreferences.getInstance();
    final tenantsJson = prefs.getString('tenants');

    if (tenantsJson != null) {
      setState(() {
        tenants = jsonDecode(tenantsJson);
      });
    }
    if (tenants.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  Future<void> _loadSelectedTenant() async {
    final prefs = await SharedPreferences.getInstance();
    final pk = prefs.getString('pk');
    if (pk != null) {
      final selectedTenant = tenants.firstWhere((tenant) => tenant['pk'] == pk,
          orElse: () => null);
      if (selectedTenant != null) {
        setState(() {
          selectedTenantId = selectedTenant['tenantId'];
        });
      }
    }
  }

  Future<void> _changeTenant(String tenantId) async {
    final prefs = await SharedPreferences.getInstance();
    final selectedTenant =
        tenants.firstWhere((tenant) => tenant['tenantId'] == tenantId);

    _showLoadingDialog();

    await Future.delayed(const Duration(seconds: 2));

    await prefs.setString('pk', selectedTenant['pk']);
    await prefs.setString('tenant_id', tenantId);

    setState(() {
      selectedTenantId = tenantId;
    });

    Navigator.pop(context);

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AuthenticatedNavigation(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final fadeAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                const Text(
                  "Carregando...",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: tenants.isEmpty
          ? const Center(child: Text('Error'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selecione um Tenant:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: selectedTenantId,
                            items:
                                tenants.map<DropdownMenuItem<String>>((tenant) {
                              return DropdownMenuItem<String>(
                                value: tenant['tenantId'],
                                child: Text(
                                  tenant['name'],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                _changeTenant(newValue);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 24,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: selectedTenantId != null
                                ? Text(
                                    'Tenant Selecionado: ${tenants.firstWhere((tenant) => tenant['tenantId'] == selectedTenantId)['name']}',
                                    style: const TextStyle(fontSize: 16),
                                  )
                                : const Text(
                                    'Nenhum tenant selecionado',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: _logout,
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
