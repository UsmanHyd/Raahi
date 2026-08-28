import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/social_sign_in_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() {
    // TODO: wire to the auth repository once the backend is in place.
  }

  void _continueWithGoogle() {
    // TODO: wire to the auth repository once the backend is in place.
  }

  void _continueWithApple() {
    // TODO: wire to the auth repository once the backend is in place.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface50,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Create your account',
                          textAlign: TextAlign.center,
                          style: AppTypography.h1,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Provide your email and password to create your '
                          'account and get started.',
                          textAlign: TextAlign.center,
                          style: AppTypography.body.copyWith(
                            color: AppColors.ink600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Row(
                        children: [
                          Expanded(
                            child: SocialSignInButton(
                              logoAsset: 'assets/signup/google_logo.svg',
                              label: 'Google',
                              onPressed: _continueWithGoogle,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: SocialSignInButton(
                              logoAsset: 'assets/signup/apple_logo.svg',
                              label: 'Apple',
                              onPressed: _continueWithApple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(color: AppColors.border),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                            child: Text(
                              'or',
                              style: AppTypography.captionEmphasis,
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: AppColors.border),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppTextField(
                        label: 'Email Address',
                        hintText: 'you@example.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        labelStyle: AppTypography.caption.copyWith(
                          color: AppColors.ink600,
                        ),
                        borderRadius: 28,
                        showBorder: false,
                        boxShadow: AppShadows.card,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        label: 'Password',
                        hintText: 'Create a password',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        labelStyle: AppTypography.caption.copyWith(
                          color: AppColors.ink600,
                        ),
                        borderRadius: 28,
                        showBorder: false,
                        boxShadow: AppShadows.card,
                        suffixIcon: IconButton(
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.ink300,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Transform.scale(
                            scale: 0.85,
                            child: Switch(
                              value: _agreedToTerms,
                              onChanged: (value) =>
                                  setState(() => _agreedToTerms = value),
                              activeTrackColor: AppColors.primary700,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.ink600,
                                ),
                                children: const [
                                  TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: 'Terms',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.ink900,
                                    ),
                                  ),
                                  TextSpan(text: ' & '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.ink900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      PrimaryButton(
                        label: 'Sign Up',
                        onPressed: _agreedToTerms ? _signUp : null,
                        expand: true,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: AppTypography.body.copyWith(
                              color: AppColors.ink600,
                            ),
                            children: [
                              const TextSpan(text: 'Already have an account? '),
                              TextSpan(
                                text: 'Sign In',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink900,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // TODO: navigate to the login screen once built.
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
