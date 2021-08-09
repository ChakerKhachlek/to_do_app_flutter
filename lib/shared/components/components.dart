import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';

Widget defaultButton({
  double width=double.infinity,
  Color background=Colors.blue,
  bool isUpperCase = true,
  double radius = 10.0,
  required VoidCallback function,
  required String text

}) => Container(
  width: width,
  height: 40.0,

  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
      color: background
  ),
  child: MaterialButton(
      onPressed: function,

      child: Text(
        isUpperCase ? text.toUpperCase() : text,
        style:  TextStyle(
          color: Colors.white,
        ),
      )
  ),
);

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function onSubmit(String value)?,
  VoidCallback? onTap,
  VoidCallback onChange(String value)?,
  required String? Function(String?)? validate,
  required String label,
  required IconData prefix,
  bool isPassword =false,
  IconData? suffix,
  VoidCallback? suffixPressed,
  bool isClickable=true,
  bool disableKeyboard=false,


}
)
=>TextFormField(
  showCursor: disableKeyboard,
  readOnly: disableKeyboard,
  obscureText: isPassword,
  controller: controller,
  keyboardType: type,
  enabled: isClickable,
  decoration: InputDecoration(

    labelText: label,
    suffixIcon: suffix != null ?
    IconButton(
        icon : Icon(suffix) ,
    onPressed:
    suffixPressed ,):null ,
    prefixIcon: Icon(
        prefix
    ),

    border: OutlineInputBorder(),
  ),
    validator: validate,
    onFieldSubmitted: onSubmit,
    onChanged: onChange ,
    onTap: onTap,
);

Widget buildTaskItem(Map task,context) =>Dismissible(
  key: UniqueKey(),
  onDismissed: (direction){
  AppCubit.get(context).delete(task['id']);
  },
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [



        CircleAvatar(

          radius : 40.0,

          child: Text(

            task['time'],

          ),

        ),

        SizedBox(width: 20.0,),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Text(

                task['title'],

                style: TextStyle(

                    fontSize: 18.0,

                    fontWeight: FontWeight.bold

                ),



              ),

              Text(

                task['date'],

                style: TextStyle(

                    color: Colors.grey

                ),



              )

            ],

          ),

        ),

        SizedBox(width: 20.0,),

              Conditional.single(

                  context: context,

                  conditionBuilder: (context) =>task['status'] =='done',

                  widgetBuilder: (context) =>

                      IconButton(

                          onPressed: (){

                            AppCubit.get(context).updateStatus(task['id'], "archive");

                          },

                          icon: Icon(Icons.archive,

                            color: Colors.black45,)),

                  fallbackBuilder: (context) =>

                      IconButton(  onPressed: (){

                    AppCubit.get(context).updateStatus(task['id'], "done");

                    },

                    icon: Icon(Icons.check_box,

                    color: Colors.green,)),

              ),

        Conditional.single(

          context: context,

          conditionBuilder: (context) =>task['status'] =='new',

          widgetBuilder: (context) =>

              IconButton(

                  onPressed: (){

                    AppCubit.get(context).updateStatus(task['id'], "archive");

                  },

                  icon: Icon(Icons.archive,

                    color: Colors.black45,)),

          fallbackBuilder: (context) => SizedBox(),

        ),








      ],

    ),

  ),
);


Widget tasksBuilder({
  required List<Map> tasks,
  String noTasksMessage='',

})=>
    tasks.length>0 ?  ListView.separated(
itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
separatorBuilder: (context, index) =>
Padding(
padding: const EdgeInsets.only(left: 20.0),
child: Container(
width: double.infinity,
height: 1,
color: Colors.grey[300],
),
),
itemCount: tasks.length) :
Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
Icons.menu,
size: 100.0,
color:Colors.grey
),
Text(
    noTasksMessage
)
],
),
);