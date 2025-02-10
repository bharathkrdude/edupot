import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/core/constants/constants.dart';
import 'package:edupot/view/screens/college_list_screen/widgets/college_card_widget.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:edupot/view/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/college_viewmodel.dart';

class CollegeListScreen extends StatefulWidget {
  const CollegeListScreen({super.key});

  @override
  State<CollegeListScreen> createState() => _CollegeListScreenState();
}

class _CollegeListScreenState extends State<CollegeListScreen> {
  @override
  void initState() {
    super.initState();
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
                       Container(
                       height: 200,
                        child: Image.asset('assets/images/Animation - 1738394294886.gif')),
                       Text(viewModel.error),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryButton,
                          ),
                          onPressed: () => viewModel.fetchColleges(),
                          child: const Text(
                            'Retry',
                            style: TextStyle(color: white),
                          ),
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
                        location: college.location,
                        brochurerelated: college.brochurerelated,
                        feesrelated: college.feesrelated,
                        brochureImagePath: college.brochureImagePath,
                        feesImagePath: college.feesImagePath,
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
