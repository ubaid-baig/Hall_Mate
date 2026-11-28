import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_assets.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: sh * 0.33),

              // Logo
              Image.asset(
                AppAssets.logo,
                width: sw * 0.26,
                height: sw * 0.26,
                fit: BoxFit.contain,
              ),
              SizedBox(height: sh * 0.03),

              // App name (Heading/H1)
              Text(
                'Hall Mate',
                style: AppTextStyles.h1(color: colors.textOnPrimary),
              ),
              SizedBox(height: sh * 0.012),

              // Tagline (Body/Medium)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: sw * 0.18),
                child: Text(
                  'Find, negotiate and book\nthe right venue for your event',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium(color: colors.textOnPrimaryMute),
                ),
              ),

              SizedBox(height: sh * 0.19),

              // Progress bar
              SizedBox(
                width: sw * 0.28,
                child: LinearProgressIndicator(
                  // value: 0.15,
                  minHeight: 3,
                  borderRadius: BorderRadius.circular(4),
                  color: colors.accent,
                  backgroundColor: colors.textOnPrimary.withValues(alpha: 0.2),
                ),
              ),
              SizedBox(height: sh * 0.015),

              // Categories (Label/Tiny)
              Text(
                'Ballrooms · Banquets · Outdoor lawns',
                style: AppTextStyles.labelTiny(color: colors.textOnPrimaryMute),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
