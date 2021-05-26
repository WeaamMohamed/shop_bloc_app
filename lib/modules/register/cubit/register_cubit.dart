import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/models/register_model.dart';
import 'package:shop_app_bloc/modules/register/cubit/register_states.dart';
import 'package:shop_app_bloc/shared/network/end_points.dart';
import 'package:shop_app_bloc/shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  RegisterModel registerModel;
  bool isObscure = true;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  void changePasswordVisibility() {
    isObscure = !isObscure;
    emit(ChangeRegisterPasswordVisibilityState());
  }

  String validateEmail(String value) {
    print(emailController.text);
    if (value.isEmpty) {
      return 'Email must not be empty.';
    }
    return null;
  }

  String validateName(String value) {
    print(emailController.text);
    if (value.isEmpty) {
      return 'Email must not be empty.';
    }
    return null;
  }

  String validatePhone(String value) {
    print(emailController.text);
    if (value.isEmpty) {
      return 'Phone must not be empty.';
    }
    return null;
  }

  String validatePassword(String value) {
    print(passwordController.text);
    if (value.isEmpty) {
      return 'Password must not be empty.';
    } else if (value.length < 6) {
      return 'Password must be more than 6 characters';
    } else if (RegisterCubit is RegisterErrorState) {
      //return LoginErrorState().error.toString();
      return 'login error';
    }
    return null;
  }

  void userRegister({
    @required String email,
    @required String password,
    @required String phone,
    @required String name,
    // @required String image,
    //  @required newToken,
  }) {
    emit(RegisterLoadingState());
    DioHelper.postData(
      url: REGISTER,
      //token: token,
      data: {
        'email': email,
        'password': password,
        'phone': phone,
        'name': name,
      },
    ).then((value) {
      registerModel = RegisterModel.fromJson(value.data);

      emit(RegisterSuccessfulState(registerModel));
    }).catchError((error) {
      print('error: $error');
      emit(RegisterErrorState(error.toString()));
    });
  }
}
