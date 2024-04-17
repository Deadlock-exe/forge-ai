import 'package:flex_forge/constants/colors.dart';
import 'package:flex_forge/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsPage extends StatelessWidget {
  const UserDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightRed,
      appBar: AppBar(
        backgroundColor: lightRed,
        title: const Text('Tell us about You'),
      ),
      body: const UserDetailsForm(),
    );
  }
}

class UserDetailsForm extends StatefulWidget {
  const UserDetailsForm({super.key});

  @override
  State<UserDetailsForm> createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String gender = 'Male'; // Default gender selection

  Future<void> _saveUserDetails() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': nameController.text,
        'age': ageController.text,
        'gender': gender,
        'weight': weightController.text,
        'height': heightController.text,
      });
    } catch (e) {
      print('Error saving user details: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.settings,
            size: 200,
            color: darkText,
          ),
          const SizedBox(
            height: 30,
          ),
          TextField(
            style: TextStyle(
              fontSize: 20,
              color: darkText,
            ),
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              focusColor: darkText,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            style: TextStyle(
              fontSize: 20,
              color: darkText,
            ),
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Age',
              focusColor: darkText,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Gender:',
                style: TextStyle(
                  fontSize: 20,
                  color: darkText,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: darkText!),
                ),
                child: ToggleButtons(
                  isSelected: [gender == 'Male', gender == 'Female'],
                  borderRadius: BorderRadius.circular(20),
                  onPressed: (index) {
                    setState(() {
                      gender = index == 0 ? 'Male' : 'Female';
                    });
                  },
                  selectedColor: darkText,
                  selectedBorderColor: darkText,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: const Text('Male'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: const Text('Female'),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(
                    fontSize: 20,
                    color: darkText,
                  ),
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Weight (in KGs)',
                    focusColor: darkText,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextField(
                  style: TextStyle(
                    fontSize: 20,
                    color: darkText,
                  ),
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Height (in cm)',
                    focusColor: darkText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: darkText,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 40,
              ),
            ),
            onPressed: () {
              _saveUserDetails(); // Save user details
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainPage(),
                ),
              );
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: lightText,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
