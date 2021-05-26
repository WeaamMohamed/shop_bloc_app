import 'package:clippy_flutter/label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/shared/components/components.dart';
import 'package:shop_app_bloc/shared/cubit/app_cubit.dart';
import 'package:shop_app_bloc/shared/cubit/app_states.dart';
import 'package:shop_app_bloc/shared/styles/colors.dart';

class DetailsScreen extends StatelessWidget {
  final int index;
  DetailsScreen({@required this.index});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var products =
            AppCubit.get(context).homeProductsModel.data.products[index];
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 20),
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        child: Image.network(
                          products.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                      if (products.discount != 0)
                        Positioned(
                          top: 0,
                          left: 0,
                          child: Label(
                            triangleHeight: 10.0,
                            edge: Edge.RIGHT,
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                right: 18.0,
                                top: 8.0,
                                bottom: 8.0,
                              ),
                              color: Colors.red,
                              child: Text(
                                '${products.discount.toString()}% off',
                                style: TextStyle(
                                  wordSpacing: 2,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${products.price}',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      if (products.discount != 0)
                        Text(
                          // '\$${double.parse((products.oldPrice).toStringAsFixed(0))}',
                          '\$${(products.oldPrice).toInt()}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                            decorationThickness: 2,
                            color: Colors.grey,
                          ),
                        ),
                      Spacer(),
                      defaultFavoriteIconButton(
                        onPressed: () {
                          AppCubit.get(context).toggleFavorites(products.id);
                        },
                        backgroundColor:
                            AppCubit.get(context).favorites[products.id]
                                ? Colors.redAccent
                                : Colors.grey[400],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      products.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Text(
                      products.description,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
