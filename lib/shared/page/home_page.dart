import 'package:flutter/material.dart';
import 'package:sqflite_project_db/page/add_data.dart';
import 'package:sqflite_project_db/page/emp_add_data.dart';
import 'package:sqflite_project_db/page/emp_show_data.dart';
import 'package:sqflite_project_db/page/show_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTitle("User"),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddDataPage()));
                    },
                    child: const Text("Add")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ShowDataPage()));
                    },
                    child: const Text("Show")),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTitle("Emp"),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EmpAddDataPage()));
                    },
                    child: const Text("Add")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EmpShowDataPage()));
                    },
                    child: const Text("Show")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(title) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("$title Data"),
      ),
    );
  }
}
