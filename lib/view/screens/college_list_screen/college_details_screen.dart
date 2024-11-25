import 'dart:io';
import 'package:dio/dio.dart';
import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';
import 'package:edupot/view/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CollegeDetailsScreen extends StatefulWidget {
  final String collegeName;
  final String location;
  final String coursesOffered;
  final String examsAccepted;
  final String placementRating;
  final String imageUrl;
  final List<String> brochureImages;

  const CollegeDetailsScreen({
    Key? key,
    required this.collegeName,
    required this.location,
    required this.coursesOffered,
    required this.examsAccepted,
    required this.placementRating,
    required this.imageUrl,
    required this.brochureImages,
  }) : super(key: key);

  @override
  State<CollegeDetailsScreen> createState() => _CollegeDetailsScreenState();
}

class _CollegeDetailsScreenState extends State<CollegeDetailsScreen> {
  bool isDownloading = false;
  double downloadProgress = 0.0;

  Future<void> downloadImages() async {
    // Request storage permission
    if (await Permission.storage.request().isGranted) {
      setState(() {
        isDownloading = true;
        downloadProgress = 0.0;
      });

      try {
        // Get the directory to save images
        final directory = await getExternalStorageDirectory();
        final downloadPath = directory?.path ?? '';

        Dio dio = Dio();

        for (int i = 0; i < widget.brochureImages.length; i++) {
          String imageUrl = widget.brochureImages[i];
          String fileName = 'brochure_${i + 1}.png';
          String savePath = '$downloadPath/$fileName';

          await dio.download(
            imageUrl,
            savePath,
            onReceiveProgress: (received, total) {
              setState(() {
                downloadProgress = (received / total) * ((i + 1) / widget.brochureImages.length);
              });
            },
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Brochures downloaded to $downloadPath')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          isDownloading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar:CustomAppBar(title: 'College Details'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // College Avatar and Name
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageUrl),
                    radius: 30,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.collegeName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Courses Offered and Exams Accepted
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _detailColumn('Courses Offered', widget.coursesOffered),
                  _detailColumn('Exams Accepted', widget.examsAccepted),
                ],
              ),
              const SizedBox(height: 16),

              // Placement Rating
              _detailColumn(
                'Placement Rating',
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      widget.placementRating,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Brochure Images Section
              Text(
                'Brochures',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: widget.brochureImages.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      widget.brochureImages[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Download Button and Progress Indicator
              if (isDownloading)
                Column(
                  children: [
                    LinearProgressIndicator(value: downloadProgress),
                    const SizedBox(height: 8),
                    Text(
                      'Downloading... ${(downloadProgress * 100).toStringAsFixed(2)}%',
                    ),
                  ],
                )
              else
              SizedBox(height: 40,),
                // PrimaryButton(onPressed: downloadImages, text: 'Download All brochure images')
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build detail columns
  Widget _detailColumn(String title, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        value is Widget
            ? value
            : Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ],
    );
  }
}
