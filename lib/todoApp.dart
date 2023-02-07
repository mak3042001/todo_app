import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/component/components.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/validate.dart';

class HomeScreen extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context,states){
          if(states is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (context,states)
        {
          AppCubit cubit = AppCubit.get(context);
          return  Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.cureentIndex],
                style: TextStyle
                  (
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: ConditionalBuilder
              (
              // condition: tasks.length > 0,
              condition: states is! AppGetDatabaseLoadingState,
              builder: (context) => Center(child: cubit.screen[cubit.cureentIndex]),
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed:()
              {
                if(cubit.isBottomShown){
                  if(formKey.currentState!.validate())
                  {
                    cubit.insertData(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                    titleController.text = '';
                    timeController.text= '';
                    dateController.text = '';
                  }
                }
                else {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) =>
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField
                                  (
                                    controller: titleController,
                                    type: TextInputType.text,
                                    validate: (value) => EmailValidator.validate(value),
                                    text: 'title',
                                    prefix: Icons.title
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                defaultFormField
                                  (
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    validate: (value) => EmailValidator.validate(value),
                                    onTap: ()
                                    {
                                      showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now()
                                      ).then(
                                              (value) {
                                            timeController.text = value!.format(context).toString();
                                          }
                                      );
                                    },
                                    text: 'time',
                                    prefix: Icons.watch_later_outlined
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                defaultFormField
                                  (
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  validate: (value) => EmailValidator.validate(value),
                                  onTap: ()
                                  {
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2100),
                                    ).then((value)
                                    {
                                      dateController.text = DateFormat.yMMMd().format(value!);
                                    }
                                    );
                                  },
                                  text: 'date',
                                  prefix: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ),
                    elevation: 20.0,
                  ).closed.then((value)
                  {
                    cubit.changeBottomSheet
                      (
                        isShown:false,
                        icon:Icons.edit
                    );
                    // isBottomShown = false;
                    // setState(() {
                    //   fabIcon = Icons.edit;
                    // });
                  });

                  cubit.changeBottomSheet
                    (
                      isShown:true,
                      icon:Icons.add,
                  );
                  // isBottomShown = true;
                  // setState(() {
                  //   fabIcon = Icons.add;
                  // });
                }
              },
              child:Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.cureentIndex,
              onTap: (index){
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'archive',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  // Future<String> getName() async
  // {
  //   return 'ahmed ali';
  // }


}



