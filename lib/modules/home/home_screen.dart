import 'package:carousel_slider/carousel_slider.dart';
import 'package:clippy_flutter/label.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/models/categories_model.dart';
import 'package:shop_app_bloc/models/home_products_model.dart';
import 'package:shop_app_bloc/modules/details/details_screen.dart';
import 'package:shop_app_bloc/shared/components/components.dart';
import 'package:shop_app_bloc/shared/cubit/app_cubit.dart';
import 'package:shop_app_bloc/shared/cubit/app_states.dart';
import 'package:shop_app_bloc/shared/styles/colors.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (context, state) {
        if (state is AppSuccessToggleFavoritesState) {
          if (!state.changeFavoritesModel.status) {
            defaultToast(
              state: ToastState.ERROR,
              message: state.changeFavoritesModel.message,
            );
          }
        } else if (state is AppErrorToggleFavoriteState) {
          defaultToast(
            state: ToastState.ERROR,
            message: state.changeFavoritesModel.message,
          );
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return cubit.homeProductsModel == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCarouselSlider(context),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 5,
                      ),
                      child: GridView.count(
                        childAspectRatio: 1 / 1.33,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        // crossAxisSpacing: 10,
                        // mainAxisSpacing: 10,
                        children: List.generate(
                            cubit.homeProductsModel.data.products.length,
                            (index) {
                          return _buildGridProductItem(
                            context: context,
                            // id: cubit.homeProductsModel.data.products[index].id,
                            products:
                                cubit.homeProductsModel.data.products[index],
                            index: index,
                          );
                        }),
                      ),
                    )
                  ],
                ),
              );
      },
    );
  }

  Widget _buildCarouselSlider(context) {
    return CarouselSlider(
      items: [
        Image.asset(
          'assets/images/banner2.jpg',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/banner1.jpg',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Image.asset(
          'assets/images/banner3.jpg',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ],
      options: CarouselOptions(
        autoPlay: true,
        height: MediaQuery.of(context).size.height * 0.3,
        viewportFraction: 1,
        // enlargeCenterPage: true,
        autoPlayInterval: Duration(seconds: 4),
        autoPlayCurve: Curves.fastOutSlowIn,
        //aspectRatio: 5.0,
      ),

      //    options: options
    );
  }

  Widget _buildGridProductItem({
    Products products,
    context,
    index,
  }) =>
      Card(
        // margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(index: index),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            height: 200,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(children: [
                  Center(
                    child: Image.network(
                      products.image,
                      fit: BoxFit.scaleDown,
                      height: 170,
                    ),
                  ),
                  if (products.discount != 0)
                    Positioned(
                      top: 5,
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
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ]),
                SizedBox(
                  height: 8,
                ),
                Text(
                  products.name,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      '\$${products.price}',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    if (products.discount != 0)
                      Text(
                        // '\$${double.parse((products.oldPrice).toStringAsFixed(0))}',
                        '\$${(products.oldPrice).toInt()}',
                        style: TextStyle(
                          fontSize: 15,
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
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildCategoryItem(
          {@required List<DataModel> categories, @required Function onTap}) =>
      Container(
        height: 100,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: onTap,
                child: Stack(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.38,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          categories[index].image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.38,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    Positioned(
                      left: 15,
                      bottom: 20,
                      child: Text(
                        categories[index].name,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
              );
            },
            //separatorBuilder: (context, index) => Divider(),
            itemCount: categories.length),
      );
}
