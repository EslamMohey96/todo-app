import 'package:flutter/material.dart';
import 'package:todo/shared/cubit/layoutCubit.dart';

// sizeBoxHWidget
Widget sizeBoxH(double x) => SizedBox(
      height: x,
    );
// sizeBoxWWidget
Widget sizeBoxW(double x) => SizedBox(
      width: x,
    );
// textFormField
Widget textFormField({
  required TextEditingController controller,
  required TextInputType textInputType,
  required String labelText,
  required Icon prefixIcon,
  required String? Function(String?)? valid,
  bool visible = false,
  bool isClickable = true,
  IconData? suffixIcon,
  Function()? suffixPressed,
  Function? onSubmit,
  Function? onChange,
  Function()? ontap,
}) =>
    TextFormField(
      // initialValue: passwordController.text,
      controller: controller,
      keyboardType: textInputType,
      obscureText: visible,
      // onFieldSubmitted: onSubmit,
      // onChanged: onChange,
      validator: valid,
      onTap: ontap,
      enabled: isClickable,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: IconButton(
          icon: Icon(suffixIcon),
          onPressed: suffixPressed,
        ),
        border: const OutlineInputBorder(),
      ),
    );
Widget taskItem(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      myLayoutCubit.get(context).deleteBD(
            id: model['id'],
          );
    },
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            child: Text(
              model['title'],
            ),
          ),
          sizeBoxW(20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  model['time'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  model['date'],
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ),
          sizeBoxW(20),
          // Text(myLayoutCubit
          //     .get(context)
          //     .changeStatusState(status: model["status"])),
          sizeBoxW(20),
          IconButton(
            onPressed: () {
              myLayoutCubit.get(context).updateDB(
                    status: "done",
                    id: model['id'],
                  );
            },
            color: Colors.green,
            icon: Icon(Icons.check_circle_outline),
          ),
          sizeBoxW(20),
          IconButton(
            onPressed: () {
              myLayoutCubit.get(context).updateDB(
                    status: "archived",
                    id: model['id'],
                  );
            },
            color: Colors.teal,
            icon: Icon(Icons.archive_outlined),
          ),
        ],
      ),
    ),
  );
}

Widget tasksBuilder({
  required List<Map> tasksList,
}) {
  return tasksList.length > 0
      ? ListView.separated(
          itemBuilder: (context, item) => taskItem(tasksList[item], context),
          separatorBuilder: (context, item) => Container(
            color: Colors.teal,
            child: sizeBoxH(1),
          ),
          itemCount: tasksList.length,
        )
      : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No tasks yet, Please add some tasks",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
}
