import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildPage(AppStrings.onboardingTitle1, 'Organize all transactions in one place'),
      _buildPage(AppStrings.onboardingTitle2, 'Get personalized AI tips'),
      _buildPage(AppStrings.onboardingTitle3, 'Reach your financial goals'),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(onPressed: () {/* skip to end */}, child: const Text('Skip')),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => pages[i],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(pages.length, (i) => _dot(i == _page))),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
              child: _page == pages.length - 1
                  ? ElevatedButton(
                      onPressed: () {/* navigate to auth/login */},
                      child: const SizedBox(width: double.infinity, child: Center(child: Text('Get Started'))),
                    )
                  : OutlinedButton(
                      onPressed: () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                      child: const Text('Next'),
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPage(String title, String subtitle) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFEEF2FF), Color(0xFFDDEBFF)]),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            ]),
          ),
        ),
      );

  Widget _dot(bool active) => AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.symmetric(horizontal: 6), width: active ? 16 : 8, height: 8, decoration: BoxDecoration(color: active ? Theme.of(context).colorScheme.primary : Colors.grey, borderRadius: BorderRadius.circular(8)));
}
