import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_assets.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    AuthController controller = Get.put(AuthController());

    return Scaffold(
      backgroundColor: AppColors.bgSurface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: sw * 0.05,
              right: sw * 0.05,
              top: sh * 0.015,
              bottom: sh * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurface,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.02),

                Text('Create your account', style: AppTextStyles.h1()),
                SizedBox(height: sh * 0.005),
                Text(
                  'Tell us how you\'ll use Hall Mate.',
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: sh * 0.02),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.bgSurface,
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(9),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryTint,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.search,
                                      size: 20,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: sh * 0.015),
                              Text(
                                'Customer',
                                style: AppTextStyles.titleMedium(),
                              ),
                              SizedBox(height: sh * 0.005),
                              Text(
                                'I\'m looking for a venue for my event',
                                style: AppTextStyles.bodySmall(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: sw * 0.03),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    AppAssets.logo,
                                    width: 38,
                                    height: 38,
                                    fit: BoxFit.contain,
                                  ),
                                  const Icon(
                                    Icons.check_circle,
                                    size: 22,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                              SizedBox(height: sh * 0.015),
                              Text(
                                'Venue manager',
                                style: AppTextStyles.titleMedium(),
                              ),
                              SizedBox(height: sh * 0.005),
                              Text(
                                'I run a venue and want bookings',
                                style: AppTextStyles.bodySmall(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: sh * 0.02),

                Text(
                  'What type of venue do you run?',
                  style: AppTextStyles.titleSmall(),
                ),
                SizedBox(height: sh * 0.012),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.bgSurface,
                            border: Border.all(color: AppColors.borderStrong),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Center(
                            child: Text(
                              'Ballroom',
                              style: AppTextStyles.titleSmall(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            border: Border.all(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Center(
                            child: Text(
                              'Banquet',
                              style: AppTextStyles.titleSmall(
                                color: AppColors.textOnPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.bgSurface,
                            border: Border.all(color: AppColors.borderStrong),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Center(
                            child: Text(
                              'Outdoor',
                              style: AppTextStyles.titleSmall(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: sh * 0.01),
                Text(
                  'Next you\'ll add per-head menu packages and minimum guests.',
                  style: AppTextStyles.bodySmall(color: AppColors.textMuted),
                ),
                SizedBox(height: sh * 0.02),

                Text('Venue name', style: AppTextStyles.titleSmall()),
                SizedBox(height: sh * 0.01),
                TextField(
                  textInputAction: TextInputAction.next,
                  style: AppTextStyles.bodyLarge(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.bgScreen,
                    prefixIcon: const Icon(
                      Icons.door_front_door_outlined,
                      size: 20,
                      color: AppColors.textMuted,
                    ),
                    hintText: 'e.g. Shaan Banquet Hall',
                    hintStyle: AppTextStyles.bodyLarge(
                      color: AppColors.textMuted,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.borderStrong,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.02),

                Text('Full name', style: AppTextStyles.titleSmall()),
                SizedBox(height: sh * 0.01),
                TextField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  style: AppTextStyles.bodyLarge(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.bgScreen,
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      size: 20,
                      color: AppColors.textMuted,
                    ),
                    hintText: 'Your full name',
                    hintStyle: AppTextStyles.bodyLarge(
                      color: AppColors.textMuted,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.borderStrong,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.02),

                Text('Email', style: AppTextStyles.titleSmall()),
                SizedBox(height: sh * 0.01),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: AppTextStyles.bodyLarge(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.bgScreen,
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      size: 20,
                      color: AppColors.textMuted,
                    ),
                    hintText: 'you@example.com',
                    hintStyle: AppTextStyles.bodyLarge(
                      color: AppColors.textMuted,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.borderStrong,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.02),

                Text('Phone number', style: AppTextStyles.titleSmall()),
                SizedBox(height: sh * 0.01),
                TextField(
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  style: AppTextStyles.bodyLarge(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.bgScreen,
                    prefixIcon: const Icon(
                      Icons.phone_outlined,
                      size: 20,
                      color: AppColors.textMuted,
                    ),
                    hintText: '+92 3XX XXXXXXX',
                    hintStyle: AppTextStyles.bodyLarge(
                      color: AppColors.textMuted,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.borderStrong,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.02),

                Text('Password', style: AppTextStyles.titleSmall()),
                SizedBox(height: sh * 0.01),
                Obx(
                  () => TextField(
                    textInputAction: TextInputAction.done,
                    obscureText: controller.isObscure.value,
                    style: AppTextStyles.bodyLarge(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.bgScreen,
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        size: 20,
                        color: AppColors.textMuted,
                      ),
                      suffixIcon: IconButton(
                        onPressed: controller.toggleObscure,
                        icon: Icon(
                          controller.isObscure.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textMuted,
                        ),
                      ),
                      hintText: 'At least 8 characters',
                      hintStyle: AppTextStyles.bodyLarge(
                        color: AppColors.textMuted,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.borderStrong,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.02),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.verified_user_outlined,
                        size: 20,
                        color: AppColors.accentStrongInk,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'New venues stay hidden from search until an admin approves them. You can set up photos and packages while you wait.',
                          style: AppTextStyles.bodySmall(
                            color: AppColors.accentInk,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sh * 0.025),

                SizedBox(
                  width: double.infinity,
                  height: (sh * 0.065).clamp(48.0, 58.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Create account',
                      style: AppTextStyles.labelButton(
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.015),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Log in',
                        style: AppTextStyles.titleSmall(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
