import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stoneecho/core/router/route_names.dart';
import 'package:stoneecho/core/theme/app_colors.dart';
import 'package:stoneecho/features/onboarding/widgets/onboarding_page.dart';
import 'package:stoneecho/shared/extensions/context_extensions.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _totalPages = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) {
      context.goNamed(RouteNames.home);
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  OnboardingPage(
                    title: l10n.onboardingTitle1,
                    body: l10n.onboardingBody1,
                    icon: Icons.headphones,
                  ),
                  OnboardingPage(
                    title: l10n.onboardingTitle2,
                    body: l10n.onboardingBody2,
                    icon: Icons.cloud_off,
                  ),
                  OnboardingPage(
                    title: l10n.onboardingTitle3,
                    body: l10n.onboardingBody3,
                    icon: Icons.local_florist,
                  ),
                  OnboardingPage(
                    title: l10n.onboardingTitle4,
                    body: l10n.onboardingBody4,
                    icon: Icons.location_on,
                    isLastPage: true,
                  ),
                ],
              ),
            ),

            // Page indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _totalPages,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.forestGreen
                        : AppColors.textLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: Text(l10n.skipForNow),
                    )
                  else
                    TextButton(
                      onPressed: _completeOnboarding,
                      child: Text(l10n.skipForNow),
                    ),
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage == _totalPages - 1
                          ? l10n.getStarted
                          : l10n.next,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
