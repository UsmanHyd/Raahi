import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../widgets/social_sign_in_button.dart';
import 'complete_profile_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    // TODO: wire to the auth repository once the backend is in place.
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CompleteProfileScreen()));
  }

  void _continueWithGoogle() {
    // TODO: wire to the auth repository once the backend is in place.
  }

  void _continueWithApple() {
    // TODO: wire to the auth repository once the backend is in place.
  }

  void _forgotPassword() {
    // TODO: navigate to the forgot-password flow once built.
  }

  void _goToSignup() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                            'Welcome back',
                            textAlign: TextAlign.center,
                            style: AppTypography.h1,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Stay connected by signing in with your email '
                            'and password to access your account.',
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
                          hintText: 'Enter your password',
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
                                  ? LucideIcons.eyeOff
                                  : LucideIcons.eye,
                              color: AppColors.ink300,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Transform.scale(
                                  scale: 0.85,
                                  child: Switch(
                                    value: _rememberMe,
                                    onChanged: (value) =>
                                        setState(() => _rememberMe = value),
                                    activeTrackColor: AppColors.primary700,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Text(
                                  'Remember me',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.ink600,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: _forgotPassword,
                              child: Text(
                                'Forgot Password?',
                                style: AppTypography.captionEmphasis.copyWith(
                                  color: AppColors.ink900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        PrimaryButton(
                          label: 'Sign In',
                          onPressed: _signIn,
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
                                const TextSpan(text: "Don't have an account? "),
                                TextSpan(
                                  text: 'Sign Up',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink900,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _goToSignup,
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
      ),
    );
  }
}
