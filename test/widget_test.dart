// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';

import 'package:zodiona/features/auth/presentation/auth_screen.dart';
import 'package:zodiona/models/app_user.dart';
import 'package:zodiona/services/auth_service.dart';

void main() {
  testWidgets('Auth screen renders primary actions', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: AuthScreen(authService: _StubAuthService())),
    );

    expect(find.text('Giris Yap'), findsAtLeastNWidgets(1));
    expect(find.text('Google'), findsOneWidget);
    expect(find.text('Apple (yakinda)'), findsOneWidget);
  });
}

class _StubAuthService implements AuthService {
  @override
  Future<AppUser?> get currentUser async => null;

  @override
  Stream<AppUser?> get userChanges => const Stream.empty();

  @override
  Future<void> sendPasswordReset({required String email}) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    throw UnimplementedError();
  }

  @override
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
    required DateTime birthDate,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> saveOnboardingData({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    throw UnimplementedError();
  }
}
