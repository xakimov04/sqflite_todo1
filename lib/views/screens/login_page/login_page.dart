import 'package:experensies/views/screens/home_page/task_list_view.dart';
import 'package:experensies/views/screens/login_page/create_account.dart';
import 'package:experensies/views/widgets/submit_button.dart';
import 'package:experensies/views/widgets/text_feild.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(50),
              Center(
                child: Image.asset(
                  "images/todo_logo.png",
                  fit: BoxFit.cover,
                  height: 100,
                  width: 300,
                ),
              ),
              const Gap(76),
              const Text(
                "Sign in",
                style: TextStyle(
                  color: Color(0xff471AA0),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(20),
              TextFieldWidget(
                controller: _emailController,
                image: "person",
                hintText: "Email or User Name",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter something';
                  }
                  return null;
                },
              ),
              const Gap(20),
              TextFieldWidget(
                obscureText: _obscureText,
                controller: _passwordController,
                suffixIcon: GestureDetector(
                  onTap: _togglePasswordVisibility,
                  child: Icon(
                    _obscureText
                        ? CupertinoIcons.eye
                        : CupertinoIcons.eye_slash,
                  ),
                ),
                image: 'password',
                hintText: 'Password',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter something';
                  }
                  if (value.length < 8) {
                    return "Parolda eng kamida 8 ta belgi bo'lsin";
                  }
                  return null;
                },
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Forget Password?",
                      style: TextStyle(
                        color: Color(0xff471AA0),
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(25),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SubmitButton(
                      text: 'Sign in',
                      onTap: _submitForm,
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateAccount(),
              ),
            );
          },
          child: Center(
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Don’t have an account? ",
                    style: TextStyle(
                      color: Color(0xff471AA0),
                    ),
                  ),
                  TextSpan(
                    text: "Sign Up",
                    style: TextStyle(
                      color: Color(0xff471AA0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
