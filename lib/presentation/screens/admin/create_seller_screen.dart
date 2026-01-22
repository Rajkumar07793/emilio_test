import 'package:emilio_test/blocs/seller/seller_bloc.dart';
import 'package:emilio_test/blocs/seller/seller_event.dart';
import 'package:emilio_test/blocs/seller/seller_state.dart';
import 'package:emilio_test/core/utils/validators.dart';
import 'package:emilio_test/presentation/widgets/custom_button.dart';
import 'package:emilio_test/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateSellerScreen extends StatefulWidget {
  const CreateSellerScreen({super.key});

  @override
  State<CreateSellerScreen> createState() => _CreateSellerScreenState();
}

class _CreateSellerScreenState extends State<CreateSellerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _createSeller() {
    if (_formKey.currentState!.validate()) {
      context.read<SellerBloc>().add(
        CreateSellerEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Seller')),
      body: BlocConsumer<SellerBloc, SellerState>(
        listener: (context, state) {
          if (state is SellerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is SellerCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Seller created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            _emailController.clear();
            _passwordController.clear();
          }
        },
        builder: (context, state) {
          final isLoading = state is SellerLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.person_add, size: 80, color: Colors.blue),
                  const SizedBox(height: 32),
                  const Text(
                    'Create New Seller Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    label: 'Email',
                    controller: _emailController,
                    validator: Validators.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Temporary Password',
                    controller: _passwordController,
                    validator: Validators.validatePassword,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Create Seller',
                    onPressed: _createSeller,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
