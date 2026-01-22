import 'dart:io';

import 'package:emilio_test/blocs/auth/auth_bloc.dart';
import 'package:emilio_test/blocs/auth/auth_state.dart';
import 'package:emilio_test/blocs/profile/profile_bloc.dart';
import 'package:emilio_test/blocs/profile/profile_event.dart';
import 'package:emilio_test/blocs/profile/profile_state.dart';
import 'package:emilio_test/core/utils/validators.dart';
import 'package:emilio_test/presentation/widgets/custom_button.dart';
import 'package:emilio_test/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _addressController = TextEditingController();
  String? _profilePhotoPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _shopNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Copy image to app directory
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage = await File(
          image.path,
        ).copy('${appDir.path}/$fileName');
        setState(() {
          _profilePhotoPath = savedImage.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _submitProfile() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        context.read<ProfileBloc>().add(
          CreateProfileEvent(
            sellerId: authState.user.id,
            shopName: _shopNameController.text.trim(),
            address: _addressController.text.trim(),
            profilePhotoPath: _profilePhotoPath,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.store, size: 80, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please complete your profile to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _profilePhotoPath != null
                            ? FileImage(File(_profilePhotoPath!))
                            : null,
                        child: _profilePhotoPath == null
                            ? const Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap to add profile photo (optional)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Shop Name *',
                    controller: _shopNameController,
                    validator: (value) =>
                        Validators.validateRequired(value, 'Shop name'),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Address *',
                    controller: _addressController,
                    validator: (value) =>
                        Validators.validateRequired(value, 'Address'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Complete Profile',
                    onPressed: _submitProfile,
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
