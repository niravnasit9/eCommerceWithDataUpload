import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yt_ecommerce_admin_panel/admin/screens/admin_navigation_menu.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/user/user_repository.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/login/login.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/onBoarding/onboarding.dart';
import 'package:yt_ecommerce_admin_panel/features/authentication/screens/signup/verify_email.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/product/cart_controller.dart';
import 'package:yt_ecommerce_admin_panel/navigation_menu.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/exceptions/platform_exceptions.dart';
import 'package:yt_ecommerce_admin_panel/utils/local_storage/storage_utility.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  /// To Get authenticated users data
  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

// Update the screenRedirect method
  screenRedirect() async {
    final isAdmin = deviceStorage.read("isAdmin") ?? false;

    if (isAdmin) {
      Get.offAll(() => const AdminNavigationMenu());
      return;
    }

    final user = _auth.currentUser;

    if (user != null) {
      if (user.emailVerified) {
        // ✅ Initialize storage for logged-in user AFTER login
        await TLocalStorage.instance.initializeForUser(user.uid);

        // ✅ Reload cart for this user
        if (Get.isRegistered<CartController>()) {
          final cartController = Get.find<CartController>();
          cartController.loadCartItems();
        }

        Get.offAll(() => const NavigationMenu());
      } else {
        Get.offAll(() => VerifyEmailScreen(email: user.email));
      }
    } else {
      deviceStorage.writeIfNull('IsFirstTime', true);

      deviceStorage.read('IsFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(const OnBoardingScreen());
    }
  }

// Update login method to reload cart
  Future<UserCredential?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      if (email.trim() == "admin@gmail.com" && password.trim() == "123456") {
        deviceStorage.write("isAdmin", true);
        Get.offAll(() => const AdminNavigationMenu());
        return null;
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // ✅ Initialize storage for user after login
      if (userCredential.user != null) {
        await TLocalStorage.instance
            .initializeForUser(userCredential.user!.uid);

        // ✅ Reload cart for this user
        if (Get.isRegistered<CartController>()) {
          final cartController = Get.find<CartController>();
          cartController.loadCartItems();
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong. Please try again.';
    }
  }

  /// [EmailAuthentication] Register

  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong.Please try again.';
    }
  }

  /// [EmailVerification] Mail Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong.Please try again.';
    }
  }

  /// [ForgetPassword] Forget Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong.Please try again.';
    }
  }

  /// [ReAuthentication] ReAuthenticate User

  Future<void> reAuthenticateWithEmailAndPassword(
      String email, String password) async {
    try {
      // Create a credential
      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);
      // ReAuthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong.Please try again.';
    }
  }

  /// [GoogleAuthentication] Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      /// Trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      /// Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await userAccount?.authentication;

      /// Create a new credential
      final credentials = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      /// Once signed in,return the UserCredential
      return await _auth.signInWithCredential(credentials);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print('Something went wrong: $e');
      return null;
    }
  }

  /// [FacebookAuthentication] Facebook

  /// [LogoutUser] Valid for any authentication.
  Future<void> logout() async {
    try {
      /// Check admin session
      final isAdmin = deviceStorage.read("isAdmin") ?? false;

      if (isAdmin) {
        /// 🔥 Admin Logout
        deviceStorage.remove("isAdmin");
      } else {
        /// 🔥 Firebase User Logout
        if (_auth.currentUser != null) {
          await _auth.signOut();
        }

        await GoogleSignIn().signOut();
      }

      /// Redirect to Login
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong.Please try again.';
    }
  }

  /// [DeleteUser] Remove user Auth and Firebase Account.
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecords(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something Went Wrong.Please try again.';
    }
  }
}
