
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/bloc/food_bloc.dart';
import 'package:pos_app/events/food_event.dart';
import 'package:pos_app/Models/food.dart';

class FoodList extends StatelessWidget {
  int total =0;
  multi(x, y) => x * y;
  double charge = 0.00;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: BlocConsumer<FoodBloc, List<Food>>(
              buildWhen: (List<Food> previous, List<Food> current) {
                return true;
              },
              listenWhen: (List<Food> previous, List<Food> current) {
                if (current.length > previous.length) {
                  return true;
                }

                return false;
              },
              builder: (context, foodList) {
                return ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.all(16),
                  itemCount: foodList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        BlocProvider.of<FoodBloc>(context).add(
                            FoodEvent.delete(index));
                        // _removeFromCart(i);
                        // _delete(carts[i]['id']);
                      },
                      title: RichText(
                        text: TextSpan(
                            text:
                            foodList[index].name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' x ${foodList[index].qnty}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.orange,
                                  )),
                            ]),
                      ),
                      subtitle: Text('\$${foodList[index].price}'),
                      trailing: Text('\$ 50'),
                    );
                  },separatorBuilder: (context, i) {
                  return Divider(
                    height: 1,
                  );
                },
                );
              },
              listener: (BuildContext context, foodList) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('Added!')),
                );
              },
            ),
         );
  }
}
