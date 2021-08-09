
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/bloc_observer.dart';

import 'layout/home_layout.dart';


//reusable components
//1. timing
//2. refactor
//3. quality

void main()
{

  Bloc.observer = MyBlocObserver();


  runApp(MyApp());


}

//Widgets =>
//Stateless -> don't change over time
//Stateful ->change over time

class MyApp extends StatelessWidget
{

  //build (building the design and display all the graphic content)
  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      home: HomeLayout(),
      debugShowCheckedModeBanner: true,
    );
  }



}
