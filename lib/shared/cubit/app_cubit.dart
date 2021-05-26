import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/models/categories_model.dart';
import 'package:shop_app_bloc/models/change_favorite_model.dart';
import 'package:shop_app_bloc/models/favorites_model.dart';
import 'package:shop_app_bloc/models/home_products_model.dart';
import 'package:shop_app_bloc/models/profile_model.dart';
import 'package:shop_app_bloc/modules/categories/categories_screen.dart';
import 'package:shop_app_bloc/modules/favorites/favorites_screen.dart';
import 'package:shop_app_bloc/modules/home/home_screen.dart';
import 'package:shop_app_bloc/modules/login/login_screen.dart';
import 'package:shop_app_bloc/modules/settings/settings_screen.dart';
import 'package:shop_app_bloc/shared/components/constants.dart';
import 'package:shop_app_bloc/shared/cubit/app_states.dart';
import 'package:shop_app_bloc/shared/network/end_points.dart';
import 'package:shop_app_bloc/shared/network/local/cache_helper.dart';
import 'package:shop_app_bloc/shared/network/remote/dio_helper.dart';

class AppCubit extends Cubit<AppCubitStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndexBottomNav = 0;

  List layouts = [
    HomeScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];
  List appBarTitles = [
    'Home',
    'Categories',
    'Favorites',
    ' ',
  ];

  List<BottomNavigationBarItem> bottomNavBarItems = [
    BottomNavigationBarItem(
      label: 'Home',
      icon: Icon(Icons.home),
    ),
    BottomNavigationBarItem(
      label: 'Categories',
      icon: Icon(Icons.apps_outlined),
      // icon: Icon(Icons.widgets),
    ),
    BottomNavigationBarItem(
      label: 'Favorites',
      icon: Icon(Icons.favorite),
    ),
    BottomNavigationBarItem(
      label: 'Settings',
      icon: Icon(
        Icons.settings,
        // color: Colors.transparent,
      ),
    ),
  ];

  void changeIndex(int index) {
    currentIndexBottomNav = index;
    emit(AppChangeBottomNavBarState());
  }

  HomeProductsModel homeProductsModel;

  Map<int, bool> favorites = {};
  void getHomeProducts({
    @required token,
  }) {
    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((products) {
      homeProductsModel = HomeProductsModel.fromJson(products.data);

      homeProductsModel.data.products.forEach((element) {
        favorites.addAll({element.id: element.inFavorites});
      });
      emit(AppSuccessfulHomeProductsState());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorHomeProductsState());
    });
  }

  CategoryModel categoryModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
    ).then((products) {
      categoryModel = CategoryModel.fromJson(products.data);

      emit(AppSuccessfulCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorCategoriesState());
    });
  }

  ChangeFavoritesModel changeFavoritesModel;

  void toggleFavorites(int productId) {
    favorites[productId] = !favorites[productId];
    emit(AppChangeFavoriteState());
    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((products) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(products.data);

      if (!changeFavoritesModel.status) {
        //todo: show toast
        favorites[productId] = !favorites[productId];
      } else {
        getFavorites();
      }

      emit(AppSuccessToggleFavoritesState(changeFavoritesModel));
    }).catchError((error) {
      //todo: show toast
      favorites[productId] = !favorites[productId];
      print(error.toString());
      emit(AppErrorToggleFavoriteState(changeFavoritesModel));
    });
  }

  FavoritesModel favoritesModel;
  void getFavorites() {
    emit(AppLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((products) {
      favoritesModel = FavoritesModel.fromJson(products.data);
      print('favorites model: ${favoritesModel.data.data}');
      emit(AppSuccessfulGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorGetFavoritesState());
    });
  }

  void userLogOut({@required context}) {
    CacheHelper.removeData(key: 'token').then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    });

    emit(AppLoadingLogOutState());
    DioHelper.postData(
      url: LOGOUT,
      data: {
        'fcm_token': 'SomeFcmToken',
      },
      token: token,
    ).then((value) {
      // loginModel = LoginModel.fromJson(value.data);

      emit(AppSuccessfulLogOutState());
    }).catchError((error) {
      print('error: $error');
      emit(AppErrorLogOutState());
    });
  }

  ProfileModel profileModel;

  void getProfileData({
    @required token,
  }) {
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((profileData) {
      profileModel = ProfileModel.fromJson(profileData.data);

      emit(AppSuccessfulGetProfileDataState());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorGetProfileDataState());
    });
  }

  void updateUserData({
    @required String email,
    @required String phone,
    @required String name,
  }) {
    emit(AppLoadingUpdateUserDataState());
    DioHelper.putData(
      url: UPDATE_PROFILE,
      data: {
        'email': email,
        'phone': phone,
        'name': name,
      },
      token: token,
    ).then((value) {
      // loginModel = LoginModel.fromJson(value.data);
      profileModel = ProfileModel.fromJson(value.data);
      print(profileModel.data);

      emit(AppSuccessfulUpdateUserDataState());
    }).catchError((error) {
      print('error: $error');
      emit(AppErrorUpdateUserDataState(error.toString()));
    });
  }

  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  String validateEmail(String value) {
    print(emailController.text);
    if (value.isEmpty || state is AppErrorUpdateUserDataState) {
      emailController.text = profileModel.data.email;
    }
    return null;
  }

  String validateName(String value) {
    print(nameController.text);
    if (value.isEmpty || state is AppErrorUpdateUserDataState) {
      nameController.text = profileModel.data.name;
    }

    return null;
  }

  String validatePhone(String value) {
    print(emailController.text);
    if (value.isEmpty || state is AppErrorUpdateUserDataState) {
      phoneController.text = profileModel.data.phone;
    }
    return null;
  }
}
