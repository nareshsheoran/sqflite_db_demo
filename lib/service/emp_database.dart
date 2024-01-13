// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_project_db/shared/model/emp_user_model.dart';

class EmpDatabaseHelper {
  static String tableName = "employees";

  static final EmpDatabaseHelper _instance = EmpDatabaseHelper._internal();

  factory EmpDatabaseHelper() => _instance;

  static Database? _database;

  EmpDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'employee_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        createTable(db);
      },
    );
  }

  Future createTable(Database db) async {
    await db.transaction((Transaction transaction) async {
      transaction.execute('''
          CREATE TABLE $tableName (
          employeeId INTEGER PRIMARY KEY AUTOINCREMENT,
          employeeName TEXT NOT NULL,
          employeeAge INTEGER NOT NULL,
          employeePosition TEXT NOT NULL,
          employeeSalary REAL NOT NULL,
          employeeDepartment TEXT NOT NULL,
          employeeEmail TEXT NOT NULL,
          employeeHireDate TEXT NOT NULL,
          employeePhoneNumber TEXT NOT NULL,
          isEmployeeOnVacation INTEGER NOT NULL,
          employeeEmergencyContact TEXT,
          employeeAddress TEXT
      )
      ''');
    });
    print("table created");
  }

  Future<int> insertEmployee(EmployeeModel employee) async {
    final db = await database;
    return await db.insert(tableName, {
      'employeeName': employee.employeeName,
      'employeeAge': employee.employeeAge,
      'employeePosition': employee.employeePosition,
      'employeeSalary': employee.employeeSalary,
      'employeeDepartment': employee.employeeDepartment,
      'employeeEmail': employee.employeeEmail,
      'employeeHireDate': employee.employeeHireDate.toIso8601String(),
      'employeePhoneNumber': employee.employeePhoneNumber,
      'isEmployeeOnVacation': employee.isEmployeeOnVacation,
      'employeeEmergencyContact':
          jsonEncode(employee.employeeEmergencyContact.toJson()),
      'employeeAddress': jsonEncode(employee.employeeAddress.toJson()),
    });
  }

  Future<List<EmployeeModel>> getAllEmployees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return EmployeeModel(
        employeeId: maps[i]['employeeId'],
        employeeName: maps[i]['employeeName'],
        employeeAge: maps[i]['employeeAge'],
        employeePosition: maps[i]['employeePosition'],
        employeeSalary: maps[i]['employeeSalary'],
        employeeDepartment: maps[i]['employeeDepartment'],
        employeeEmail: maps[i]['employeeEmail'],
        employeeHireDate: DateTime.parse(maps[i]['employeeHireDate']),
        employeePhoneNumber: maps[i]['employeePhoneNumber'],
        isEmployeeOnVacation: maps[i]['isEmployeeOnVacation'],
        employeeEmergencyContact: EmergencyContact.fromJson(
            jsonDecode(maps[i]['employeeEmergencyContact'])),
        employeeAddress:
            Address.fromJson(jsonDecode(maps[i]['employeeAddress'])),
      );
    });
  }

  Future updateData(EmployeeModel employeeModel) async {
    try {
      final db = await database;
      await db.transaction(
        (txn) async {
          List<Map<String, dynamic>> result = await txn.rawQuery(
            'SELECT * FROM $tableName WHERE employeeId = ?',
            [employeeModel.employeeId],
          );
          if (result.isNotEmpty) {
            await txn.rawUpdate(
              'UPDATE $tableName SET employeeName = ?, employeeEmail = ?, employeeAge = ?, employeePhoneNumber = ?, employeeSalary = ?, isEmployeeOnVacation = ?, employeeHireDate = ?, employeePosition = ?, employeeEmergencyContact = ?, employeeAddress = ? WHERE employeeId = ?',
              [
                employeeModel.employeeName,
                employeeModel.employeeEmail,
                employeeModel.employeeAge,
                employeeModel.employeePhoneNumber,
                employeeModel.employeeSalary,
                employeeModel.isEmployeeOnVacation,
                employeeModel.employeeHireDate.toIso8601String(),
                employeeModel.employeePosition,
                jsonEncode(employeeModel.employeeEmergencyContact.toJson()),
                jsonEncode(employeeModel.employeeAddress.toJson()),
                employeeModel.employeeId,
              ],
            );
            print("data updated");
          }
        },
        exclusive: true,
      );

      return true;
    } catch (e) {
      print("data updated error:::::$e");
    }
  }

  Future<void> deleteData(int userId) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.rawDelete('DELETE FROM $tableName WHERE employeeId = ?', [userId]);
    });
  }

  Future closeDb() async {
    final db = await database;
    db.close();
  }
}
