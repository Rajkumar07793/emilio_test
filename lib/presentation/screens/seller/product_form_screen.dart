import 'package:emilio_test/blocs/auth/auth_bloc.dart';
import 'package:emilio_test/blocs/auth/auth_state.dart';
import 'package:emilio_test/blocs/product/product_bloc.dart';
import 'package:emilio_test/blocs/product/product_event.dart';
import 'package:emilio_test/blocs/product/product_state.dart';
import 'package:emilio_test/core/utils/validators.dart';
import 'package:emilio_test/data/models/product_model.dart';
import 'package:emilio_test/presentation/widgets/custom_button.dart';
import 'package:emilio_test/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductModel? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.product!.title;
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock.toString();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        if (isEditing) {
          context.read<ProductBloc>().add(
            UpdateProductEvent(
              productId: widget.product!.id,
              title: _titleController.text.trim(),
              price: double.parse(_priceController.text),
              stock: int.parse(_stockController.text),
            ),
          );
        } else {
          context.read<ProductBloc>().add(
            CreateProductEvent(
              sellerId: authState.user.id,
              title: _titleController.text.trim(),
              price: double.parse(_priceController.text),
              stock: int.parse(_stockController.text),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Product' : 'Add Product')),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductOperationSuccess) {
            Navigator.pop(context);
          } else if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProductLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.add_box,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    label: 'Product Title *',
                    controller: _titleController,
                    validator: (value) =>
                        Validators.validateRequired(value, 'Title'),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Price *',
                    controller: _priceController,
                    validator: Validators.validatePrice,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Stock *',
                    controller: _stockController,
                    validator: Validators.validateStock,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: isEditing ? 'Update Product' : 'Add Product',
                    onPressed: _submitForm,
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
