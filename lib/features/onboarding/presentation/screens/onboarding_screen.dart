import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/glass_button.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../../auth/presentation/screens/signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const List<_OnboardingPage> _pages = [
    _OnboardingPage(
      imageAsset: 'assets/onboarding/onboarding1.jpg',
      title: 'Plan scenic road trips',
      subtitle:
          'Discover the best routes, stopovers, and hotels across Pakistan.',
      // The road/lake/buildings sit in the left third of this photo — a
      // centered crop would show only bare mountainside.
      alignment: Alignment.centerLeft,
    ),
    _OnboardingPage(
      imageAsset: 'assets/onboarding/onboarding2.jpg',
      title: 'Navigate with confidence',
      subtitle:
          'Real-time road conditions, rest stops, and offline maps for remote areas.',
      alignment: Alignment.center,
    ),
    _OnboardingPage(
      imageAsset: 'assets/onboarding/onboarding3.jpg',
      title: 'Book & explore locally',
      subtitle:
          'Find curated hotels, hidden gems, and local experiences along your route.',
      alignment: Alignment.center,
    ),
  ];

  int _currentPage = 0;

  void _showNextPage() {
    if (_currentPage < _pages.length - 1) {
      setState(() => _currentPage++);
    } else {
      _goToSignup();
    }
  }

  void _skipToSignup() => _goToSignup();

  void _goToSignup() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: Image.asset(
              page.imageAsset,
              key: ValueKey(page.imageAsset),
              fit: BoxFit.cover,
              alignment: page.alignment,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: _SkipButton(onTap: _skipToSignup),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlassSurface(
              borderRadius: AppRadius.sheetRadius,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.xl,
                    AppSpacing.lg,
                    AppSpacing.lg,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Column(
                          key: ValueKey(page.title),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              page.title,
                              style: AppTypography.display.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              page.subtitle,
                              style: AppTypography.body.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        children: [
                          _PageIndicator(currentPage: _currentPage),
                          const Spacer(),
                          GlassButton(
                            label: isLastPage ? 'Get started' : 'Next',
                            onPressed: _showNextPage,
                            tintOpacity: 0.28,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.chip),
        child: GlassSurface(
          borderRadius: BorderRadius.circular(AppRadius.chip),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            'Skip',
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        _OnboardingScreenState._pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(right: AppSpacing.xs),
          height: AppSpacing.xs,
          width: index == currentPage ? 14 : AppSpacing.xs,
          decoration: BoxDecoration(
            color: index == currentPage
                ? Colors.white
                : Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppSpacing.xs),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage {
  const _OnboardingPage({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    this.alignment = Alignment.center,
  });

  final String imageAsset;
  final String title;
  final String subtitle;
  final Alignment alignment;
}
