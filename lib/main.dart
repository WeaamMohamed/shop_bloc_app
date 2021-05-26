import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/layout/control_layout.dart';
import 'package:shop_app_bloc/modules/login/login_screen.dart';
import 'package:shop_app_bloc/shared/bloc_observer.dart';
import 'package:shop_app_bloc/shared/components/constants.dart';
import 'package:shop_app_bloc/shared/cubit/app_cubit.dart';
import 'package:shop_app_bloc/shared/network/local/cache_helper.dart';
import 'package:shop_app_bloc/shared/network/remote/dio_helper.dart';
import 'package:shop_app_bloc/shared/styles/themes.dart';

import 'modules/on_boarding_screen/on_boarding_screen.dart';

void main() async {
  //to make sure that everything in this method finished the open the app
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  Widget startWidget;
  bool onBoardingFinished =
      CacheHelper.getData(key: 'onBoardingFinished') ?? false;
  token = CacheHelper.getData(key: 'token');
  //not logged in yet
  if (token == null) {
    //start log in screen
    if (onBoardingFinished) {
      LoginScreen();
    }
    //start onBroad
    else {
      startWidget = OnBoardingScreen();
    }
  }
  //user is already logged in
  else {
    startWidget = ControlLayout();
  }

  print('Start Widget: $startWidget');
  runApp(MyApp(startWidget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  MyApp(this.startWidget);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getHomeProducts(token: token)
        ..getCategories()
        ..getFavorites()
        ..getProfileData(token: token),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop app',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home: startWidget,
        // home: onBoardingFinished ? LoginScreen() : OnBoardingScreen(),
      ),
    );
  }
}
