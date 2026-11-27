import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/constants/app_assets.dart';
import 'package:hall_mate/constants/app_colors.dart';
import 'package:hall_mate/constants/app_text_styles.dart';
import 'package:hall_mate/view/auth/forgot_password_screen.dart';
import 'package:hall_mate/view/auth/sign_up_screen.dart';
import 'package:hall_mate/view/user/nav_bar_widget.dart';
import '../../controller/shared/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sh = MediaQuery.of(context).size.height;
    final sw = MediaQuery.of(context).size.width;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final colors = AppColors.of(context);
    // final AuthController controller = Get.put(AuthController());
    final AuthController controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: colors.bgSurface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: sw * 0.05,
            right: sw * 0.05,
            top: sh * 0.055,
            bottom: sh * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        AppAssets.logo,
                        width: sw * 0.14,
                        height: sw * 0.14,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: sh * 0.02),

                      Text('Welcome back', style: AppTextStyles.h1()),
                      SizedBox(height: sh * 0.005),

                      Text(
                        'Log in to find venues or manage your bookings.',
                        style: AppTextStyles.bodyMedium(
                          color: colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: sh * 0.03),

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
                            borderSide: BorderSide(
                              color: colors.primaryBorder,
                            ),
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
                            hintText: 'Your password',
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

                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Obx(()=>Checkbox(
                                    value: controller.isCheck.value,
                                    activeColor: colors.primary,
                                    onChanged: (value){
                                      controller.rememberMe();
                                    },
                                    ),
                                  )
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Keep me logged in',
                                    style: AppTextStyles.bodyMedium(
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: (){Get.to(ForgotPasswordScreen());},
                            child: Text(
                              'Forgot password?',
                              style: AppTextStyles.titleSmall(
                                color: colors.primaryInk,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: sh * 0.03),

                      SizedBox(
                        width: double.infinity,
                        height: (sh * 0.065).clamp(48.0, 58.0),
                        child: ElevatedButton(
                          onPressed: () {Get.to(NavBarWidget());},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.textOnPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Log in',
                            style: AppTextStyles.labelButton(
                              color: colors.textOnPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (!isKeyboardOpen) ...[
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.bgScreen,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: colors.primaryInk,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'One login for customers and venue managers. We open the right home for your account.',
                          style: AppTextStyles.bodySmall(
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sh * 0.025),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New to Hall Mate? ',
                      style: AppTextStyles.bodyMedium(
                        color: colors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: (){Get.to(SignUpScreen());},
                      child: Text(
                        'Create an account',
                        style: AppTextStyles.titleSmall(
                          color: colors.primaryInk,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
