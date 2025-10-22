import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/payment_service.dart';
import '../utils/performance_utils.dart';
import 'pro_home_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isProcessing = false;
  String? _selectedPlan;

  final List<PricingPlan> _plans = [
    PricingPlan(
      name: 'Monthly Pro',
      price: '\$9.99',
      period: '/month',
      features: [
        'All GPS features',
        'Real-time tracking',
        '3D navigation',
        'Weather integration',
        'No ads',
      ],
      isPopular: false,
    ),
    PricingPlan(
      name: 'Yearly Pro',
      price: '\$79.99',
      period: '/year',
      features: [
        'All GPS features',
        'Real-time tracking',
        '3D navigation',
        'Weather integration',
        'No ads',
        'Priority support',
        'Advanced analytics',
      ],
      isPopular: true,
      savings: 'Save 33%',
    ),
    PricingPlan(
      name: 'Lifetime Pro',
      price: '\$199.99',
      period: 'one-time',
      features: [
        'All GPS features',
        'Real-time tracking',
        '3D navigation',
        'Weather integration',
        'No ads',
        'Priority support',
        'Advanced analytics',
        'Future updates',
        'Lifetime access',
      ],
      isPopular: false,
      savings: 'Best Value',
    ),
  ];

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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
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
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E27),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Upgrade to Pro',
          style: GoogleFonts.inter(
            fontSize: isLowEnd ? 18 : 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Hero Section
                _buildHeroSection(isLowEnd),
                const SizedBox(height: 32),
                
                // Pricing Plans
                _buildPricingPlans(isLowEnd),
                const SizedBox(height: 32),
                
                // Payment Button
                _buildPaymentButton(isLowEnd),
                const SizedBox(height: 24),
                
                // Security Info
                _buildSecurityInfo(isLowEnd),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isLowEnd) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E3A8A),
            Color(0xFF3B82F6),
            Color(0xFF8B5CF6),
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.diamond,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Unlock Premium Features',
            style: GoogleFonts.inter(
              fontSize: isLowEnd ? 20 : 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Get access to advanced GPS tools, real-time tracking, and premium features',
            style: GoogleFonts.inter(
              fontSize: isLowEnd ? 12 : 14,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingPlans(bool isLowEnd) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Your Plan',
            style: GoogleFonts.inter(
              fontSize: isLowEnd ? 18 : 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ..._plans.map((plan) => _buildPricingCard(plan, isLowEnd)),
        ],
      ),
    );
  }

  Widget _buildPricingCard(PricingPlan plan, bool isLowEnd) {
    final isSelected = _selectedPlan == plan.name;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = plan.name;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                )
              : LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFFD700)
                : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Selection indicator
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                  color: isSelected ? Colors.white : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Color(0xFFFFD700),
                        size: 16,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              
              // Plan details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          plan.name,
                          style: GoogleFonts.inter(
                            fontSize: isLowEnd ? 16 : 18,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : Colors.white,
                          ),
                        ),
                        if (plan.isPopular) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'POPULAR',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          plan.price,
                          style: GoogleFonts.inter(
                            fontSize: isLowEnd ? 20 : 24,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? Colors.white : const Color(0xFFFFD700),
                          ),
                        ),
                        Text(
                          plan.period,
                          style: GoogleFonts.inter(
                            fontSize: isLowEnd ? 12 : 14,
                            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                          ),
                        ),
                        if (plan.savings != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              plan.savings!,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentButton(bool isLowEnd) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _selectedPlan != null && !_isProcessing
              ? _processPayment
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedPlan != null
                ? const Color(0xFFFFD700)
                : Colors.grey.withOpacity(0.3),
            foregroundColor: _selectedPlan != null
                ? const Color(0xFF0A0E27)
                : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: _selectedPlan != null ? 8 : 0,
            shadowColor: const Color(0xFFFFD700).withOpacity(0.3),
          ),
          child: _isProcessing
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0A0E27)),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.payment, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _selectedPlan != null
                          ? 'Upgrade to Pro - \$${_getSelectedPlanPrice()}'
                          : 'Select a Plan',
                      style: GoogleFonts.inter(
                        fontSize: isLowEnd ? 14 : 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSecurityInfo(bool isLowEnd) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(
            Icons.security,
            color: Colors.green,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Secure payment powered by Stripe. Your payment information is encrypted and secure.',
              style: GoogleFonts.inter(
                fontSize: isLowEnd ? 10 : 12,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSelectedPlanPrice() {
    final selectedPlan = _plans.firstWhere((plan) => plan.name == _selectedPlan);
    return selectedPlan.price.replaceAll('\$', '');
  }

  Future<void> _processPayment() async {
    if (_selectedPlan == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final selectedPlan = _plans.firstWhere((plan) => plan.name == _selectedPlan);
      final amount = _getSelectedPlanPrice();
      
      final result = await PaymentService.processPayment(
        amount: amount,
        currency: 'usd',
        description: 'Pro GPS Subscription - ${selectedPlan.name}',
      );

      if (result.isSuccess) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Payment successful! Welcome to Pro!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate to Pro home
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ProHomeScreen()),
          (route) => false,
        );
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: ${result.errorMessage}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }
}

class PricingPlan {
  final String name;
  final String price;
  final String period;
  final List<String> features;
  final bool isPopular;
  final String? savings;

  PricingPlan({
    required this.name,
    required this.price,
    required this.period,
    required this.features,
    required this.isPopular,
    this.savings,
  });
}
