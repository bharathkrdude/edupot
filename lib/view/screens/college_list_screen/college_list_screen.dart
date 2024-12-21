import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/core/constants/constants.dart';
import 'package:edupot/view/screens/college_list_screen/widgets/college_card_widget.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:edupot/view/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/college_viewmodel.dart'; // Add this import

class CollegeListScreen extends StatefulWidget {
  const CollegeListScreen({super.key});

  @override
  State<CollegeListScreen> createState() => _CollegeListScreenState();
}

class _CollegeListScreenState extends State<CollegeListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch colleges when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CollegeViewModel>().fetchColleges();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorlightgrey,
      appBar: CustomAppBar(title: 'Colleges'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchWidget(
              onChanged: (value) {
                // Implement search using viewModel
                context.read<CollegeViewModel>().searchColleges(value);
              },
            ),
          ),
          Expanded(
            child: Consumer<CollegeViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (viewModel.error.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          viewModel.error,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => viewModel.fetchColleges(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (viewModel.colleges.isEmpty) {
                  return const Center(
                    child: Text('No colleges found'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: viewModel.fetchColleges,
                  child: ListView.builder(
                    itemCount: viewModel.colleges.length,
                    itemBuilder: (context, index) {
                      final college = viewModel.colleges[index];
                      return CollegeCard(
      name: college.name,
      university: college.university,
      address: college.address,
      about: college.about,
      logo: college.logo,
      logoPath: college.logoPath,
      images: college.images.map((img) => img.image).toList(),
      brochurePath: college.brochurePath,
    );
                    },
                  ),
                );
              },
            ),
          ),
          kHeight50,
        ],
      ),
    );
  }
}
