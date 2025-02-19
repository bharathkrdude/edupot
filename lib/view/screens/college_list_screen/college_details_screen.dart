
import 'package:edupot/data/models/college_model.dart';
import 'package:edupot/view/screens/college_list_screen/brochure/brochure_screen.dart';
import 'package:edupot/view/screens/fee_screen/fee_screen.dart';
import 'package:flutter/material.dart';
import 'package:edupot/view/widgets/custom_appbar.dart';

class CollegeDetailsScreen extends StatefulWidget {
  final String name;
  final String university;
  final String address;
  final String about;
  final String? logo;
  final String location;
  final List<BrochureImage> brochurerelated;
  final List<FeesImage> feesrelated;
  final String brochureImagePath;
  final String feesImagePath;

  const CollegeDetailsScreen({
    super.key,
    required this.name,
    required this.university,
    required this.address,
    required this.about,
    this.logo,
    required this.location,
    required this.brochurerelated,
    required this.feesrelated,
    required this.brochureImagePath,
    required this.feesImagePath,
  });

  @override
  State<CollegeDetailsScreen> createState() => _CollegeDetailsScreenState();
}

class _CollegeDetailsScreenState extends State<CollegeDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(title: 'College Details'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    'University',
                    widget.university,
                    Icons.school,
                    Colors.indigo,
                  ),
                  const SizedBox(height: 20),
                  _buildAboutSection(),
                  const SizedBox(height: 20),
                  _buildBrochureSection(),
                  const SizedBox(height: 20),
                  _buildFeesSection(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: widget.logo != null ? NetworkImage (widget.logo!) : NetworkImage('https://www.pngfind.com/pngs/m/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.png'), 
              radius: 40,
              backgroundColor: Colors.white,
              child: widget.logo == null ? const Icon(Icons.school, size: 40, color: Colors.grey) : null,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1a237e),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.address,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.location == 'india' ? Colors.blue[100] : Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.location.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: widget.location == 'india' ? Colors.blue[800] : Colors.green[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _buildCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1a237e),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.about,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrochureSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _buildCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Brochure',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1a237e),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: widget.brochurerelated.isNotEmpty
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BrochureScreen(
                          brochureImages: widget.brochurerelated,
                          brochureImagePath: widget.brochureImagePath,
                        ),
                      ),
                    );
                  }
                : null,
            icon: const Icon(Icons.download),
            label: Text(widget.brochurerelated.isNotEmpty
                ? 'Download Brochure'
                : 'No Brochure Available'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _buildCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fees',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1a237e),
            ),
          ),
          const SizedBox(height: 12),
         ElevatedButton.icon(
  onPressed: widget.feesrelated.isNotEmpty
      ? () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeesScreen(
                feesImages: widget.feesrelated,
                feesImagePath: widget.feesImagePath,
              ),
            ),
          );
        }
      : null,
  icon: const Icon(Icons.visibility),
  label: Text(widget.feesrelated.isNotEmpty
      ? 'View Fees Structure'
      : 'No Fees Structure Available'),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green[700],
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 12,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
),
        ],
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 10,
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _buildCardDecoration(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1a237e),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
