import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:edupot/core/constants/colors.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';

class CollegeDetailsScreen extends StatefulWidget {
  final String name;
  final String university;
  final String address;
  final String about;
  final String logo;
  final List<String> images;

  const CollegeDetailsScreen({
    super.key,
    required this.name,
    required this.university,
    required this.address,
    required this.about,
    required this.logo,
    required this.images,
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
              // College Logo and Name
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.logo),
                    radius: 30,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.address,
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
              const SizedBox(height: 24),

              // University
              _detailSection('University', widget.university),
              const SizedBox(height: 16),

              // About Section
              _detailSection('About', widget.about),
              const SizedBox(height: 24),

              // College Images Section
              const Text(
                'Brochure',
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
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  final imageUrl = widget.images[index];
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
