import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/layout/control_layout.dart';
import 'package:shop_app_bloc/modules/login/login_screen.dart';
import 'package:shop_app_bloc/modules/register/cubit/register_cubit.dart';
import 'package:shop_app_bloc/modules/register/cubit/register_states.dart';
import 'package:shop_app_bloc/shared/components/constants.dart';
import 'package:shop_app_bloc/shared/network/local/cache_helper.dart';
import 'package:shop_app_bloc/shared/styles/colors.dart';
import '../../shared/components/components.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterErrorState) {
            defaultToast(
              message: state.error,
              state: ToastState.WARNING,
            );
          }

          if (state is RegisterSuccessfulState) {
            //if status is true that means you logged in successfully
            if (state.registerModel.status) {
              CacheHelper.saveData(
                      key: 'token', data: state.registerModel.data.token)
                  .then((value) {
                token = state.registerModel.data.token;
                print('my token: $token');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ControlLayout(),
                  ),
                );
              });
            } else {
              defaultToast(
                message: state.registerModel.message,
                state: ToastState.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          //to use it without typing it each time
          RegisterCubit cubit = RegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height * 0.15,
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Sign Up to continue..",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            body: Container(
              // height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(top: 5, left: 15, right: 15),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: cubit.formKey,
                    child: Stack(children: [
                      if (state is RegisterLoadingState)
                        Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          // Spacer(
                          //   flex: 1,
                          // ),
                          Column(
                            children: [
                              defaultTextForm(
                                validator: (value) => cubit.validateName(value),
                                labelText: 'Name',
                                keyboardType: TextInputType.name,
                                controller: cubit.nameController,
                                icon: Icons.person,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              defaultTextForm(
                                validator: (value) =>
                                    cubit.validatePhone(value),
                                labelText: 'phone',
                                keyboardType: TextInputType.phone,
                                controller: cubit.phoneController,
                                icon: Icons.phone,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              defaultTextForm(
                                validator: (value) =>
                                    cubit.validateEmail(value),
                                labelText: 'Email Address',
                                keyboardType: TextInputType.emailAddress,
                                controller: cubit.emailController,
                                icon: Icons.email,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              defaultTextForm(
                                onSuffixPressed: () {
                                  cubit.changePasswordVisibility();
                                },
                                onSubmitted: (_) => register(cubit),
                                isObscure: cubit.isObscure,
                                suffixIcon: cubit.isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                icon: Icons.lock,
                                labelText: 'Password',
                                keyboardType: TextInputType.visiblePassword,
                                controller: cubit.passwordController,
                                validator: (value) =>
                                    cubit.validatePassword(value),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              defaultButton(
                                text: 'Sign Up',
                                onPressed: () => register(cubit),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Already have an account?',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (ctx) => LoginScreen(),
                                      ));
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void register(RegisterCubit cubit) {
    if (cubit.formKey.currentState.validate()) {
      cubit.userRegister(
        email: cubit.emailController.text,
        password: cubit.passwordController.text,
        // image: ,
        name: cubit.nameController.text,
        phone: cubit.phoneController.text,

        //  newToken: cubit.loginModel.data.token,
      );
    }
  }
}
