import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/local/cash_helper.dart';
import 'package:todo_app/todo_App/ArchivedTasks/ArchivedTasks.dart';
import 'package:todo_app/todo_App/DoneTasks/DoneTasks.dart';
import 'package:todo_app/todo_App/NewTasks/NewTasks.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit() : super(AppInitialState());

  static AppCubit get (context) => BlocProvider.of(context);

  int cureentIndex=0;
  List<Widget> screen=[
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> titles=[
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex (int index)
  {
    cureentIndex = index;
    emit(AppChangeNavBottomState());
  }

  Database? database;
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivetasks = [];
  bool isBottomShown = false;
  IconData fabIcon = Icons.edit;

  void updateData
      ({
    required String status,
    required int id,
      }) async
  {
     await database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id]).then((value)
     {
       getDataFromDatabase(database);
       emit(AppUpdateDatabaseState());
     });
  }

  void deleteData
      ({
    required int id,
  }) async
  {
    await database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
    .then((value)
    {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void createDataBase()
  {
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database , version)
      {
        print('database created');
        database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then((value){
          print('table created');
        }).catchError((error)
        {
          print('error when create table ${error.toString()}');
        });
      },
      onOpen: (database)
      {
        getDataFromDatabase(database);
        print('database opened');
      },

    ).then((value)
     {
       database = value;
       emit(AppCreateDatabaseState());
     });
  }
  Future? insertData({
    required String title,
    required String time,
    required String date,}) async
  {
     await database!.transaction((txn) async {
      txn.rawInsert('INSERT INTO Tasks (title,date,time,status) values("$title","$date","$time","new")')
          .then((value)
      {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }).catchError((error)
      {
        print('$error error occur when insert data');
      });
      return null;
    });
  }
  Future <List<Map>> getDataFromDatabase(database) async
  {
    newtasks =[];
    donetasks =[];
    archivetasks =[];
    emit(AppGetDatabaseLoadingState());
    return await database.rawQuery('SELECT * FROM tasks').then((value)
    {
      value.forEach((element)
      {
        if(element['status'] == 'new')
          newtasks.add(element);
        else if(element['status'] == 'done')
          donetasks.add(element);
        else archivetasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void changeBottomSheet
      ({
    required bool isShown,
    required IconData icon,
  })
  {
    isBottomShown = isShown;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  bool isDark =false;
  void changeMode({bool? fromShared}){
    if(fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeState());
    }
    else{
      isDark = !isDark;
    CashHelper.putData(key: 'isDark', value: isDark).then((value) {
      emit(AppChangeModeState());
    });
    }
  }
}