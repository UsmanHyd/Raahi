import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const List<_OnboardingPage> _pages = [
    _OnboardingPage(
      imageAsset: 'assets/onboarding/onboarding1.svg',
      title: 'Plan scenic road trips',
      subtitle:
          'Discover the best routes, stopovers, and hotels across Pakistan.',
    ),
    _OnboardingPage(
      imageAsset: 'assets/onboarding/onboarding2.svg',
      title: 'Navigate with confidence',
      subtitle:
          'Real-time road conditions, rest stops, and offline maps for remote areas.',
    ),
    _OnboardingPage(
      imageAsset: 'assets/onboarding/onboarding3.svg',
      title: 'Book & explore locally',
      subtitle:
          'Find curated hotels, hidden gems, and local experiences along your route.',
    ),
  ];

  int _currentPage = 0;

  void _showNextPage() {
    if (_currentPage < _pages.length - 1) {
      setState(() => _currentPage++);
    }
  }

  void _skipToLastPage() {
    if (_currentPage != _pages.length - 1) {
      setState(() => _currentPage = _pages.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      backgroundColor: AppColors.surface50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _skipToLastPage,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.ink600,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    textStyle: AppTypography.captionEmphasis,
                  ),
                  child: const Text('Skip'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.lg),
                  child: ColoredBox(
                    color: AppColors.surface0,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 5,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            child: SizedBox.expand(
                              key: ValueKey(page.imageAsset),
                              child: SvgPicture.asset(
                                page.imageAsset,
                                fit: BoxFit.cover,
                                placeholderBuilder: (context) =>
                                    const ColoredBox(
                                      color: AppColors.primary100,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary700,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.lg,
                              AppSpacing.xl,
                              AppSpacing.lg,
                              AppSpacing.lg,
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Column(
                                key: ValueKey(page.title),
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(page.title, style: AppTypography.h2),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    page.subtitle,
                                    style: AppTypography.caption,
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      _PageIndicator(currentPage: _currentPage),
                                      const Spacer(),
                                      FilledButton(
                                        onPressed: _showNextPage,
                                        style: FilledButton.styleFrom(
                                          backgroundColor: AppColors.primary700,
                                          foregroundColor: AppColors.surface0,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppSpacing.xl,
                                            vertical: AppSpacing.md,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              24,
                                            ),
                                          ),
                                          textStyle: AppTypography
                                              .captionEmphasis
                                              .copyWith(
                                                color: AppColors.surface0,
                                              ),
                                        ),
                                        child: Text(
                                          _currentPage == _pages.length - 1
                                              ? 'Get Started'
                                              : 'Next',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
          width: index == currentPage ? 20 : AppSpacing.xs,
          decoration: BoxDecoration(
            color: index == currentPage
                ? AppColors.primary700
                : AppColors.ink300,
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
  });

  final String imageAsset;
  final String title;
  final String subtitle;
}
