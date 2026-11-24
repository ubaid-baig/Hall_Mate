import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_assets.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/shared/auth_controller.dart';
import 'package:hall_mate/view/auth/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final colors = AppColors.of(context);
    // AuthController controller = Get.put(AuthController());
    final AuthController controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: colors.bgSurface,
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
                  onTap: () {Get.off(LoginScreen());},
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.bgSurface,
                      border: Border.all(color: colors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.02),

                Text('Create your account', style: AppTextStyles.h1()),
                SizedBox(height: sh * 0.005),
                Text(
                  'Tell us how you\'ll use Hall Mate.',
                  style: AppTextStyles.bodyMedium(
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: sh * 0.02),

                // The two role cards. Obx rebuilds them when isVenueManager changes.
                Obx(() {
                  // Read the value once here, then use it for both cards.
                  final bool isManager = controller.isVenueManager.value;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: controller.selectCustomer,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isManager
                                  ? colors.bgSurface
                                  : colors.primarySoft,
                              border: Border.all(
                                color: isManager
                                    ? colors.border
                                    : colors.primaryBorder,
                                width: isManager ? 1 : 2,
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
                                    Container(
                                      padding: const EdgeInsets.all(9),
                                      decoration: BoxDecoration(
                                        color: colors.primaryTint,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.search,
                                        size: 20,
                                        color: colors.primaryInk,
                                      ),
                                    ),
                                    if (!isManager)
                                      Icon(
                                        Icons.check_circle,
                                        size: 22,
                                        color: colors.primaryBorder,
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
                                    color: isManager
                                        ? colors.textMuted
                                        : colors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: sw * 0.03),

                      // ── Venue manager card ──
                      Expanded(
                        child: GestureDetector(
                          onTap: controller.selectVenueManager,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isManager
                                  ? colors.primarySoft
                                  : colors.bgSurface,
                              border: Border.all(
                                color: isManager
                                    ? colors.primaryBorder
                                    : colors.border,
                                width: isManager ? 2 : 1,
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
                                    if (isManager)
                                      Icon(
                                        Icons.check_circle,
                                        size: 22,
                                        color: colors.primaryBorder,
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
                                    color: isManager
                                        ? colors.textSecondary
                                        : colors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                SizedBox(height: sh * 0.02),

                Obx(() {
                  if (!controller.isVenueManager.value) {
                    return const SizedBox.shrink();
                  }

                  final String selectedType =
                      controller.selectedVenueType.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What type of venue do you run?',
                        style: AppTextStyles.titleSmall(),
                      ),
                      SizedBox(height: sh * 0.012),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {controller.selectVenueType('Ballroom');},
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: selectedType == 'Ballroom'
                                      ? colors.primary
                                      : colors.bgSurface,
                                  border: Border.all(
                                    color: selectedType == 'Ballroom'
                                        ? colors.primary
                                        : colors.borderStrong,
                                  ),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Center(
                                  child: Text(
                                    'Ballroom',
                                    style: AppTextStyles.titleSmall(
                                      color: selectedType == 'Ballroom'
                                          ? colors.textOnPrimary
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {controller.selectVenueType('Banquet');},
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: selectedType == 'Banquet'
                                      ? colors.primary
                                      : colors.bgSurface,
                                  border: Border.all(
                                    color: selectedType == 'Banquet'
                                        ? colors.primary
                                        : colors.borderStrong,
                                  ),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Center(
                                  child: Text(
                                    'Banquet',
                                    style: AppTextStyles.titleSmall(
                                      color: selectedType == 'Banquet'
                                          ? colors.textOnPrimary
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {controller.selectVenueType('Outdoor');},
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: selectedType == 'Outdoor'
                                      ? colors.primary
                                      : colors.bgSurface,
                                  border: Border.all(
                                    color: selectedType == 'Outdoor'
                                        ? colors.primary
                                        : colors.borderStrong,
                                  ),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Center(
                                  child: Text(
                                    'Outdoor',
                                    style: AppTextStyles.titleSmall(
                                      color: selectedType == 'Outdoor'
                                          ? colors.textOnPrimary
                                          : null,
                                    ),
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
                        style: AppTextStyles.bodySmall(color: colors.textMuted),
                      ),
                      SizedBox(height: sh * 0.02),

                      Text('Venue name', style: AppTextStyles.titleSmall()),
                      SizedBox(height: sh * 0.01),
                      TextField(
                        textInputAction: TextInputAction.next,
                        style: AppTextStyles.bodyLarge(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colors.bgScreen,
                          prefixIcon: Icon(
                            Icons.door_front_door_outlined,
                            size: 20,
                            color: colors.textMuted,
                          ),
                          hintText: 'e.g. Shaan Banquet Hall',
                          hintStyle: AppTextStyles.bodyLarge(
                            color: colors.textMuted,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: colors.borderStrong,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: colors.primaryBorder),
                          ),
                        ),
                      ),
                      SizedBox(height: sh * 0.02),
                    ],
                  );
                }),

                Text('Full name', style: AppTextStyles.titleSmall()),
                SizedBox(height: sh * 0.01),
                TextField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  style: AppTextStyles.bodyLarge(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colors.bgScreen,
                    prefixIcon: Icon(
                      Icons.person_outline,
                      size: 20,
                      color: colors.textMuted,
                    ),
                    hintText: 'Your full name',
                    hintStyle: AppTextStyles.bodyLarge(
                      color: colors.textMuted,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: colors.borderStrong,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.primaryBorder),
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
                    fillColor: colors.bgScreen,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      size: 20,
                      color: colors.textMuted,
                    ),
                    hintText: 'you@example.com',
                    hintStyle: AppTextStyles.bodyLarge(
                      color: colors.textMuted,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: colors.borderStrong,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.primaryBorder),
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
                    fillColor: colors.bgScreen,
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      size: 20,
                      color: colors.textMuted,
                    ),
                    hintText: '+92 3XX XXXXXXX',
                    hintStyle: AppTextStyles.bodyLarge(
                      color: colors.textMuted,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: colors.borderStrong,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: colors.primaryBorder),
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
                      fillColor: colors.bgScreen,
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        size: 20,
                        color: colors.textMuted,
                      ),
                      suffixIcon: IconButton(
                        onPressed: controller.toggleObscure,
                        icon: Icon(
                          controller.isObscure.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: colors.textMuted,
                        ),
                      ),
                      hintText: 'At least 8 characters',
                      hintStyle: AppTextStyles.bodyLarge(
                        color: colors.textMuted,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: colors.borderStrong,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: colors.primaryBorder),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: sh * 0.02),

                // Admin-approval note is about venues, so only a venue manager sees it.
                Obx(() {
                  if (!controller.isVenueManager.value) {
                    return const SizedBox();
                  }

                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: colors.accentSoft,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              size: 20,
                              color: colors.accentStrongInk,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'New venues stay hidden from search until an admin approves them. You can set up photos and packages while you wait.',
                                style: AppTextStyles.bodySmall(
                                  color: colors.accentInk,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: sh * 0.025),
                    ],
                  );
                }),

                SizedBox(
                  width: double.infinity,
                  height: (sh * 0.065).clamp(48.0, 58.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.textOnPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Create account',
                      style: AppTextStyles.labelButton(
                        color: colors.textOnPrimary,
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
                        color: colors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: (){Get.off(LoginScreen());},
                      child: Text(
                        'Log in',
                        style: AppTextStyles.titleSmall(
                          color: colors.primaryInk,
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