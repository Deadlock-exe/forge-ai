import 'package:flex_forge/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  Map<DateTime, int> heatmapData = {};

  @override
  void initState() {
    super.initState();
    _loadHeatmapData();
  }

  void _loadHeatmapData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('heatmap')
          .doc('data')
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final convertedData = data.map(
          (key, value) => MapEntry(DateTime.parse(key), value as int),
        );
        setState(() {
          heatmapData = convertedData;
        });
      }
    } catch (error) {
      print("Error loading heatmap data: $error");
    }
  }

  void _commit(DateTime selectedDate) {
    setState(() {
      heatmapData[selectedDate] = 100;
    });
    _saveHeatmapData();
  }

  void _saveHeatmapData() async {
    try {
      final convertedData = heatmapData.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      await FirebaseFirestore.instance
          .collection('heatmap')
          .doc('data')
          .set(convertedData);
    } catch (error) {
      print("Error saving heatmap data: $error");
    }
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(
        const Duration(days: 365),
      ),
      lastDate: now,
    );
    if (selectedDate != null) {
      _commit(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightRed,
      appBar: AppBar(
        backgroundColor: lightRed,
        title: const Text('Your Progress'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              HeatMapCalendar(
                size: 50,
                // startDate: DateTime.now().subtract(const Duration(days: 25)),
                // endDate: DateTime.now().add(const Duration(days: 50)),
                datasets: heatmapData,
                // scrollable: true,
                showColorTip: false,
                colorsets: {
                  7: darkRed,
                },
                onClick: (DateTime selectedDate) => _commit(selectedDate),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () => _showDatePicker(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightText,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 40,
                  ),
                ),
                child: Text(
                  'Commit',
                  style: TextStyle(color: darkText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
