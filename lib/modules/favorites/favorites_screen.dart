import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/models/favorites_model.dart';
import 'package:shop_app_bloc/shared/components/components.dart';
import 'package:shop_app_bloc/shared/cubit/app_cubit.dart';
import 'package:shop_app_bloc/shared/cubit/app_states.dart';
import 'package:shop_app_bloc/shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppCubitStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return cubit.favoritesModel == null
              ? Center(child: CircularProgressIndicator())
              : cubit.favoritesModel.data.data.length == 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/fav.png',
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Add your Favorite products',
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ),
                      ],
                    )
                  : ListView.separated(
                      physics: BouncingScrollPhysics(),
                      separatorBuilder: (context, index) => Divider(
                            thickness: 1.2,
                            height: 20,
                          ),
                      itemCount: cubit.favoritesModel.data.data.length,
                      itemBuilder: (context, index) {
                        return _buildFavoritesItem(context,
                            cubit.favoritesModel.data.data[index].product);
                      });
        });
  }

  Widget _buildFavoritesItem(context, Product favorites) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.33,
              height: MediaQuery.of(context).size.height * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  favorites.image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    favorites.name,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${favorites.price}',
                        maxLines: 5,
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      defaultFavoriteIconButton(
                        onPressed: () {
                          AppCubit.get(context).toggleFavorites(favorites.id);
                        },
                        backgroundColor:
                            AppCubit.get(context).favorites[favorites.id]
                                ? Colors.redAccent
                                : Colors.grey[400],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
