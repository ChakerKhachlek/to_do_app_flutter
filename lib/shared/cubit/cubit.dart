import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archived_tasks/archived_tasks.dart';
import 'package:to_do_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do_app/shared/cubit/states.dart';


class AppCubit extends Cubit<AppStates>{

  int currentIndex = 0;
  late Database database;

  bool isBottomSheetShown = false;
  IconData fabIcon=Icons.edit;

  List<String> titles=[
    'New tasks',
    'Done tasks',
    'Archived tasks',
  ];

  List<Widget> screens=[
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];



  AppCubit(): super(AppInitialState());
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];

  static AppCubit get(context){ return BlocProvider.of(context);}

  void changeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNavBarState());
  }


  void createDatabase()
  {
    openDatabase(
        'todo.db',
        version: 1, // when modifying db structure change the version
        onCreate: (database, version)
        {
          print('Database created');
          database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT,date TEXT,time TEXT,status TEXT)').then((value) {
            print('Table created');
          }).catchError((error){
            print('Error while creating the database');
          });
        },
        onOpen: (database)
        {
          print('database opened');
          getDataFromDatabase(database);

        }
    ).then((value) {
      database=value;
    }) ;

    emit(AppCreateDatabaseState());
  }

  Future insertToDatabase({
    required String title,
    required String time,
    required String date}) async{
    await database.transaction((txn) async
    {
      txn.rawInsert('INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")').then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);

      }).catchError((error){
        print('Error when inserting new record ${error.toString()}');
      });
      return null;
    });



  }


  void getDataFromDatabase(database) {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];

    emit(AppGetDatabaseStateLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element) {
        if(element['status'] == "new"){
          newTasks.add(element);
        }else if (element['status'] == "done"){
          doneTasks.add(element);
        }else{
          archivedTasks.add(element);
        }
        print(element['status']);
      });
      emit(AppGetDatabaseState());
    });
  }

  void changeBottomSheetState(bool isShow,IconData icon){
    isBottomSheetShown=isShow;
    fabIcon=icon;
    emit(AppChangeAppChangeBottomSheetState());
  }

  void updateStatus (
      int id,
      String status,
      ) async {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', '$id']
    ).then((value) {

      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
      print('Updated');

    });
  }

  Future<void> delete(int id) async {
   await database.rawDelete('DELETE FROM tasks where id = ?',['$id']).then((value) {
     print('task $id deleted');
     emit(AppDeleteDatabase());
     getDataFromDatabase(database);
      emit(AppGetDatabaseState());
   });
  }
}