import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/component/components.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';

class NewTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     // return Container();
    return BlocConsumer<AppCubit,AppStates>(
      listener:(context,states){},
      builder: (context,states)
      {
        var tasks = AppCubit.get(context).newtasks;
        return builderTasks(
          tasks: tasks,
        );
      },
    );
  }
}