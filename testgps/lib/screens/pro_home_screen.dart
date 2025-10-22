import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/gps_feature.dart';
import '../utils/performance_utils.dart';

class ProHomeScreen extends StatefulWidget {
  const ProHomeScreen({super.key});

  @override
  State<ProHomeScreen> createState() => _ProHomeScreenState();
}

class _ProHomeScreenState extends State<ProHomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLowEnd = PerformanceUtils.isLowEndDevice(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27), // Dark premium background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E27),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.diamond,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Pro GPS Suite',
              style: GoogleFonts.inter(
                fontSize: isLowEnd ? 18 : 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  'Premium',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Premium Banner
              _buildPremiumBanner(isLowEnd),
              const SizedBox(height: 24),
              
              // Advanced Features Section
              _buildAdvancedFeatures(isLowEnd),
              const SizedBox(height: 24),
              
              // Pro Tools Grid
              _buildProToolsGrid(isLowEnd),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildProBottomNavigationBar(isLowEnd),
    );
  }

  Widget _buildPremiumBanner(bool isLowEnd) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: isLowEnd ? 140 : 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E3A8A), // Deep blue
            Color(0xFF3B82F6), // Blue
            Color(0xFF8B5CF6), // Purple
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated background elements
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // Premium icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.rocket_launch,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Advanced GPS Suite',
                        style: GoogleFonts.inter(
                          fontSize: isLowEnd ? 20 : 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Professional navigation tools with real-time data and advanced analytics',
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedFeatures(bool isLowEnd) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Advanced Features',
            style: GoogleFonts.inter(
              fontSize: isLowEnd ? 18 : 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  'Real-time Tracking',
                  Icons.gps_fixed,
                  Colors.green,
                  isLowEnd,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFeatureCard(
                  '3D Navigation',
                  Icons.view_in_ar,
                  Colors.purple,
                  isLowEnd,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  'Weather Radar',
                  Icons.cloud,
                  Colors.blue,
                  isLowEnd,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFeatureCard(
                  'Offline Maps',
                  Icons.map,
                  Colors.orange,
                  isLowEnd,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, Color color, bool isLowEnd) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: isLowEnd ? 20 : 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: isLowEnd ? 12 : 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProToolsGrid(bool isLowEnd) {
    final proFeatures = [
      GPSFeature(
        title: 'AI Navigation',
        description: 'Smart route optimization with AI',
        icon: Icons.psychology,
        iconColor: const Color(0xFFFF6B6B),
        route: '/ai-nav',
      ),
      GPSFeature(
        title: 'Satellite Imagery',
        description: 'High-resolution satellite views',
        icon: Icons.satellite_alt,
        iconColor: const Color(0xFF4ECDC4),
        route: '/satellite',
      ),
      GPSFeature(
        title: '3D Mapping',
        description: 'Immersive 3D terrain visualization',
        icon: Icons.terrain,
        iconColor: const Color(0xFF45B7D1),
        route: '/3d-map',
      ),
      GPSFeature(
        title: 'Traffic Analytics',
        description: 'Advanced traffic pattern analysis',
        icon: Icons.analytics,
        iconColor: const Color(0xFF96CEB4),
        route: '/traffic-analytics',
      ),
      GPSFeature(
        title: 'Route Optimization',
        description: 'Multi-stop route planning',
        icon: Icons.route,
        iconColor: const Color(0xFFFFEAA7),
        route: '/route-opt',
      ),
      GPSFeature(
        title: 'Weather Integration',
        description: 'Real-time weather overlays',
        icon: Icons.wb_sunny,
        iconColor: const Color(0xFFFF9FF3),
        route: '/weather',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pro Tools',
            style: GoogleFonts.inter(
              fontSize: isLowEnd ? 18 : 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isLowEnd ? 1.1 : 1.0,
            ),
            itemCount: proFeatures.length,
            itemBuilder: (context, index) {
              final feature = proFeatures[index];
              return _buildProFeatureCard(feature, isLowEnd);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProFeatureCard(GPSFeature feature, bool isLowEnd) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${feature.title} - Pro Feature'),
            backgroundColor: const Color(0xFFFFD700),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Premium icon with glow effect
              Container(
                width: isLowEnd ? 40 : 48,
                height: isLowEnd ? 40 : 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      feature.iconColor.withOpacity(0.3),
                      feature.iconColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: feature.iconColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
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
                  color: Colors.white.withOpacity(0.7),
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

  Widget _buildProBottomNavigationBar(bool isLowEnd) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E27),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
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
        backgroundColor: const Color(0xFF0A0E27),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white.withOpacity(0.6),
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
                    Icons.rocket_launch,
                    size: isLowEnd ? 20 : 24,
                  ),
                  if (_selectedIndex == 0)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 20,
                      height: 2,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                ],
              ),
            ),
            label: 'Pro Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore,
              size: isLowEnd ? 20 : 24,
            ),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.analytics,
              size: isLowEnd ? 20 : 24,
            ),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: isLowEnd ? 20 : 24,
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
