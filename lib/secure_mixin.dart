import 'package:flutter/material.dart';
import 'package:flutter_application_1/secure_screen_lock.dart';

mixin SecureScreenMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    activateSecureScreen();
  }

  @override
  void dispose() {
    deactivateSecureScreen();
    super.dispose();
  }
}