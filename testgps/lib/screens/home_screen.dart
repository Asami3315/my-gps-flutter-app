import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/gps_feature.dart';
import '../utils/performance_utils.dart';
import '../services/payment_service.dart';
import 'pro_home_screen.dart';
import 'payment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isProUser = false;

  @override
  void initState() {
    super.initState();
    _checkProStatus();
  }

  Future<void> _checkProStatus() async {
    final isPro = await PaymentService.isProUser();
    setState(() {
      _isProUser = isPro;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLowEnd = PerformanceUtils.isLowEndDevice(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.menu,
            color: Colors.black87,
          ),
        ),
        title: Text(
          'Live Earth Map',
          style: GoogleFonts.inter(
            fontSize: isLowEnd ? 18 : 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              if (_isProUser) {
                // User is already Pro, go to Pro home
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const ProHomeScreen(),
                    transitionDuration: const Duration(milliseconds: 300),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        )),
                        child: child,
                      );
                    },
                  ),
                );
              } else {
                // User is not Pro, show payment screen
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentScreen()),
                );
                
                // Refresh Pro status after returning from payment
                if (result == true) {
                  await _checkProStatus();
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.diamond,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Pro',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Live Earth Cams Banner
            _buildLiveEarthBanner(isLowEnd),
            const SizedBox(height: 20),
            
            // Feature Cards Grid
            _buildFeatureGrid(isLowEnd),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(isLowEnd),
    );
  }

  Widget _buildLiveEarthBanner(bool isLowEnd) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: isLowEnd ? 120 : 140,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E3A8A), // Deep blue
            Color(0xFF3B82F6), // Blue
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Icon with notification dot
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.public,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Live Earth Cams',
                        style: GoogleFonts.inter(
                          fontSize: isLowEnd ? 18 : 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Browse live cameras for live videos around the world',
                        style: GoogleFonts.inter(
                          fontSize: isLowEnd ? 12 : 14,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                // Arrow icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(bool isLowEnd) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isLowEnd ? 1.1 : 1.0,
        ),
        itemCount: GPSFeatureData.features.length,
        itemBuilder: (context, index) {
          final feature = GPSFeatureData.features[index];
          return _buildFeatureCard(feature, isLowEnd);
        },
      ),
    );
  }

  Widget _buildFeatureCard(GPSFeature feature, bool isLowEnd) {
    return GestureDetector(
      onTap: () {
        // Handle feature tap
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${feature.title} tapped'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: isLowEnd ? 40 : 48,
                height: isLowEnd ? 40 : 48,
                decoration: BoxDecoration(
                  color: feature.iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  feature.icon,
                  color: feature.iconColor,
                  size: isLowEnd ? 20 : 24,
                ),
              ),
              const SizedBox(height: 12),
              // Title
              Text(
                feature.title,
                style: GoogleFonts.inter(
                  fontSize: isLowEnd ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              // Description
              Text(
                feature.description,
                style: GoogleFonts.inter(
                  fontSize: isLowEnd ? 10 : 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(bool isLowEnd) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: isLowEnd ? 10 : 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: isLowEnd ? 10 : 12,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.only(bottom: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.navigation,
                    size: isLowEnd ? 20 : 24,
                  ),
                  if (_selectedIndex == 0)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 20,
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                ],
              ),
            ),
            label: 'Navigation',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.public,
              size: isLowEnd ? 20 : 24,
            ),
            label: 'Discovery',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.build,
              size: isLowEnd ? 20 : 24,
            ),
            label: 'Tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              size: isLowEnd ? 20 : 24,
            ),
            label: 'Map Tools',
          ),
        ],
      ),
    );
  }
}
