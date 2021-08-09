import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';


class DoneTasksScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){

        },
        builder: (context,state) {
          AppCubit cubit=AppCubit.get(context);
          var doneTasks= cubit.doneTasks;
          return tasksBuilder(
            tasks: doneTasks,
            noTasksMessage: 'No done tasks yet'
          );
        }

    );
  }
}
