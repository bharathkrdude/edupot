import 'package:edupot/core/constants/constants.dart';
import 'package:edupot/view/widgets/carousel_widget.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:edupot/viewmodels/dash_board_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: 'Dashboard'),
      body: Consumer<DashboardViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(viewModel.error),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: viewModel.refreshDashboard,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: RefreshIndicator(
              onRefresh: viewModel.refreshDashboard,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                          kHeight20,
                          if (viewModel.bannerImages.isNotEmpty)
                            CarouselWithDots(
                              images: viewModel.bannerImages,
                              height: 250,
                            )
                          else
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text('No banner images available'),
                              ),
                            ),

                          const SizedBox(height: 20),
                           _statsSection(constraints, viewModel),
                          const SizedBox(height: 20),
                          _pieChartSection(constraints, viewModel),
                          const SizedBox(height: 20),
                          _progressSection(viewModel),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statsSection(BoxConstraints constraints, DashboardViewModel viewModel) {
    return SizedBox(
      height: constraints.maxWidth * 0.35,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _statCard(
            'Total Leads',
            viewModel.totalLeads.toString(),
            Icons.people_outline,
            Colors.blue.shade100,
            constraints,
          ),
          ...viewModel.categories.map((category) => _statCard(
                category,
                viewModel.getLeadsCountForCategory(category).toString(),
                _getCategoryIcon(category),
                _getCategoryLightColor(category),
                constraints,
              )),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'commerce':
        return Icons.business_outlined;
      case 'science':
        return Icons.science_outlined;
      case 'others':
        return Icons.menu_book_outlined;
      default:
        return Icons.school_outlined;
    }
  }

  Color _getCategoryLightColor(String category) {
    switch (category.toLowerCase()) {
      case 'commerce':
        return Colors.blue.shade100;
      case 'science':
        return Colors.green.shade100;
      case 'others':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
    BoxConstraints constraints,
  ) {
    return Container(
      width: constraints.maxWidth * 0.4,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.black54),
          ),
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pieChartSection(BoxConstraints constraints, DashboardViewModel viewModel) {
    bool hasData = viewModel.totalLeads > 0;
    final sections = hasData
        ? viewModel.categories.map((category) {
            final percentage = viewModel.getCategoryPercentage(category);
            return PieChartSectionData(
              value: percentage > 0 ? percentage : 0,
              title: percentage > 0 ? '${percentage.toStringAsFixed(1)}%' : '',
              color: viewModel.getCategoryColor(category),
              radius: 60,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          }).toList()
        : [
            PieChartSectionData(
              value: 100,
              title: '0%',
              color: Colors.grey.shade300,
              radius: 60,
            ),
          ];

    return Container(
      height: constraints.maxWidth * 0.6,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category Distribution',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          kHeight10,
          Expanded(
            child: Row(
              children: [
                kWidth10,
                Expanded(
                  flex: 2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 30,
                          sections: sections,
                        ),
                      ),
                      if (!hasData)
                        const Text(
                          'No Data',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                kWidth20,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: viewModel.categories.map((category) {
                      final count = viewModel.getLeadsCountForCategory(category);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: _legendItem(
                          '$category ($count)',
                          hasData
                              ? viewModel.getCategoryColor(category)
                              : Colors.grey.shade300,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                kWidth10,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _progressSection(DashboardViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          if (viewModel.totalLeads == 0)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No leads data available',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
            ...viewModel.categories.map((category) {
              final count = viewModel.getLeadsCountForCategory(category);
              final percentage = viewModel.getCategoryPercentage(category);
              return Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: _progressItem(
                  '$category Category',
                  viewModel.totalLeads.toString(),
                  count.toString(),
                  percentage / 100,
                  viewModel.getCategoryColor(category),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _progressItem(
    String title,
    String total,
    String filled,
    double progress,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text('$filled/$total leads'),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.isNaN || progress.isInfinite ? 0 : progress,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
