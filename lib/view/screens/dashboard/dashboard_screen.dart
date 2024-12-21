import 'package:edupot/core/constants/constants.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.parse("2024-12-17 16:19:17");
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: 'Dashboard'),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _statsSection(constraints),
                    const SizedBox(height: 20),
                    _pieChartSection(constraints),
                    const SizedBox(height: 20),
                    _progressSection(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statsSection(BoxConstraints constraints) {
    return SizedBox(
      height: constraints.maxWidth * 0.35,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _statCard('Total Enquiries', '250', Icons.people_outline, Colors.blue.shade100, constraints),
          _statCard('Science Stream', '120', Icons.science_outlined, Colors.green.shade100, constraints),
          _statCard('Commerce', '80', Icons.business_outlined, Colors.orange.shade100, constraints),
          _statCard('Humanities', '50', Icons.menu_book_outlined, Colors.purple.shade100, constraints),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color, BoxConstraints constraints) {
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
Widget _pieChartSection(BoxConstraints constraints) {
    return Container(
      height: constraints.maxWidth * 0.6, // Reduced from 0.9 to 0.6
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
            'Stream-wise Distribution',
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
                  flex: 2, // Reduced from 3 to 2
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 30, // Reduced from 40 to 30
                      sections: [
                        PieChartSectionData(
                          value: 48,
                          title: '48%',
                          color: Colors.blue,
                          radius: 60, // Reduced from 100 to 60
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12, // Added font size
                          ),
                        ),
                        PieChartSectionData(
                          value: 32,
                          title: '32%',
                          color: Colors.green,
                          radius: 60, // Reduced from 100 to 60
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12, // Added font size
                          ),
                        ),
                        PieChartSectionData(
                          value: 20,
                          title: '20%',
                          color: Colors.orange,
                          radius: 60, // Reduced from 100 to 60
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12, // Added font size
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                kWidth20, // Changed from kWidth30 to kWidth20
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _legendItem('Science', Colors.blue),
                      const SizedBox(height: 10),
                      _legendItem('Commerce', Colors.green),
                      const SizedBox(height: 10),
                      _legendItem('Humanities', Colors.orange),
                    ],
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
        Text(title),
      ],
    );
  }

  Widget _progressSection() {
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
            'Admission Progress',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _progressItem('Science Stream Seats', '150', '120', 0.80, Colors.blue),
          const SizedBox(height: 15),
          _progressItem('Commerce Stream Seats', '100', '80', 0.80, Colors.green),
          const SizedBox(height: 15),
          _progressItem('Humanities Stream Seats', '75', '50', 0.67, Colors.orange),
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
            Text('$filled/$total seats'),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
