import 'package:flutter/widgets.dart';
import 'package:quiver/core.dart';

enum SignInOption { standard, games }

@immutable
class SignInInitParameters {
  const SignInInitParameters({
    this.scopes = const <String>[],
    this.signInOption = SignInOption.standard,
    this.hostedDomain,
    this.clientId,
    this.serverClientId,
    this.forceCodeForRefreshToken = false,
  });
  final List<String> scopes;
  final SignInOption signInOption;
  final String? hostedDomain;
  final String? clientId;
  final String? serverClientId;
  final bool forceCodeForRefreshToken;
}

class GoogleSignInUserData {
  GoogleSignInUserData({
    required this.email,
    required this.id,
    this.displayName,
    this.photoUrl,
    this.idToken,
    this.serverAuthCode,
  });
  String? displayName;
  String email;
  String id;
  String? photoUrl;
  String? idToken;
  String? serverAuthCode;

  @override
  int get hashCode => hashObjects(
      <String?>[displayName, email, id, photoUrl, idToken, serverAuthCode]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! GoogleSignInUserData) {
      return false;
    }
    final GoogleSignInUserData otherUserData = other;
    return otherUserData.displayName == displayName &&
        otherUserData.email == email &&
        otherUserData.id == id &&
        otherUserData.photoUrl == photoUrl &&
        otherUserData.idToken == idToken &&
        otherUserData.serverAuthCode == serverAuthCode;
  }
}

class GoogleSignInTokenData {
  GoogleSignInTokenData({
    this.idToken,
    this.accessToken,
    this.serverAuthCode,
  });

  String? idToken;

  String? accessToken;

  String? serverAuthCode;

  @override
  int get hashCode => hash3(idToken, accessToken, serverAuthCode);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! GoogleSignInTokenData) {
      return false;
    }
    final GoogleSignInTokenData otherTokenData = other;
    return otherTokenData.idToken == idToken &&
        otherTokenData.accessToken == accessToken &&
        otherTokenData.serverAuthCode == serverAuthCode;
  }
}
