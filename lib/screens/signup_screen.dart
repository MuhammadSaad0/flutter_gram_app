import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_gram/responsive/mobile_screen_layout.dart';
import 'package:flutter_gram/responsive/responsive_layout_screen.dart';
import 'package:flutter_gram/responsive/web_screen_layout.dart';
import 'package:flutter_gram/screens/login_screen.dart';
import 'package:neopop/neopop.dart';
import '../resources/auth_methods.dart';
import '../utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/text_field_input.dart';
import '../utils/colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _bioController = TextEditingController();
final TextEditingController _usernameController = TextEditingController();
bool isLoading = false;

class _SignUpScreenState extends State<SignUpScreen> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(
      ImageSource.gallery,
    );
    setState(() {
      _image = img;
    });
  }

  void signUpUser() async {
    if (_emailController.text == "" ||
        _passwordController.text == "" ||
        _usernameController.text == "" ||
        _bioController.text == "" ||
        _image == null) {
      showSnackbar(context, "One or more fields cannot be empty");
      return;
    }
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethod().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    if (res != 'Success') {
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

  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(
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
                height: 44,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage((_image!)),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://www.meme-arsenal.com/memes/b6a18f0ffd345b22cd219ef0e73ea5fe.jpg')),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: 'Enter username',
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 20,
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
              TextFieldInput(
                  textEditingController: _bioController,
                  hintText: 'Enter bio',
                  textInputType: TextInputType.text),
              const SizedBox(
                height: 20,
              ),
              NeoPopTiltedButton(
                isFloating: false,
                onTapUp: signUpUser,
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
                      : const Text('Sign Up'),
                ),
              ),
              // InkWell(
              //   onTap: signUpUser,
              //   child: Container(
              //     width: double.infinity,
              //     alignment: Alignment.center,
              //     decoration: const ShapeDecoration(
              //         color: blueColor,
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.all(Radius.circular(4)))),
              //     padding: const EdgeInsets.symmetric(vertical: 12),
              //     child: isLoading != true
              //         ? const Text('SignUp')
              //         : const Center(
              //             child: SizedBox(
              //                 height: 16,
              //                 width: 16,
              //                 child: CircularProgressIndicator(
              //                   color: Colors.white,
              //                 )),
              //           ),
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
                    child: const Text("Already have an account?"),
                  ),
                  InkWell(
                    onTap: navigateToLogin,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        child: const Text(
                          "Log In",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
