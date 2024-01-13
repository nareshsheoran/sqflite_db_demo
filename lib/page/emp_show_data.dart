// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_project_db/page/details_data.dart';
import 'package:sqflite_project_db/page/emp_details_data.dart';
import 'package:sqflite_project_db/provider/emp_provider.dart';
import 'package:sqflite_project_db/provider/user_provider.dart';

class EmpShowDataPage extends StatefulWidget {
  const EmpShowDataPage({super.key});

  @override
  State<EmpShowDataPage> createState() => _EmpShowDataPageState();
}

class _EmpShowDataPageState extends State<EmpShowDataPage> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  bool isLoading = false;

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<EmpUserProvider>(context, listen: false).initData();
      await Provider.of<EmpUserProvider>(context, listen: false).getUserData();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmpUserProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(title: const Text("Show Data"), centerTitle: true),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.userList.isEmpty
                  ? const Center(child: Text("No Data Found"))
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Card(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text("ID"), Text("Name")],
                            ),
                          )),
                          const SizedBox(height: 10),
                          Card(
                            child: ListView.separated(
                              itemCount: provider.userList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var item = provider.userList[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EmpDetailsData(
                                                        employeeModel: provider
                                                            .userList[index])))
                                        .then((value) async {
                                      await Provider.of<EmpUserProvider>(context,
                                              listen: false)
                                          .initData();
                                      await Provider.of<EmpUserProvider>(context,
                                              listen: false)
                                          .getUserData();
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${item.employeeId}"),
                                        Text(item.employeeName)
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const Divider();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
