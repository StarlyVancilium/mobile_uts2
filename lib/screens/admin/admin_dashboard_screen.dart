import 'package:flutter/material.dart';
import '../../models/admin_model.dart';
import '../../services/api_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  final Admin admin;
  
  AdminDashboardScreen({required this.admin});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await ApiService.getDashboardStats();
    setState(() {
      _stats = stats['data'] ?? {};
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Admin'),
        backgroundColor: Colors.blue,
      ),
      drawer: _buildDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStats,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang, ${widget.admin.nama}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 24),
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildStatCard(
                          'Total Pesanan',
                          _stats['total_pesanan']?.toString() ?? '0',
                          Icons.shopping_bag,
                          Colors.blue,
                        ),
                        _buildStatCard(
                          'Pesanan Pending',
                          _stats['pesanan_pending']?.toString() ?? '0',
                          Icons.pending_actions,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          'Total Produk',
                          _stats['total_produk']?.toString() ?? '0',
                          Icons.inventory,
                          Colors.green,
                        ),
                        _buildStatCard(
                          'User Pending',
                          _stats['user_pending']?.toString() ?? '0',
                          Icons.person_add,
                          Colors.purple,
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Pendapatan',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Rp ${(_stats['total_pendapatan'] ?? 0).toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
            ),
            SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.admin.nama),
            accountEmail: Text(widget.admin.email),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.admin_panel_settings, size: 40),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('Approval User'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/users', arguments: widget.admin);
            },
          ),
          ListTile(
            leading: Icon(Icons.inventory),
            title: Text('Kelola Produk'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/products', arguments: widget.admin);
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Kelola Pesanan'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/orders', arguments: widget.admin);
            },
          ),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text('Laporan'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin/reports', arguments: widget.admin);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => Navigator.pushReplacementNamed(context, '/admin/login'),
          ),
        ],
      ),
    );
  }
}