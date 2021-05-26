import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/models/search_model.dart';
import 'package:shop_app_bloc/modules/search/cubit/search_states.dart';
import 'package:shop_app_bloc/shared/components/constants.dart';
import 'package:shop_app_bloc/shared/network/end_points.dart';
import 'package:shop_app_bloc/shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchCubitStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  var searchController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  SearchModel searchModel;
  void search(String text) {
    emit(SearchLoadingState());
    DioHelper.postData(url: SEARCH, token: token, data: {
      "text": text,
    }).then((value) {
      print(value.data);
      searchModel = SearchModel.fromJson(value.data);
      print('searchModel: $searchModel');
      emit(SearchSuccessfulState());
    }).catchError((error) {
      print('search error $error');
      emit(SearchErrorState());
    });
  }
}
