import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';


//1.create database
//2.open database
//3.insert to database
//4.get from database
//5.update in database
//6.delete from database

class HomeLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) =>AppCubit()..createDatabase() ,
      child: BlocConsumer<AppCubit,AppStates>(
          listener: (BuildContext context, Object? state) {
            if(state is AppInsertDatabaseState){
              Navigator.pop(context);
            }

          },
        builder: (BuildContext context,AppStates state)
      {
        AppCubit cubit=AppCubit.get(context);
        return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title : Text(
            cubit.titles[cubit.currentIndex],
          ),
        ),
        body: state == AppGetDatabaseStateLoadingState() ? Center(child: CircularProgressIndicator()) :  cubit.screens[cubit.currentIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(cubit.isBottomSheetShown){
            if(formKey.currentState!.validate()){
        cubit.insertToDatabase(
                    title : titleController.text,
                    time: timeController.text,
                    date : dateController.text);
              }
            }else{

              scaffoldKey.currentState!.showBottomSheet((context) =>Container(
                color : Colors.white,

                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey ,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      defaultFormField(
                          controller: titleController,
                          type: TextInputType.text,
                          onTap: (){

                          },
                          validate: (String? value){
                            if(value!.isEmpty){
                              return 'title must not be empty';
                            }
                          },
                          label: 'Task title',
                          prefix: Icons.title),
                      SizedBox(height: 20.0),
                      defaultFormField(
                          controller: timeController,
                          disableKeyboard:true,
                          type: TextInputType.datetime,
                          onTap: (){

                            showTimePicker(builder:(context, childWidget) {
                              return MediaQuery(
                                  data: MediaQuery.of(context).copyWith(
                                    // Using 24-Hour format
                                      alwaysUse24HourFormat: false),
                                  // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
                                  child: childWidget!);
                            } ,
                                context: context,
                                initialTime: TimeOfDay.now()
                            ).then((value) {
                              if(value != null){
                                if(value.period ==DayPeriod.am){
                                  timeController.text=value.format(context) + " AM";
                                }else{
                                  timeController.text=value.format(context) + " PM";
                                }

                              }

                            }).catchError((error){
                              print('the Error is : ${error.toString()}');
                            });
                          },
                          validate: (String? value){
                            if(value!.isEmpty){
                              return 'time must not be empty';
                            }
                          },
                          label: 'Task time',
                          prefix: Icons.watch_later_outlined
                      ),
                      SizedBox(height: 20.0),
                      defaultFormField(
                          controller: dateController,
                          disableKeyboard:true,
                          type: TextInputType.datetime,
                          onTap: (){

                            showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.utc(DateTime.now().year,1,1),
                                lastDate: DateTime.utc(DateTime.now().year,12,31)
                            ).then((value) {
                              if(value != null) {
                                dateController.text =
                                    DateFormat.yMMMd().format(value);
                              }
                            });
                          },
                          validate: (String? value){
                            if(value!.isEmpty){
                              return 'date must not be empty';
                            }
                          },
                          label: 'Task date',
                          prefix: Icons.date_range_outlined)
                    ],
                  ),
                ),
              ),
                elevation: 20.0,).closed.then((value) {
                cubit.changeBottomSheetState(false,Icons.edit);

              });

              cubit.changeBottomSheetState(true,Icons.add);

            }
          },
          child: Icon(
              cubit.fabIcon
          ),

        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap:  (index){

              cubit.changeIndex(index);
            },
            items :[
              BottomNavigationBarItem(
                label: 'Tasks',
                icon: Icon(Icons.menu),
              ),

              BottomNavigationBarItem(
                  label: 'Done',
                  icon: Icon(Icons.check_circle_outline)),
              BottomNavigationBarItem(
                  label: 'Achieved',
                  icon: Icon(Icons.archive_outlined)),
            ]
        ),

      );}

      ),
    );

  }

  //Instance of 'Future <String>'
  Future<String> getName() async
  {
    return ' Chaker';
  }

  }


