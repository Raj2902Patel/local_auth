import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalAuthentication _auth = LocalAuthentication();

  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
      floatingActionButton: _authButton(),
    );
  }

  Widget _authButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (!_isAuthenticated) {
          final bool canAuthenticateWithBiometrics =
              await _auth.canCheckBiometrics;

          if (canAuthenticateWithBiometrics) {
            try {
              final bool didAuthenticate = await _auth.authenticate(
                localizedReason: "Please Authenticate To Show Account Balance!",
                options: const AuthenticationOptions(
                  biometricOnly: false,
                ),
              );
              setState(() {
                _isAuthenticated = didAuthenticate;
              });
            } catch (error) {
              print(error);
            }
          }
        } else {
          setState(() {
            _isAuthenticated = false;
          });
        }
      },
      child: (_isAuthenticated
          ? const Icon(Icons.lock)
          : const Icon(Icons.lock_open)),
    );
  }

  Widget _buildUI() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Account Balance",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_isAuthenticated)
            const Text(
              "₹ 14,508",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (!_isAuthenticated)
            const Text(
              "*****",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
