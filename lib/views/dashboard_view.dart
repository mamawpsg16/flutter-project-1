import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold( // Wrap the body in a Scaffold
      body: Container( // Container with gradient background
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
                const SizedBox(height: 20),
                // Bar Chart
                SizedBox(
                  height: 250,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 500,
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
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
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        makeGroupData(0, 400, colorScheme.primary),
                        makeGroupData(1, 50, colorScheme.secondary),
                        makeGroupData(2, 120, colorScheme.tertiary),
                      ],
                      barTouchData: BarTouchData(enabled: false),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Pie Chart - Adjusted for dashboard theme
                Container(
                  height: 250, // Adjusted height
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: 40,
                          color: colorScheme.primary,
                          title: 'Products\n40%',
                          radius: 60, // Smaller radius
                          titleStyle: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: 30,
                          color: colorScheme.secondary,
                          title: 'Employees\n30%',
                          radius: 60,
                          titleStyle: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: 30,
                          color: colorScheme.tertiary,
                          title: 'Orders\n30%',
                          radius: 60,
                          titleStyle: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0, // No space between sections
                      centerSpaceRadius: 30, // Increased center hole radius
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: BorderRadius.circular(6),
          rodStackItems: [],
        ),
      ],
      showingTooltipIndicators: [0],
      barsSpace: 4,
    );
  }
}

extension on ColorScheme {
  Color get tertiary =>
      brightness == Brightness.light ? Colors.amber : Colors.amberAccent;
}
