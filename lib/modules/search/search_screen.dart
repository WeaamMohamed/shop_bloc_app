import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/models/search_model.dart';
import 'package:shop_app_bloc/modules/search/cubit/search_cubit.dart';
import 'package:shop_app_bloc/modules/search/cubit/search_states.dart';
import 'package:shop_app_bloc/shared/components/components.dart';
import 'package:shop_app_bloc/shared/cubit/app_cubit.dart';
import 'package:shop_app_bloc/shared/styles/colors.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchCubitStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SearchCubit cubit = SearchCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Form(
                key: cubit.formKey,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: Column(
                    children: [
                      defaultTextForm(
                          onSubmitted: (value) {
                            print('search value $value');
                            cubit.search(value);
                          },
                          icon: Icons.search,
                          labelText: 'Search',
                          controller: cubit.searchController,
                          keyboardType: TextInputType.text,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Enter text to search.';
                            }
                            return null;
                          }),
                      if (state is SearchLoadingState)
                        Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      if (cubit.searchModel != null &&
                          state is! SearchLoadingState)
                        Expanded(
                          child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                              separatorBuilder: (context, index) => Divider(
                                    thickness: 1.2,
                                    height: 20,
                                  ),
                              itemCount: cubit.searchModel.data.dataList.length,
                              itemBuilder: (context, index) {
                                return _buildFavoritesItem(context,
                                    cubit.searchModel.data.dataList[index]);
                              }),
                        )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildFavoritesItem(context, DataResult result) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.2,
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.33,
            height: MediaQuery.of(context).size.height * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                result.image,
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
                  result.name,
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
                      '\$${result.price}',
                      maxLines: 5,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    defaultFavoriteIconButton(
                      onPressed: () {
                        AppCubit.get(context).toggleFavorites(result.id);
                      },
                      backgroundColor:
                          AppCubit.get(context).favorites[result.id]
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
