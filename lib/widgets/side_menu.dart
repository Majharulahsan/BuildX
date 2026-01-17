import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SideMenu extends StatefulWidget {
  final VoidCallback onLogout;

  const SideMenu({super.key, required this.onLogout});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String _userName = "User";
  String _userRole = "user";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fetch name and role from Firestore
  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists && mounted) {
          setState(() {
            _userName = doc.data()?['name'] ?? "User";
            _userRole = doc.data()?['role'] ?? "user";
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading user data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF141414),
      child: Column(
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Menu",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // User Profile Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: _userRole == 'admin' ? Colors.amber : const Color(0xFFE50914),
                        child: Icon(
                          _userRole == 'admin' ? Icons.admin_panel_settings : Icons.person, 
                          color: Colors.white, 
                          size: 30
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isLoading ? "Loading..." : _userName,
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _userRole == 'admin' ? "Administrator" : "Standard User",
                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Navigation Links
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                _buildMenuItem(Icons.person_outline, "My Profile"),
                
                // --- ADMIN ONLY SECTION ---
                if (_userRole == 'admin') ...[
                  const Padding(
                    padding: EdgeInsets.only(left: 16, top: 20, bottom: 10),
                    child: Text("ADMIN TOOLS", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  _buildMenuItem(Icons.add_box_outlined, "Add New Components", color: Colors.amber),
                  _buildMenuItem(Icons.analytics_outlined, "Sales Report", color: Colors.amber),
                  const Divider(color: Colors.white10),
                ],
                // ---------------------------

                _buildMenuItem(Icons.favorite_border, "Wishlist"),
                _buildMenuItem(Icons.notifications_none, "Notifications"),
                _buildMenuItem(Icons.settings_outlined, "Settings"),
                _buildMenuItem(Icons.help_outline, "Help & Support"),
              ],
            ),
          ),

          // Logout Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onLogout();
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text("Logout", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50914),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {Color color = Colors.white70}) {
    return ListTile(
      leading: Icon(icon, color: color, size: 28),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
      onTap: () {
        // Navigation logic for Admin or User screens goes here
      },
    );
  }
}