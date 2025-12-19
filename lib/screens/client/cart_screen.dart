// lib/screens/client/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_uts/models/user_model.dart'; // Pastikan import User model

class CartScreen extends StatefulWidget {
  final User user; // Menerima objek User

  const CartScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Contoh data keranjang (akan diganti dengan data dinamis dari API di masa depan)
  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': 1,
      'name': 'Telur Gulung Original',
      'price': 2500,
      'quantity': 2,
      'image': 'https://via.placeholder.com/150/FFA500/FFFFFF?text=Telur1'
    },
    {
      'id': 2,
      'name': 'Telur Gulung Pedas',
      'price': 3000,
      'quantity': 1,
      'image': 'https://via.placeholder.com/150/FF6347/FFFFFF?text=Telur2'
    },
  ];

  double get _totalPrice {
    return _cartItems.fold(
        0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  void _removeItem(int id) {
    setState(() {
      _cartItems.removeWhere((item) => item['id'] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item dihapus dari keranjang!')),
    );
  }

  void _updateQuantity(int id, int newQuantity) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        _cartItems[index]['quantity'] = newQuantity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Anda'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'Keranjang Anda kosong!',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                width: 60,
                                height: 60,
                                color: Colors.orange[100],
                                child: Icon(Icons.egg_outlined,
                                    size: 30, color: Colors.orange),
                              ),
                            ),
                            title: Text(
                              item['name'],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rp ${item['price']}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[700]),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_circle_outline,
                                          color:
                                              Theme.of(context).primaryColor),
                                      onPressed: () {
                                        if (item['quantity'] > 1) {
                                          _updateQuantity(
                                              item['id'], item['quantity'] - 1);
                                        }
                                      },
                                    ),
                                    Text(
                                      '${item['quantity']}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add_circle_outline,
                                          color:
                                              Theme.of(context).primaryColor),
                                      onPressed: () {
                                        _updateQuantity(
                                            item['id'], item['quantity'] + 1);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeItem(item['id']),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, -3),
                      ),
                    ],
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Rp ${_totalPrice.toInt()}',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Logika checkout
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Proses Checkout untuk User ${widget.user.name}!')));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'Checkout',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
