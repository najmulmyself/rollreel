import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/secondary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _OnboardingPage(
        icon: CupertinoIcons.rectangle_stack_fill,
        title: 'Your Videos. Finally Watchable.',
        body: 'Swipe through your camera roll like reels. No uploads, no account, no cloud.',
      ),
      _OnboardingPage(
        icon: CupertinoIcons.lock_fill,
        title: '100% Private. 100% Yours.',
        body: 'Everything stays on your iPhone. RollReel reads local videos and never sends them away.',
      ),
      _OnboardingPage(
        icon: CupertinoIcons.photo_on_rectangle,
        title: 'Let\'s Find Your Videos',
        body: 'Grant photo library access to load local videos into your swipe feed.',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(RRSpace.sp20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.onDone,
                  child: const Text('Skip'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (value) => setState(() => _index = value),
                  itemCount: pages.length,
                  itemBuilder: (context, index) => pages[index],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (dot) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: RRSpace.sp4),
                    width: dot == _index ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(RRSpace.radiusFull),
                      gradient: dot == _index ? RRColors.gradBrand : null,
                      color: dot == _index ? null : RRColors.textDisabled,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: RRSpace.sp20),
              if (_index < pages.length - 1)
                PrimaryButton(
                  label: 'Continue',
                  onPressed: () => _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                )
              else
                Column(
                  children: [
                    PrimaryButton(label: 'Allow Access to Videos', onPressed: widget.onDone),
                    const SizedBox(height: RRSpace.sp12),
                    SecondaryButton(label: 'Not Now', onPressed: widget.onDone),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 124,
          height: 124,
          decoration: BoxDecoration(
            gradient: RRColors.gradBrand,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(icon, size: 64, color: Colors.white),
        ),
        const SizedBox(height: RRSpace.sp24),
        Text(title, style: RRTypography.title1, textAlign: TextAlign.center),
        const SizedBox(height: RRSpace.sp12),
        Text(body, style: RRTypography.body.copyWith(color: RRColors.textSecond), textAlign: TextAlign.center),
      ],
    );
  }
}
