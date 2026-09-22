String mapFirebaseAuthExceptionCode(String errorCode) {
  switch (errorCode) {
    case 'wrong-password':
      return 'The password is invalid or the account does not have a password set.';
    case 'invalid-email':
      return 'The email address is not valid.';
    case 'user-disabled':
      return 'The user corresponding to the given email has been disabled.';
    case 'user-not-found':
      return 'No user corresponding to the given email was found.';
    case 'email-already-in-use':
      return 'An account already exists with the given email address.';
    case 'operation-not-allowed':
      return 'Email/password accounts are not enabled. Enable them in the Firebase Console.';
    case 'weak-password':
      return 'The password provided is not strong enough.';
    case 'account-exists-with-different-credential':
      return 'An account already exists with the email address provided. Sign in using one of the returned providers.';
    case 'invalid-credential':
      return 'The credential is malformed or has expired.';
    case 'invalid-verification-code':
      return 'The verification code is not valid.';
    case 'invalid-verification-id':
      return 'The verification ID is not valid.';
    case 'user-mismatch':
      return 'The credential given does not correspond to the user.';
    case 'expired-action-code':
      return 'The OTP in the email link has expired.';
    case 'network-request-failed':
      return 'Network error. Please check your connection and try again.';
    case 'too-many-requests':
      return 'Too many requests. Please wait a moment and try again.';
    case 'internal-error':
      return 'Firebase encountered an internal error. Please try again later.';
    case 'invalid-password':
      return 'The password is invalid or too weak.';
    case 'requires-recent-login':
      return 'This action requires a recent sign in. Please sign in again.';
    case 'email-not-verified':
      return 'Please verify your email before continuing.';
    default:
      return 'An unknown error occurred.';
  }
}
