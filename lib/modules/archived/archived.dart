import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components/components.dart';
import 'package:todo/shared/components/constants.dart';
import 'package:todo/shared/cubit/layoutCubit.dart';
import 'package:todo/shared/cubit/layoutStates.dart';

class archived extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<myLayoutCubit, myLayoutStates>(
      builder: (BuildContext context, myLayoutStates state) {
        return tasksBuilder(tasksList: archivedList);
      },
      listener: (BuildContext context, myLayoutStates state) {},
    );
  }
}
