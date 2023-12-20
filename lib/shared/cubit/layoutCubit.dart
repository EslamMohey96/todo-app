import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/modules//archived/archived.dart';
import 'package:todo/modules//done/done.dart';
import 'package:todo/modules//tasks/tasks.dart';
import 'package:todo/shared/components/constants.dart';
import 'package:todo/shared/cubit/layoutStates.dart';
import 'package:sqflite/sqflite.dart';

// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
class myLayoutCubit extends Cubit<myLayoutStates> {
  myLayoutCubit() : super(layoutInitState());
  static myLayoutCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  late Database db;
  bool isBottomSheetShown = false;
  Icon fabIcon = Icon(Icons.edit);
  String taskStatus = "new";
  List<Widget> screens = [
    tasks(),
    done(),
    archived(),
  ];
  List<String> title = [
    "tasks",
    "done",
    "archived",
  ];
  void changeIndex(int index) {
    currentIndex = index;
    emit(layoutBottomNavBarState());
  }

  Future<String> getName() async {
    return "Hamza";
  }

  void createDB() {
    // sqfliteFfiInit();
    // databaseFactory = databaseFactoryFfi;
    print("0");
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print("db is created");
        db.execute('DROP TABLE IF EXISTS tasks');
        db
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print("DB is created");
        }).catchError((onError) {
          print('error is $onError on creating');
        });
      },
      onOpen: (db) {
        print("db is opened");
        getDataFromDB(db);
      },
    ).then((value) {
      db = value;
      emit(layoutCreateDBState());
    });
  }

  insertToDB({
    required String title,
    required String time,
    required String date,
  }) async {
    await db.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO tasks(title, date, time, status) VALUES ("${title}", "${date}", "${time}", "new")')
            .then((value) {
          emit(layoutInsertDBState());
          getDataFromDB(db);
        }).catchError((onError) {
          print("error is $onError on inserting");
        }));
  }

  void getDataFromDB(db) {
    tasksList.clear();
    doneList.clear();
    archivedList.clear();
    emit(layoutLaodingSheetState());
    db.rawQuery('SELECT * FROM tasks').then((value) {
      allList = value;
      print(allList);
      value.forEach((element) {
        print(element['id']);
        if (element['status'] == 'new') {
          tasksList.add(element);
        } else if (element['status'] == 'done') {
          doneList.add(element);
        } else if (element['status'] == 'archived') {
          archivedList.add(element);
        }
        print(element);
      });
      emit(layoutGetDBState());
    });
  }

  updateDB({required String status, required int id}) async {
    db.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getDataFromDB(db);
      emit(layoutUpdateDBState());
    });
  }

  deleteBD({required id}) {
    db.rawDelete(
      'DELETE FROM tasks  WHERE id = ?',
      [id],
    ).then((value) {
      getDataFromDB(db);
      emit(layoutUpdateDBState());
    });
  }

  void changeBottomSheetState({
    required bool isBottomSheet,
    required Icon icon,
  }) {
    isBottomSheetShown = isBottomSheet;
    fabIcon = icon;
    emit(layoutBottomSheetState());
  }
  // String changeStatusState({
  //   required String status,
  // }) {
  //   taskStatus = status;
  //   emit(taskStatusState());
  //   return taskStatus;
  // }
}
