import 'package:shop_app_bloc/models/change_favorite_model.dart';
import 'package:shop_app_bloc/modules/favorites/favorites_screen.dart';

abstract class AppCubitStates {}

class AppInitialState extends AppCubitStates {}

class AppChangeBottomNavBarState extends AppCubitStates {}

class AppLoadingHomeProductsState extends AppCubitStates {}

class AppSuccessfulHomeProductsState extends AppCubitStates {}

class AppErrorHomeProductsState extends AppCubitStates {}

class AppSuccessfulCategoriesState extends AppCubitStates {}

class AppErrorCategoriesState extends AppCubitStates {}

class AppSuccessToggleFavoritesState extends AppCubitStates {
  ChangeFavoritesModel changeFavoritesModel;
  AppSuccessToggleFavoritesState(this.changeFavoritesModel);
}

class AppErrorToggleFavoriteState extends AppCubitStates {
  ChangeFavoritesModel changeFavoritesModel;
  AppErrorToggleFavoriteState(this.changeFavoritesModel);
}

class AppChangeFavoriteState extends AppCubitStates {}

class AppSuccessfulGetFavoritesState extends AppCubitStates {}

class AppErrorGetFavoritesState extends AppCubitStates {}

class AppLoadingGetFavoritesState extends AppCubitStates {}

class AppSuccessfulLogOutState extends AppCubitStates {}

class AppErrorLogOutState extends AppCubitStates {}

class AppLoadingLogOutState extends AppCubitStates {}

class AppSuccessfulGetProfileDataState extends AppCubitStates {}

class AppErrorGetProfileDataState extends AppCubitStates {}

class AppErrorUpdateUserDataState extends AppCubitStates {
  final String error;
  AppErrorUpdateUserDataState(this.error);
}

class AppLoadingUpdateUserDataState extends AppCubitStates {}

class AppSuccessfulUpdateUserDataState extends AppCubitStates {}
