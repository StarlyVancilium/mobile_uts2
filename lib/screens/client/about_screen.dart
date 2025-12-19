// // lib/screens/about_screen.dart

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart'; // Untuk membuka link eksternal

// class AboutScreen extends StatelessWidget {
//   const AboutScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tentang Aplikasi'),
//         backgroundColor: Theme.of(context).primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Column(
//                 children: [
//                   Icon(
//                     Icons.egg_outlined,
//                     size: 100,
//                     color: Theme.of(context).primaryColor,
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     'Toko Telur Gulung',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                   Text(
//                     'Versi 1.0.0',
//                     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   ),
//                   SizedBox(height: 24),
//                 ],
//               ),
//             ),
            
//             _buildSectionTitle('Tentang Kami'),
//             _buildInfoCard(
//               context,
//               children: [
//                 Text(
//                   'Aplikasi "Toko Telur Gulung" ini dibuat sebagai bagian dari Ujian Tengah Semester (UTS) mata kuliah Pemrograman Mobile di Institut Teknologi Nasional. Tujuan utama aplikasi ini adalah untuk menyediakan platform pemesanan telur gulung secara online, baik untuk pelanggan maupun untuk pengelolaan oleh admin.',
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//             SizedBox(height: 24),

//             _buildSectionTitle('Fitur Aplikasi'),
//             _buildInfoCard(
//               context,
//               children: [
//                 _buildFeaturePoint(context, Icons.person_add_alt_1, 'Registrasi & Login Pengguna'),
//                 _buildFeaturePoint(context, Icons.admin_panel_settings, 'Registrasi & Login Admin'),
//                 _buildFeaturePoint(context, Icons.approval, 'Persetujuan Akun Pengguna oleh Admin'),
//                 _buildFeaturePoint(context, Icons.local_dining, 'Daftar Produk Telur Gulung'),
//                 _buildFeaturePoint(context, Icons.shopping_cart, 'Keranjang Belanja'),
//                 _buildFeaturePoint(context, Icons.receipt_long, 'Riwayat Pesanan'),
//               ],
//             ),
//             SizedBox(height: 24),

//             _buildSectionTitle('Pengembang'),
//             _buildInfoCard(
//               context,
//               children: [
//                 Text(
//                   'Aplikasi ini dikembangkan oleh:',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   '- [Nama Mahasiswa 1]',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//                 Text(
//                   '- [Nama Mahasiswa 2]',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                 ),
//                 // Tambahkan nama anggota tim lain jika ada
//               ],
//             ),
//             SizedBox(height: 24),

//             _buildSectionTitle('Sumber & Lisensi'),
//             _buildInfoCard(
//               context,
//               children: [
//                 _buildLinkButton(context, 'Kode Sumber (GitHub)', 'https://github.com/your-repo-link'),
//                 _buildLinkButton(context, 'Lisensi Flutter', 'https://flutter.dev/license'),
//                 Text(
//                   'Ikon: Google Fonts Icons',
//                   style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                 ),
//               ],
//             ),
//             SizedBox(height: 40),

//             Center(
//               child: Text(
//                 '© 2024 Toko Telur Gulung - Institut Teknologi Nasional',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 12, color: Colors.grey[500]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: Theme.of(context).primaryColor,
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoCard(BuildContext context, {required List<Widget> children}) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: EdgeInsets.zero,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: children,
//         ),
//       ),
//     );
//   }

//   Widget _buildFeaturePoint(BuildContext context, IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: Theme.of(context).primaryColor, size: 20),
//           SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLinkButton(BuildContext context, String text, String url) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: TextButton.icon(
//         icon: Icon(Icons.link, size: 20, color: Theme.of(context).primaryColor),
//         label: Text(
//           text,
//           style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
//         ),
//         onPressed: () async {
//           if (await canLaunchUrl(Uri.parse(url))) {
//             await launchUrl(Uri.parse(url));
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Tidak dapat membuka link $url')),
//             );
//           }
//         },
//       ),
//     );
//   }
// }