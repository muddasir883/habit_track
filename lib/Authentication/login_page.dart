import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/login_controller.dart';
import '../Screens/forgot_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController controller = Get.put(LoginController());
  bool _rememberMe = false;
  bool obsecure_text = true;

  @override
  void initState() {
    super.initState();
    // Load saved credentials if any
    setState(() {
      _rememberMe = controller.storage.read('rememberMe') ?? false;
      if (_rememberMe) {
        controller.email.value = controller.storage.read('email') ?? '';
        controller.password.value = controller.storage.read('password') ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffe2e5ee),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(18, 40, 20, 20),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      "Welcome back!",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Enter your Credentials",
                    style: TextStyle(color: Colors.black, fontSize: 13),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/lock.png'),
                        fit: BoxFit.cover

                      )
                    ),
                    height: 130,
                    width: 450,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xffe7e7e7),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      initialValue: controller.email.value,
                      onChanged: (value) => controller.email.value = value,
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      ),
                    ),
                  ),
                  Obx(() {
                    return controller.emailError.value.isNotEmpty
                        ? Text(
                      controller.emailError.value,
                      style: const TextStyle(color: Colors.red),
                    )
                        : Container();
                  }),
                  const SizedBox(height: 20),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xffe7e7e7),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      initialValue: controller.password.value,
                      obscureText: true,
                      onChanged: (value) => controller.password.value = value,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),

                      ),
                    ),
                  ),
                  Obx(() {
                    return controller.passwordError.value.isNotEmpty
                        ? Text(
                      controller.passwordError.value,
                      style: const TextStyle(color: Colors.red),
                    )
                        : Container();
                  }),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Checkbox(
                          value: _rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              _rememberMe = value ?? false;
                              controller.storage.write('rememberMe', _rememberMe);
                            });
                          }),
                      const Text(
                        "Remember me!",
                        style: TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Get.to(() => ForgotPasswordScreen());
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Color(0xff384cff), fontSize: 12),
                          ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    return controller.loading.value
                        ? const CircularProgressIndicator()
                        : Container(
                      width: 310,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade800.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          controller.validateFields();
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff384cff),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "or",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.signInWithGoogle().then((userCredential) {
                            // Handle successful login
                          }).catchError((error) {
                            // Handle error
                            Get.snackbar('Google Sign-In Failed', error.toString(),
                                snackPosition: SnackPosition.BOTTOM);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: const Color(0xffe2e5ee),
                            child: Image.asset('images/google.png', height: 50, width: 50),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: const Color(0xffe2e5ee),
                            child: Image.asset('images/fb.png', height: 30, width: 50),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Get.offNamed('/signup');
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          " Register Here",
                          style: TextStyle(color: Color(0xff384cff)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
