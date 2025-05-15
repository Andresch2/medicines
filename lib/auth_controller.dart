import 'package:application_medicines/appwrite_config.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final Account account = Account(AppwriteConfig.getClient());
  final Rx<User?> user = Rx<User?>(null);

  final RxString loginError = ''.obs;

  Future<bool> checkAuth() async {
    try {
      final userData = await account.get();
      user.value = userData;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> createAccount(String email, String password) async {
    try {
      await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      await login(email, password);
    } catch (e) {
      loginError.value = e.toString();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      final userData = await account.get();
      user.value = userData;
      loginError.value = '';
      Get.offAllNamed('/medications');
    } catch (e) {
      loginError.value = e.toString();
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSession(sessionId: 'current');
      user.value = null;
      Get.offAllNamed('/login');
    } catch (e) {
      loginError.value = e.toString();
    }
  }

  void clearError() {
    loginError.value = '';
  }
}
