import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hall_mate/controller/shared/app_data_controller.dart';
import 'package:hall_mate/controller/shared/nav_controller.dart';
import 'package:hall_mate/controller/manager/manager_nav_controller.dart';
import 'package:hall_mate/controller/user/venue/favourite_controller.dart';
import 'package:hall_mate/utils/app_format.dart';
import 'package:hall_mate/view/auth/login_screen.dart';
import 'package:hall_mate/view/manager/manager_nav_bar.dart';
import 'package:hall_mate/view/manager/venue/venue_form_screen.dart';
import 'package:hall_mate/view/user/nav_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final AppDataController data = Get.find<AppDataController>();

  @override
  void onReady() {
    splashLoader();
    super.onReady();
  }

  RxBool isCheck = false.obs;
  RxBool isObscure = true.obs;
  RxBool isVenueManager = false.obs;
  RxString selectedVenueType = 'Banquet'.obs;

  // ── Login fields ──
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  // ── Sign up fields ──
  TextEditingController venueNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // ══════════════════════════════════════════════════════════
  // DUMMY ACCOUNTS (until the API is ready).
  // A real login API sends back the user and the role, the same way.
  // 'venueId' tells which venue a manager runs.
  // ══════════════════════════════════════════════════════════
  List<Map<String, String>> accounts = [
    {
      'name': 'Ali Raza',
      'email': 'ali@hallmate.pk',
      'password': '12345678',
      'phone': '+92 300 1234567',
      'role': 'Customer',
      'venueId': '',
    },
    {
      'name': 'Imran Siddiqui',
      'email': 'imran@hallmate.pk',
      'password': '12345678',
      'phone': '+92 321 7654321',
      'role': 'Venue manager',
      'venueId': 'v1',
    },
  ];

  // The account that is logged in now
  Map<String, String> currentUser = {};

  bool isManager() {
    return currentUser['role'] == 'Venue manager';
  }

  String userName() {
    return currentUser['name'] ?? '';
  }

  String firstName() {
    return userName().split(' ').first;
  }

  String userInitials() {
    return AppFormat.initials(userName());
  }

  String userEmail() {
    return currentUser['email'] ?? '';
  }

  String userPhone() {
    return currentUser['phone'] ?? '';
  }

  String userRole() {
    return currentUser['role'] ?? '';
  }

  // The venue of the logged-in manager ('' for a customer)
  String venueId() {
    return currentUser['venueId'] ?? '';
  }

  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }

  void selectCustomer() {
    isVenueManager.value = false;
  }

  void selectVenueManager() {
    isVenueManager.value = true;
  }

  void selectVenueType(String type) {
    selectedVenueType.value = type;
  }

  void rememberMe() {
    isCheck.value = !isCheck.value;
  }

  // Finds the account with this email, or null
  Map<String, String>? findAccount(String email) {
    for (var account in accounts) {
      if (account['email'] == email.trim().toLowerCase()) {
        return account;
      }
    }
    return null;
  }

  // Opens the right home: the manager app or the customer app
  void openHome() {
    if (isManager()) {
      Get.find<ManagerNavController>().changeIndex(0);
      Get.offAll(() => const ManagerNavBar());
    } else {
      // The hearts of this customer
      Get.find<FavouriteController>().loadFor(userName());
      Get.find<NavController>().changeIndex(0);
      Get.offAll(() => const NavBarWidget());
    }
  }

  // Splash: wait 3 seconds. If "Keep me logged in" was ticked last time,
  // open the home straight away, else open the Login screen.
  Future<void> splashLoader() async {
    await Future.delayed(const Duration(seconds: 3));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String savedEmail = prefs.getString('savedEmail') ?? '';
    final Map<String, String>? account = findAccount(savedEmail);

    if (account != null) {
      currentUser = account;
      openHome();
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  Future<void> logIn() async {
    final String email = loginEmailController.text.trim();
    final String password = loginPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Missing details', 'Please enter your email and password');
      return;
    }

    final Map<String, String>? account = findAccount(email);
    if (account == null || account['password'] != password) {
      Get.snackbar('Login failed', 'Wrong email or password');
      return;
    }

    currentUser = account;

    // Keep me logged in: remember the email for the next app start
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isCheck.value) {
      await prefs.setString('savedEmail', userEmail());
    } else {
      await prefs.remove('savedEmail');
    }

    loginPasswordController.clear();
    Get.snackbar('Welcome', firstName());
    openHome();
  }

  void signUp() {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim().toLowerCase();
    final String phone = phoneController.text.trim();
    final String password = passwordController.text;
    final String venueName = venueNameController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
      Get.snackbar('Missing details', 'Please fill in every field');
      return;
    }
    if (!email.contains('@')) {
      Get.snackbar('Email', 'Please enter a valid email');
      return;
    }
    if (password.length < 8) {
      Get.snackbar('Password', 'Use at least 8 characters');
      return;
    }
    if (findAccount(email) != null) {
      Get.snackbar('Email', 'An account with this email already exists');
      return;
    }
    if (isVenueManager.value && venueName.isEmpty) {
      Get.snackbar('Venue name', 'Please enter the name of your venue');
      return;
    }

    // A manager gets an empty venue of the chosen type
    String newVenueId = '';
    if (isVenueManager.value) {
      newVenueId = data.addVenue(
        name: venueName,
        type: selectedVenueType.value,
        managerName: name,
      );
    }

    final Map<String, String> account = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'role': isVenueManager.value ? 'Venue manager' : 'Customer',
      'venueId': newVenueId,
    };
    accounts.add(account);
    currentUser = account;

    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    venueNameController.clear();

    if (isManager()) {
      // Step 1 of the setup: the venue details form
      Get.offAll(() => const VenueFormScreen(isSetup: true));
    } else {
      Get.snackbar('Welcome', 'Your account is ready');
      openHome();
    }
  }

  Future<void> logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedEmail');
    currentUser = {};
    isCheck.value = false;
    Get.offAll(() => const LoginScreen());
  }
}
