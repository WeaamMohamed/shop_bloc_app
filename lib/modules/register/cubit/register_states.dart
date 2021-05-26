import 'package:shop_app_bloc/models/login_model.dart';
import 'package:shop_app_bloc/models/register_model.dart';

abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessfulState extends RegisterStates {
  final RegisterModel registerModel;
  RegisterSuccessfulState(this.registerModel);
}

class RegisterErrorState extends RegisterStates {
  final String error;
  RegisterErrorState(this.error);
}

class ChangeRegisterPasswordVisibilityState extends RegisterStates {}
