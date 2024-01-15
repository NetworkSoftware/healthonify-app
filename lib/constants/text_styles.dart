import 'package:flutter/material.dart';

class AppLogoLogin extends StatelessWidget {
  const AppLogoLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: SizedBox(
        height: 120,
        width: double.infinity,
        child: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Image.asset('assets/logo/logo_dark.png')
            : Image.asset('assets/logo/logo.png'),
      ),
    );
  }
}

// var appLogoLogin = Padding(
//   padding: const EdgeInsets.only(top: 32),
//   child: SizedBox(
//     height: 120,
//     width: double.infinity,
//     child:MediaQuery.of(context).platformBrightness == Brightness.dark
//               ? Image.asset('assets/logo/logo.png')
//               : Image.asset('assets/logo/logo.png'),
//   ),
// );

class AppLogoSignUp extends StatelessWidget {
  const AppLogoSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: SizedBox(
        height: 120,
        width: double.infinity,
        child: MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Image.asset('assets/logo/logo_dark.png')
            : Image.asset('assets/logo/logo.png'),
      ),
    );
  }
}

// var appLogoSignUp = Padding(
//   padding: const EdgeInsets.only(top: 32),
//   child: SizedBox(
//     height: 120,
//     width: double.infinity,
//     child: Image.asset('assets/logo/logo.png'),
//   ),
// );
