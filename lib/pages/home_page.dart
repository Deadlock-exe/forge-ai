import 'package:flex_forge/constants/colors.dart';
import 'package:flex_forge/pages/user_details_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User? currentUser;
  late Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      currentUser = user;
    });
    fetchUserData();
  }

  void fetchUserData() async {
    if (currentUser != null) {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser!.uid)
              .get();
      setState(() {
        userData = snapshot.data()!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightRed,
      appBar: AppBar(
        backgroundColor: lightRed,
        title: Text(
          'Hello, ${userData['name']}!',
          style: const TextStyle(
            fontSize: 20,
            letterSpacing: 2,
          ),
        ),
        leading: IconButton(
          hoverColor: darkText,
          onPressed: () {
            setState(
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserDetailsPage(),
                  ),
                );
              },
            );
          },
          icon: const Icon(
            Icons.menu,
            size: 35,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: lightText,
                    height: 60,
                    child: Center(
                      child: Text(
                        "${userData['name']}",
                        style: const TextStyle(
                          fontSize: 25,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          color: lightText,
                          height: 60,
                          child: Center(
                            child: Text(
                              "Age: ${userData['age']}",
                              style: const TextStyle(
                                fontSize: 20,
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          color: lightText,
                          height: 60,
                          child: Center(
                            child: userData['gender'] == 'Female'
                                ? Icon(
                                    Icons.female,
                                    size: 35,
                                    color: darkText,
                                  )
                                : Icon(
                                    Icons.male,
                                    size: 35,
                                    color: darkText,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          color: lightText,
                          height: 180,
                          child: Center(
                            child: Text(
                              "${userData['weight']}Kg",
                              style: const TextStyle(
                                fontSize: 22,
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          color: lightText,
                          height: 180,
                          child: Center(
                            child: Text(
                              "${userData['height']}cm",
                              style: const TextStyle(
                                fontSize: 22,
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
