import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';

class UserApprovalScreen extends StatefulWidget {
  @override
  _UserApprovalScreenState createState() => _UserApprovalScreenState();
}

class _UserApprovalScreenState extends State<UserApprovalScreen> {
  List<User> _pendingUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingUsers();
  }

  Future<void> _loadPendingUsers() async {
    final users = await ApiService.getPendingUsers();
    setState(() {
      _pendingUsers = users;
      _isLoading = false;
    });
  }

  Future<void> _approveUser(int userId) async {
    final result = await ApiService.approveUser(userId);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User berhasil disetujui')),
      );
      _loadPendingUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approval User'),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _pendingUsers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, size: 100, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Tidak ada user yang menunggu approval'),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadPendingUsers,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _pendingUsers.length,
                    itemBuilder: (context, index) {
                      final user = _pendingUsers[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    child: Text(user.name[0].toUpperCase()),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(user.npm ?? 'N/A',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text('Email: ${user.email}'),
                              if (user.noTelp != null)
                                Text('No. Telp: ${user.noTelp ?? 'N/A'}'),
                              if (user.alamat != null)
                                Text('Alamat: ${user.alamat}'),
                              SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () => _approveUser(user.id!),
                                  icon: Icon(Icons.check),
                                  label: Text('Setujui'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
