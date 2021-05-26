import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/models/login_model.dart';
import 'package:shop_app_bloc/modules/login/cubit/states_login.dart';
import 'package:shop_app_bloc/shared/components/constants.dart';
import 'package:shop_app_bloc/shared/network/end_points.dart';
import 'package:shop_app_bloc/shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  LoginModel loginModel;
  bool isObscure = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  void changePasswordVisibility() {
    isObscure = !isObscure;
    emit(ChangePasswordVisibilityState());
  }

  String validateEmail(String value) {
    print(emailController.text);
    if (value.isEmpty) {
      return 'Email must not be null.';
    }
    return null;
  }

  String validatePassword(String value) {
    print(passwordController.text);
    if (value.isEmpty) {
      return 'Password must not be null.';
    } else if (value.length < 6) {
      return 'Password must be more than 6 characters';
    } else if (LoginCubit is LoginErrorState) {
      //return LoginErrorState().error.toString();
      return 'login error';
    }
    return null;
  }

  void userLogin({
    @required String email,
    @required String password,
    //  @required newToken,
  }) {
    emit(LoginLoadingState());
    DioHelper.postData(url: LOGIN, token: token, data: {
      'email': email,
      'password': password,
    }).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      // print(loginModel.data.token);

      // token = newToken;
      emit(LoginSuccessfulState(loginModel));
    }).catchError((error) {
      print('error: $error');
      emit(LoginErrorState(error.toString()));
    });
  }
}
