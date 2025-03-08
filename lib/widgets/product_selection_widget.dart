import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class ProductSelectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        return ListView.builder(
          itemCount: transactionProvider.products.length,
          itemBuilder: (context, index) {
            final product = transactionProvider.products[index];
            final quantityController = TextEditingController();

            return ListTile(
              title: Text(product.name),
              subtitle: Text('Price: ${product.price.toStringAsFixed(2)} | Stock: ${product.stock}'),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Qty',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        final quantity = int.tryParse(quantityController.text) ?? 0;
                        if (quantity <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a valid quantity')),
                          );
                        } else {
                          final success = transactionProvider.addToCart(product, quantity);
                          if (success) {
                            quantityController.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Cannot add $quantity ${product.name}(s). Only ${product.stock} in stock.')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}