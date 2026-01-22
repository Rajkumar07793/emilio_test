import 'package:emilio_test/blocs/seller/seller_bloc.dart';
import 'package:emilio_test/blocs/seller/seller_event.dart';
import 'package:emilio_test/blocs/seller/seller_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellerListScreen extends StatefulWidget {
  const SellerListScreen({super.key});

  @override
  State<SellerListScreen> createState() => _SellerListScreenState();
}

class _SellerListScreenState extends State<SellerListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SellerBloc>().add(LoadSellersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seller List')),
      body: BlocBuilder<SellerBloc, SellerState>(
        builder: (context, state) {
          if (state is SellerLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SellerError) {
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
                      context.read<SellerBloc>().add(LoadSellersEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is SellerLoaded) {
            if (state.sellers.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No sellers found'),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.sellers.length,
              itemBuilder: (context, index) {
                final seller = state.sellers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: seller.isActive
                          ? Colors.green
                          : Colors.red,
                      child: Icon(
                        seller.isActive ? Icons.person : Icons.person_off,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(seller.email),
                    subtitle: Text(
                      seller.isActive ? 'Active' : 'Deactivated',
                      style: TextStyle(
                        color: seller.isActive ? Colors.green : Colors.red,
                      ),
                    ),
                    trailing: seller.isActive
                        ? IconButton(
                            icon: const Icon(Icons.block, color: Colors.red),
                            onPressed: () {
                              _showDeactivateDialog(
                                context,
                                seller.id,
                                seller.email,
                              );
                            },
                          )
                        : null,
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _showDeactivateDialog(
    BuildContext context,
    String sellerId,
    String email,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Deactivate Seller'),
        content: Text('Are you sure you want to deactivate $email?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SellerBloc>().add(
                DeactivateSellerEvent(sellerId: sellerId),
              );
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Seller deactivated successfully'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text(
              'Deactivate',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
