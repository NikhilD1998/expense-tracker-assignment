import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helpers/constants.dart';
import 'package:frontend/helpers/device_dimensions.dart';
import 'package:frontend/helpers/transition_animation.dart';
import 'package:frontend/screens/add_expense_screen.dart';
import 'package:frontend/providers/expense_provider.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:frontend/providers/auth_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<BarChartGroupData> _generateChartData(
    List<Map<String, dynamic>> expenses,
    String mode,
  ) {
    Map<int, double> grouped = {};

    if (mode == "day") {
      final now = DateTime.now();
      for (var exp in expenses) {
        final date = DateTime.tryParse(exp['date'] ?? '')?.toLocal();
        if (date != null &&
            date.year == now.year &&
            date.month == now.month &&
            date.day == now.day) {
          final hour = date.hour;
          grouped[hour] =
              (grouped[hour] ?? 0) + (exp['amount'] as num).toDouble();
        }
      }
    }

    return grouped.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: primaryColor,
            width: 60,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  double _getMaxY(List<Map<String, dynamic>> expenses) {
    final now = DateTime.now();
    double max = 0;
    for (var exp in expenses) {
      final date = DateTime.tryParse(exp['date'] ?? '');
      if (date != null &&
          date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        final amt = (exp['amount'] as num).toDouble();
        if (amt > max) max = amt;
      }
    }
    return max > 0 ? max * 1.2 : 100;
  }

  Future<void> exportExpensesToCSV(
    List<Map<String, dynamic>> expenses,
    BuildContext context,
  ) async {
    List<List<dynamic>> rows = [
      ['Name', 'Amount', 'Date', 'Category'],
      ...expenses.map(
        (e) => [
          e['name'] ?? '',
          e['amount'] ?? '',
          e['date'] ?? '',
          e['category'] ?? '',
        ],
      ),
    ];

    String csvData = const ListToCsvConverter().convert(rows);

    Directory? downloadsDir;
    if (Platform.isAndroid) {
      final directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        downloadsDir = directory;
      }
    } else {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    if (downloadsDir == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not access Downloads folder')),
      );
      return;
    }

    final file = File('${downloadsDir.path}/expenses_export.csv');
    await file.writeAsString(csvData);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Exported to ${file.path}')));
  }

  @override
  Widget build(BuildContext context) {
    DeviceDimensions.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ref.watch(expenseProvider.notifier).getAllExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final expenses = snapshot.data ?? [];
          return Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: DeviceDimensions.height * 0.04),
                  TabBar(
                    controller: _tabController,
                    tabs: const [Tab(text: "Day")],
                  ),
                  SizedBox(
                    height: DeviceDimensions.height * 0.4,
                    width: DeviceDimensions.width * 0.9,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: BarChart(
                            BarChartData(
                              maxY: _getMaxY(expenses),
                              barGroups: _generateChartData(expenses, "day"),
                              borderData: FlBorderData(show: false),
                              barTouchData: BarTouchData(
                                enabled: false,
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipPadding: EdgeInsets.zero,
                                  tooltipMargin: 0,
                                  getTooltipItem: (_, __, ___, ____) => null,
                                ),
                              ),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 32,
                                    interval: 5,
                                    getTitlesWidget: (value, meta) {
                                      if (value % 5 != 0 ||
                                          value < 0 ||
                                          value > 90)
                                        return const SizedBox();
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: Text(
                                          value.toInt().toString(),
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize:
                                                DeviceDimensions.width * 0.03,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 3,
                                    getTitlesWidget: (value, meta) {
                                      final hour = value.toInt();
                                      if (hour % 3 != 0)
                                        return const SizedBox();
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                        ),
                                        child: Text(
                                          'Today',
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize:
                                                DeviceDimensions.width * 0.03,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                horizontalInterval: 5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: expenses.isEmpty
                        ? const Center(child: Text('No expenses found.'))
                        : ListView.builder(
                            padding: EdgeInsets.only(
                              bottom: DeviceDimensions.height * 0.12,
                            ),
                            itemCount: expenses.length,
                            itemBuilder: (context, index) {
                              final expense = expenses[index];
                              return Dismissible(
                                key: Key(
                                  expense['_id'] ??
                                      expense['date'] ??
                                      index.toString(),
                                ),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                  ),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                confirmDismiss: (direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete Expense'),
                                      content: const Text(
                                        'Are you sure you want to delete this expense?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                onDismissed: (direction) async {
                                  await ref
                                      .read(expenseProvider.notifier)
                                      .deleteExpense(expense['_id']);
                                  setState(() {});
                                },
                                child: Card(
                                  color: const Color(0xFFFBFBFB),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: DeviceDimensions.width * 0.04,
                                    vertical: DeviceDimensions.height * 0.01,
                                  ),
                                  child: ListTile(
                                    title: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            expense['name'] ?? '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize:
                                                  DeviceDimensions.width *
                                                  0.045,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          '₹${expense['amount']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                            fontSize:
                                                DeviceDimensions.width * 0.048,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      '${expense['category'] ?? ''}\n'
                                      '${expense['date'] != null && expense['date'].toString().isNotEmpty ? DateFormat("MMM d, yyyy").format(DateTime.parse(expense['date']).toLocal()) : ''}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize:
                                            DeviceDimensions.width * 0.035,
                                      ),
                                    ),
                                    isThreeLine: true,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: SpeedDial(
                  icon: Icons.menu,
                  activeIcon: Icons.close,
                  backgroundColor: const Color(0xFF29756F),
                  foregroundColor: Colors.white,
                  spacing: 12,
                  spaceBetweenChildren: 8,
                  children: [
                    SpeedDialChild(
                      child: const Icon(Icons.logout, color: Colors.white),
                      backgroundColor: Colors.red,
                      label: 'Logout',
                      onTap: () async {
                        await ref.read(authProvider.notifier).logout();
                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                    ),
                    SpeedDialChild(
                      child: const Icon(
                        Icons.file_download,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.blue,
                      label: 'Export',
                      onTap: () {
                        exportExpensesToCSV(expenses, context);
                      },
                    ),
                    SpeedDialChild(
                      child: const Icon(Icons.add, color: Colors.white),
                      backgroundColor: Colors.green,
                      label: 'Add Expense',
                      onTap: () {
                        navigateWithFade(context, const AddExpenseScreen());
                        (context as Element).reassemble();
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
