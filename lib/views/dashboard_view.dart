import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Dummy data for each category and status
    final productAvailable = 350;
    final productOutOfStock = 50;

    final employeeActive = 45;
    final employeeInactive = 5;

    final orderDone = 100;
    final orderPending = 20;

    // Calculate maxY for chart scaling (max sum of pairs * 1.2 for padding)
    final maxY = [
      productAvailable + productOutOfStock,
      employeeActive + employeeInactive,
      orderDone + orderPending,
    ].reduce((a, b) => a > b ? a : b).toDouble() * 1.2;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withOpacity(0.3),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Metrics',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 320,
                  child: BarChart(
                    BarChartData(
                      maxY: maxY,
                      groupsSpace: 40,
                      barGroups: [
                        // Products: Available & Out of Stock
                        BarChartGroupData(
                          x: 0,
                          barsSpace: 8,
                          barRods: [
                            BarChartRodData(
                              toY: productAvailable.toDouble(),
                              color: colorScheme.primary,
                              width: 18,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            BarChartRodData(
                              toY: productOutOfStock.toDouble(),
                              color: colorScheme.error,
                              width: 18,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        ),
                        // Employees: Active & Inactive
                        BarChartGroupData(
                          x: 1,
                          barsSpace: 8,
                          barRods: [
                            BarChartRodData(
                              toY: employeeActive.toDouble(),
                              color: colorScheme.primary,
                              width: 18,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            BarChartRodData(
                              toY: employeeInactive.toDouble(),
                              color: colorScheme.error,
                              width: 18,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        ),
                        // Orders: Done & Pending
                        BarChartGroupData(
                          x: 2,
                          barsSpace: 8,
                          barRods: [
                            BarChartRodData(
                              toY: orderDone.toDouble(),
                              color: colorScheme.primary,
                              width: 18,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            BarChartRodData(
                              toY: orderPending.toDouble(),
                              color: colorScheme.error,
                              width: 18,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        ),
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              switch (value.toInt()) {
                                case 0:
                                  return const Text('Products');
                                case 1:
                                  return const Text('Employees');
                                case 2:
                                  return const Text('Orders');
                                default:
                                  return const Text('');
                              }
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                            // interval: maxY / 5,
                            // reservedSize: 40,
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          tooltipPadding: const EdgeInsets.all(8),
                          getTooltipItem: (
                            BarChartGroupData group,
                            int groupIndex,
                            BarChartRodData rod,
                            int rodIndex,
                          ) {
                            String status;
                            switch (groupIndex) {
                              case 0:
                                status = rodIndex == 0 ? 'Available Products' : 'Out of Stock Products';
                                break;
                              case 1:
                                status = rodIndex == 0 ? 'Active Employees' : 'Inactive Employees';
                                break;
                              case 2:
                                status = rodIndex == 0 ? 'Done Orders' : 'Pending Orders';
                                break;
                              default:
                                status = 'Unknown';
                            }
                            return BarTooltipItem(
                              '${rod.toY.toInt()}\n',
                              const TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: status,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // REMOVE THIS:
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     _buildLegend(colorScheme.primary, 'Available / Active / Done'),
                //     const SizedBox(width: 24),
                //     _buildLegend(colorScheme.error, 'Out of Stock / Inactive / Pending'),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 20, height: 20, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

extension on ColorScheme {
  Color get tertiary =>
      brightness == Brightness.light ? Colors.amber : Colors.amberAccent;
}
