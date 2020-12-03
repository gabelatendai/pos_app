

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/food_bloc.dart';

import 'Cart_list.dart';

class FoodListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return     BlocProvider<FoodBloc>(
        create: (context) => FoodBloc(),
    child:  Scaffold(
      appBar: AppBar(title: Text('Cheetah Coding')),
      body: FoodList(),
      ));
  }
}
