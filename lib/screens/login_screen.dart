import 'package:flutter/material.dart';
import 'package:flutter_gram/resources/auth_methods.dart';
import 'package:flutter_gram/responsive/mobile_screen_layout.dart';
import 'package:flutter_gram/responsive/responsive_layout_screen.dart';
import 'package:flutter_gram/responsive/web_screen_layout.dart';
import 'package:flutter_gram/screens/signup_screen.dart';
import 'package:flutter_gram/utils/global_variables.dart';
import 'package:flutter_gram/utils/utils.dart';
import 'package:neopop/neopop.dart';
import '../widgets/text_field_input.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethod().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res != "Success") {
      showSnackbar(context, res);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())));
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > WebScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(
                  horizontal: 32,
                ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container()),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Enter email',
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Enter password',
                textInputType: TextInputType.text,
                isPassword: true,
              ),
              const SizedBox(
                height: 20,
              ),
              NeoPopTiltedButton(
                isFloating: false,
                onTapUp: loginUser,
                decoration: const NeoPopTiltedButtonDecoration(
                  color: Color.fromARGB(255, 52, 133, 255),
                  plunkColor: Color.fromARGB(255, 52, 113, 255),
                  shadowColor: Color.fromRGBO(36, 36, 36, 1),
                  showShimmer: true,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50.0,
                    vertical: 15,
                  ),
                  child: isLoading == true
                      ? const SizedBox(
                          height: 16,
                          width: 34,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text('Login'),
                ),
              ),
              // InkWell(
              //   onTap: loginUser,
              //   child: Container(
              //     width: double.infinity,
              //     alignment: Alignment.center,
              //     decoration: const ShapeDecoration(
              //         color: blueColor,
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.all(Radius.circular(4)))),
              //     padding: const EdgeInsets.symmetric(vertical: 12),
              //     child: isLoading == true
              //         ? const Center(
              //             child: SizedBox(
              //               width: 16,
              //               height: 16,
              //               child: CircularProgressIndicator(
              //                 color: Colors.white,
              //               ),
              //             ),
              //           )
              //         : const Text('Login'),
              //   ),
              // ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Don't have an account?"),
                  ),
                  InkWell(
                    onTap: navigateToSignUp,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
