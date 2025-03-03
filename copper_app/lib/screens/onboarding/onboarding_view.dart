import 'package:copper_app/components/buttons/primary_cta_button.dart';
import 'package:copper_app/theme/insets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'onboarding_controller.dart';
import 'onboarding_route.dart';

/// View for the [OnboardingRoute].
class OnboardingView extends StatelessWidget {
  /// Creates an instance of [OnboardingView].
  const OnboardingView(this.state, {super.key});

  /// A controller for this view.
  final OnboardingController state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.onboardingTitle,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              AppLocalizations.of(context)!.onboardingSubtitle,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Padding(
              padding: const EdgeInsets.all(Insets.medium),
              child: Image.asset(
                'assets/copper_icon.png',
                width: 200,
              ),
            ),
            PrimaryCtaButton(
              onPressed: state.handleOnboardingComplete,
              child: Padding(
                padding: const EdgeInsets.all(Insets.small),
                child: Text(
                  AppLocalizations.of(context)!.onboardingButton,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
