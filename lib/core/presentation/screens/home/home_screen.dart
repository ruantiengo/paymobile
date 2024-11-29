import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF163783), // Fundo azul escuro
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header com dados totais
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Resumo de Boletos",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Valores "Total Emitido" e "Total Recebido" alinhados à direita
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(
                            0xFF1E4B9D), // Azul levemente mais claro para contraste
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildValueRow("Total Emitido", "R\$ 1.453.179,02"),
                          const SizedBox(
                              height: 16), // Espaçamento entre os valores
                          _buildValueRow("Total Recebido", "R\$ 756.928,63"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Text(
                      "Taxa de Pagamento",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "31.32%",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ],
                ),
              ),

              // Corpo branco com estatísticas detalhadas
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      // Estatísticas Gerais
                      const Text(
                        "Estatísticas Gerais",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildStatItem("Total de Boletos Gerados", "463"),
                      const Divider(),
                      _buildStatItem("Boletos Pagos", "145"),
                      const Divider(),
                      _buildStatItem("Boletos Cancelados", "6"),
                      const Divider(),
                      _buildStatItem(
                        "Percentual de Atrasados",
                        "11.03%",
                        highlight: true,
                      ),
                      const Divider(),
                      _buildStatItem(
                          "Média de Atraso no Pagamento", "-47.56 dias"),

                      const SizedBox(height: 30),

                      // Pontualidade
                      const Text(
                        "Pontualidade dos Clientes",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildClientStatList([
                        "Cliente 04214233000148: Pontualidade 100.00%",
                        "Cliente 11272278662: Pontualidade 100.00%",
                        "Cliente 09179079000134: Pontualidade 85.71%",
                        "Cliente 28140269000192: Pontualidade 100.00%",
                      ]),

                      const SizedBox(height: 30),

                      // Valor Médio dos Boletos por Cliente
                      const Text(
                        "Valor Médio dos Boletos por Cliente",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildClientStatList([
                        "Cliente 04214233000148: R\$ 7.437,50",
                        "Cliente 09179079000134: R\$ 3.683,35",
                        "Cliente 28140269000192: R\$ 11.777,14",
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para exibir valores em destaque (Total Emitido e Total Recebido) alinhados à direita
  Widget _buildValueRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Widget para itens de estatísticas gerais
  Widget _buildStatItem(String title, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: highlight ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }

  // Widget para listar estatísticas por cliente
  Widget _buildClientStatList(List<String> stats) {
    return Column(
      children: stats
          .map(
            (stat) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      stat,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
