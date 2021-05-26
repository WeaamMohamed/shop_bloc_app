import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/shared/cubit/app_cubit.dart';
import 'package:shop_app_bloc/shared/cubit/app_states.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return cubit.categoryModel == null
            ? Center(child: CircularProgressIndicator())
            : ListView.separated(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _buildCategoryItem(
                      cubit.categoryModel.data.categoriesData[index]);
                },
                separatorBuilder: (context, index) => Divider(
                      height: 15,
                    ),
                itemCount: cubit.categoryModel.data.categoriesData.length);
      },
    );
  }

  Widget _buildCategoryItem(categories) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Container(
            height: 120,
            width: 120,
            child: Image.network(
              categories.image,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            categories.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
