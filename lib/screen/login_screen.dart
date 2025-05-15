import 'package:application_medicines/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ever(authController.loginError, (String error) {
      if (error.isNotEmpty) {
        Get.snackbar(
          'Error',
          error,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        authController.clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa el correo electrónico';
                  }
                  // Validación simple formato email
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                    return 'Ingresa un correo válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa la contraseña';
                  }
                  if (value.trim().length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await authController.login(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                  }
                },
                child: const Text('Iniciar Sesión'),
              ),
              TextButton(
                onPressed: () => Get.toNamed('/register'),
                child: const Text('¿No tienes cuenta? Regístrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
