import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:edupot/core/constants/colors.dart'; // Import your custom colors
import 'package:edupot/view/widgets/custom_appbar.dart'; // Import your custom appbar widget

class CollegeDetailsScreen extends StatefulWidget {
  final String collegeName;
  final String location;
  final String coursesOffered;
  final String examsAccepted;
  final String placementRating;
  final String imageUrl;
  final List<String> brochureImages;

  const CollegeDetailsScreen({
    super.key,
    required this.collegeName,
    required this.location,
    required this.coursesOffered,
    required this.examsAccepted,
    required this.placementRating,
    required this.imageUrl,
    required this.brochureImages,
  });

  @override
  State<CollegeDetailsScreen> createState() => _CollegeDetailsScreenState();
}

class _CollegeDetailsScreenState extends State<CollegeDetailsScreen> {
  double downloadProgress = 0.0; // Track download progress
  Dio dio = Dio(); // Instantiate Dio
  String downloadPath = ''; // Download file path

  Future<void> downloadImage(String imageUrl) async {
    try {
      // Specify the path where you want to save the file
      downloadPath = '/storage/emulated/0/Download/college_brochure_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Start downloading the image
      Response response = await dio.download(
        imageUrl,
        downloadPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              downloadProgress = received / total;
            });
          }
        },
      );

      // Check if the download is successful
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Download completed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw 'Failed to download image.';
      }
    } catch (e) {
      debugPrint('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showImagePreview(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image Preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),

                // Download Button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    downloadImage(imageUrl); // Start the download
                  },
                  icon: const Icon(Icons.download, color: white),
                  label: const Text(
                    'Download Image',
                    style: TextStyle(color: white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryButton,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    textStyle: const TextStyle(fontSize: 16, color: white),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: CustomAppBar(title: 'College Details'),
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
                          style: const TextStyle(
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
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      widget.placementRating,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Brochure Images Section
              const Text(
                'Brochures',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: widget.brochureImages.length,
                itemBuilder: (context, index) {
                  final imageUrl = widget.brochureImages[index];
                  return GestureDetector(
                    onTap: () {
                      showImagePreview(imageUrl);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Download Progress Indicator
              if (downloadProgress > 0 && downloadProgress < 1)
                Column(
                  children: [
                    const Text(
                      'Download in Progress...',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: downloadProgress,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                      minHeight: 8,
                    ),
                  ],
                ),
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
                value.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
