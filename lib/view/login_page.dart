import 'package:flutter/material.dart';
import '../util/local_storage.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isObscure = true;
  bool _isError = false;

  void login() async {
    if (_username.text.trim() == "123220151" && _password.text == "12345678") {
      setState(() {
        _isError = false;
      });
      await LocalStorage.login(_username.text.trim());
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username atau password salah!")),
      );
      setState(() {
        _isError = true;
      });
    }
  }

  Widget redEye() {
    return InkWell(
      onTap: () {
        setState(() {
          _isObscure = !_isObscure;
        });
      },
      child: Icon(
        _isObscure
            ? Icons.remove_red_eye_outlined
            : Icons.visibility_off_outlined,
        color: _isError ? Colors.red.shade800 : Colors.grey.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("Silakan login untuk melanjutkan."),
              const SizedBox(height: 16),
              TextField(
                controller: _username,
                decoration: InputDecoration(
                  labelText: "Username",
                  errorText: _isError ? "Username atau password salah!" : null,
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: _isError ? "Username atau password salah!" : null,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: redEye(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: width,
                child: ElevatedButton(
                  onPressed: login,
                  child: const Text("Login"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
