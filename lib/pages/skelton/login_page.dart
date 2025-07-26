import 'package:fscore/providers/user_provider.dart';
import 'package:fscore/widget/form/elevated_button_widget.dart';
import 'package:fscore/widget/form/text_field_widget.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool obscureText = true;
  bool remember = false;

  void setIsloading(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  Future<bool> _login() async {
    setIsloading(true);
    final bool login = await context.read<UserProvider>().connectUser(
        emailController.text.trim(), passwordController.text.trim(), remember);
    setIsloading(false);
    return login;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  TextFieldWidget(
                      textEditingController: emailController,
                      hintText: 'Entrer votre email'),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                      obscureText: obscureText,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                          icon: Icon(!obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          color: obscureText ? null : Colors.blue),
                      textEditingController: passwordController,
                      hintText: 'Entrer votre mot de pass'),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.blue,
                        activeColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.blue, width: 1)),
                        overlayColor: WidgetStatePropertyAll(Colors.blue),
                        value: remember,
                        onChanged: (value) => setState(() {
                          remember = !remember;
                        }),
                      ),
                      Text(
                        'Se souvenir de moi',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ElevatedButtonWidget(
                        label: 'Se Connecter',
                        onPressed: isLoading
                            ? null
                            : () async {
                                final bool login = await _login();
                                if (login) {
                                  Navigator.pop(context);
                                  return;
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Utilisateur inconnu !'),
                                    duration:
                                        const Duration(milliseconds: 1000),
                                  ),
                                );
                              },
                      ),
                      if (isLoading)
                        CircularProgressIndicator(color: Colors.blue),
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
