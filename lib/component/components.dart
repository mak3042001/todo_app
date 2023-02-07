import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/cubit/cubit.dart';
var tasks1;
Widget defaultButton({
  double width = double.infinity,
  double height = 50,
  Color background = Colors.blue,
  bool isUpperCase=true,
  double radius=0.0,
  required VoidCallback function,
  required String text,
}) =>Container(
  height: height,
  width: width,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: background,
  ),
  child: MaterialButton(
    onPressed:function,
    child: Text(isUpperCase ? text.toUpperCase(): text),
  ),
);

Widget defaultAppBar({
  required BuildContext context,
  String? title,
  List <Widget>? actions,
}) => AppBar(
  leading: IconButton(
    onPressed: (){
      Navigator.pop(context);
    },
    icon: Icon(Icons.arrow_back_ios),
  ),
  titleSpacing: 5.0,
  title: Text(title!),
  actions: actions,
);

Widget defaultTextButton({
  required VoidCallback function,
  required String text,
  var textStyle,
}) => TextButton(onPressed: function, child: Text(text.toUpperCase(),style: textStyle,));
Widget defaultFormField ({
  required TextEditingController controller,
  required TextInputType type,
  required FormFieldValidator validate,
  required String text,
  required IconData prefix,
  IconData? suffix,
  ValueChanged? onChange,
  GestureTapCallback? onTap,
  ValueChanged? onSubmit,
  bool isPassword = false,
  VoidCallback? suffixpressed,
}) =>TextFormField (
controller: controller,
onChanged:onChange,
onFieldSubmitted:onSubmit,
onTap: onTap,
keyboardType:type,
obscureText: isPassword,
validator: validate,
decoration: InputDecoration
(
labelText: text,
prefixIcon: Icon(prefix),
suffixIcon:suffix != null ? IconButton(
  onPressed: suffixpressed,
    icon: Icon(suffix)):null,
border: OutlineInputBorder(),
),
);

 Widget buildTaskItem (Map model , context) => Dismissible(
   key: Key(model['id'].toString()),
   child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
      children: [
      CircleAvatar(
      radius: 40.0,
      child: Text(
      '${model['time']}',
      style: TextStyle
      (
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      ),
      ),
      ),
      SizedBox(
      width: 20.0,
      ),
      Expanded(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
        Text
        (
          '${model['title']}',
        style: TextStyle
        (
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        ),
        ),
        SizedBox
        (
        height: 5.0,
        ),
        Text
        (
          '${model['date']}',
        style: TextStyle
        (
        // fontSize: 14.0,
        color: Colors.grey,
        ),
        ),
        ],
        ),
      ),
        SizedBox(
          width: 20.0,
        ),
        if(tasks1 != AppCubit.get(context).donetasks)
          IconButton(
            icon: Icon(Icons.check_box,
            color: Colors.green,),
            onPressed: ()
            {
              AppCubit.get(context).updateData(
                  status: 'done', id: model['id']);
            }),
        if(tasks1 != AppCubit.get(context).archivetasks)
          IconButton(
            icon: Icon(Icons.archive,
                color: Colors.black45),
            onPressed: ()
            {
              AppCubit.get(context).updateData(
                  status: 'archive', id: model['id']);
            }),
        if(tasks1 != AppCubit.get(context).newtasks)
          IconButton(
            icon: Icon(Icons.menu,
                color: Colors.blue),
            onPressed: ()
            {
              AppCubit.get(context).updateData(
                  status: 'new', id: model['id']);
            }),
      ],
      ),
      ),
   onDismissed: (direction)
   {
     AppCubit.get(context).deleteData(id: model['id']);
   },
 );

 Widget builderTasks ({required List<Map> tasks}) {
   tasks1 = tasks;
   return ConditionalBuilder(
   condition: tasks.length > 0,
   builder: (context) => ListView.separated(
       itemBuilder: (context,index) => buildTaskItem (tasks[index],context),
       separatorBuilder: (context,index) => mydivider(),
       itemCount: tasks.length),
   fallback: (context) => Center(
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children:
       [
         Icon(Icons.menu,
           size: 100.0,
           color: Colors.grey,),
         SizedBox(
           height: 10.0,
         ),
         Text('No Tasks yet, please add some tasks',
           style: TextStyle(fontSize: 16,
             fontWeight: FontWeight.bold,
             color: Colors.grey,),),
       ],
     ),
   ),
 );
 }

 Widget mydivider() => Padding(
    padding: const EdgeInsetsDirectional.only(
      start: 20.0,
    ),
    child: Container
      (
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[300],
    ),
  );

 void navigatorTo(context, widget ) => Navigator.push(
   context,
   MaterialPageRoute(
       builder: (context) => widget
   ),
 );

 void navigatorAndFinish(context,widget) => Navigator.pushAndRemoveUntil(context,
     MaterialPageRoute(
         builder: (context) => widget
     ),
         (route) => false);

 void showToast({
  required String text,
   required toastState state,
}){
   Fluttertoast.showToast(
     msg: text,
     toastLength: Toast.LENGTH_LONG,
     gravity: ToastGravity.BOTTOM,
     timeInSecForIosWeb: 5,
     backgroundColor: chooseToastColor(state),
     textColor: Colors.white,
     fontSize: 16.0,
   );
 }

 enum toastState{SUCCESS,ERROR,WARNING}

Color chooseToastColor(toastState state){
   Color color;
   switch(state){
     case toastState.SUCCESS:
       color = Colors.green;
       break;
     case toastState.ERROR:
       color = Colors.red;
       break;
     case toastState.WARNING:
       color = Colors.amber;
       break;
   }
   return color;
}

