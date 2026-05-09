import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/repositories/habit_repository.dart';

class AuthCubit extends Cubit<User?> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final HabitRepository repository;

  AuthCubit(this.repository) : super(FirebaseAuth.instance.currentUser);

  Future<void> signInWithGoogle() async {
    try {
      // 1. Önce kimlik doğrulaması (Authentication) yapıyoruz
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();
      if (googleUser == null) return;

      // 2. KRİTİK NOKTA: accessToken almak için "authorizeScopes" çağırmalıyız
      // Bu işlem kullanıcıdan e-posta ve profil izni ister.
      final authorizedUser = await googleUser.authorizationClient
          .authorizeScopes(['email', 'profile']);

      // 3. Token'ları topluyoruz
      final String? idToken = (await googleUser.authentication).idToken;
      final String? accessToken =
          authorizedUser.accessToken; // Artık hata vermez!

      // 4. Firebase Credential oluşturuyoruz
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      // 5. Firebase'e giriş yapıyoruz
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      emit(userCredential.user);
    } catch (e) {
      print("Google Login Hatası: $e");
    }
  }

  Future<void> logOut() async {
    await repository.clearAllLocalDb();
    await _googleSignIn.signOut();
    await _auth.signOut();
    emit(null);
  }
}
