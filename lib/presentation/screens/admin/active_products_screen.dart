import 'package:emilio_test/blocs/product/product_bloc.dart';
import 'package:emilio_test/blocs/product/product_event.dart';
import 'package:emilio_test/blocs/product/product_state.dart';
import 'package:emilio_test/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveProductsScreen extends StatefulWidget {
  const ActiveProductsScreen({super.key});

  @override
  State<ActiveProductsScreen> createState() => _ActiveProductsScreenState();
}

class _ActiveProductsScreenState extends State<ActiveProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadActiveProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Active Products')),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(
                        LoadActiveProductsEvent(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ProductLoaded) {
            if (state.products.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text('No active products found'),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: state.products[index],
                  showActions: false,
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
