import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/cubit/layoutCubit.dart';
import 'package:todo/shared/cubit/layoutStates.dart';

class homeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return myLayoutCubit()..createDB();
      },
      child: BlocConsumer<myLayoutCubit, myLayoutStates>(
        listener: (BuildContext context, myLayoutStates state) {
          if (state is layoutInsertDBState) {
            Navigator.pop(context);
            titleController.text = "";
            dateController.text = "";
            timeController.text = "";
          }
          ;
        },
        builder: (BuildContext context, myLayoutStates state) {
          myLayoutCubit cubit = myLayoutCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.teal,
              title: Text(
                cubit.title[cubit.currentIndex],
              ),
            ),
            body: state is layoutLaodingSheetState
                ? Center(child: CircularProgressIndicator())
                : cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDB(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                        (context) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 50,
                                  color: Colors.white,
                                  child: textFormField(
                                    controller: titleController,
                                    textInputType: TextInputType.text,
                                    labelText: "title",
                                    prefixIcon: Icon(Icons.title),
                                    valid: (value) {
                                      if (value!.isEmpty) {
                                        return "Title is required";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                sizeBoxH(10),
                                Container(
                                  color: Colors.white,
                                  child: textFormField(
                                      controller: timeController,
                                      textInputType: TextInputType.datetime,
                                      labelText: "time",
                                      prefixIcon: Icon(
                                        Icons.access_time,
                                      ),
                                      valid: (value) {
                                        if (value!.isEmpty) {
                                          return "time is required";
                                        }
                                        return null;
                                      },
                                      ontap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          timeController.text =
                                              value!.format(context).toString();
                                          print(value.format(context));
                                        });
                                      }),
                                ),
                                sizeBoxH(10),
                                Container(
                                  color: Colors.white,
                                  child: textFormField(
                                      controller: dateController,
                                      textInputType: TextInputType.datetime,
                                      labelText: "date",
                                      prefixIcon: Icon(
                                        Icons.date_range,
                                      ),
                                      valid: (value) {
                                        if (value!.isEmpty) {
                                          return "date is required";
                                        }
                                        return null;
                                      },
                                      ontap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2030-10-30'),
                                        ).then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd()
                                                  .format(value!)
                                                  .toString();
                                          print(dateController.text);
                                        });
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        backgroundColor: Colors.tealAccent,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                      isBottomSheet: false,
                      icon: Icon(Icons.edit),
                    );
                  });
                  cubit.changeBottomSheetState(
                    isBottomSheet: true,
                    icon: Icon(Icons.add),
                  );
                }
              },
              child: cubit.fabIcon,
            ),
            bottomNavigationBar: BottomNavigationBar(
              fixedColor: Colors.black,
              backgroundColor: Colors.teal,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex, //default is bottom number 0
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: "Archived",
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
