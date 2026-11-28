import 'package:flutter/material.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/controller/shared/auth_controller.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sw * 0.05,
                vertical: sh * 0.018,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {Get.back();},
                    child: Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text('Forgot password', style: AppTextStyles.titleLarge()),
                ],
              ),
            ),
            Divider(color: colors.border, height: 1),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: sw * 0.05,
                    right: sw * 0.05,
                    top: sh * 0.03,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: colors.primarySoft,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.lock_outline_rounded,
                          size: 26,
                          color: colors.primaryInk,
                        ),
                      ),
                      SizedBox(height: sh * 0.02),

                      Text('Reset your password', style: AppTextStyles.h2()),
                      SizedBox(height: sh * 0.008),
                      Text(
                        'We sent a 6-digit code to ali•••@email.com. Enter it below, then choose a new password.',
                        style: AppTextStyles.bodyMedium(
                          color: colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: sh * 0.025),

                      Row(
                        children: [0, 1, 2, 3, 4, 5].map((index) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index == 5 ? 0 : 8,
                              ),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                style: AppTextStyles.h3(),
                                decoration: InputDecoration(
                                  counterText: '',
                                  filled: true,
                                  fillColor: colors.bgScreen,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: colors.borderStrong,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: colors.primaryBorder,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: sh * 0.012),

                      RichText(
                        text: TextSpan(
                          style: AppTextStyles.bodySmall(
                            color: colors.textMuted,
                          ),
                          children: [
                            const TextSpan(text: 'Didn\'t get it? '),
                            TextSpan(
                              text: 'Resend in 0:42',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: sh * 0.025),

                      Text('New password', style: AppTextStyles.titleSmall()),
                      SizedBox(height: sh * 0.01),
                      Obx(
                        () => TextField(
                          textInputAction: TextInputAction.next,
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
                              borderSide: BorderSide(
                                color: colors.primaryBorder,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sh * 0.02),

                      Text(
                        'Confirm password',
                        style: AppTextStyles.titleSmall(),
                      ),
                      SizedBox(height: sh * 0.01),
                      TextField(
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        style: AppTextStyles.bodyLarge(),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colors.bgScreen,
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            size: 20,
                            color: colors.textMuted,
                          ),
                          hintText: 'Repeat your new password',
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
                            borderSide: BorderSide(
                              color: colors.primaryBorder,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: sh * 0.02),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                left: sw * 0.05,
                right: sw * 0.05,
                top: sh * 0.01,
                bottom: sh * 0.03,
              ),
              child: SizedBox(
                width: double.infinity,
                height: (sh * 0.065).clamp(48.0, 58.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Later (API): send the code and the new password first
                    Get.back();
                    Get.snackbar(
                      'Password reset',
                      'You can now log in with your new password',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.textOnPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Reset password',
                    style: AppTextStyles.labelButton(
                      color: colors.textOnPrimary,
                    ),
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
