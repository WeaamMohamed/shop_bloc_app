import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/layout/control_layout.dart';
import 'package:shop_app_bloc/modules/register/register_screen.dart';
import 'package:shop_app_bloc/shared/components/constants.dart';
import 'package:shop_app_bloc/shared/network/local/cache_helper.dart';

import 'package:shop_app_bloc/shared/styles/colors.dart';

import '../../shared/components/components.dart';
import 'cubit/cubit_login.dart';
import 'cubit/states_login.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            defaultToast(
              message: state.error,
              state: ToastState.WARNING,
            );
          }

          if (state is LoginSuccessfulState) {
            //if status is true that means you logged in successfully
            if (state.loginModel.status) {
              CacheHelper.saveData(
                      key: 'token', data: state.loginModel.data.token)
                  .then((value) {
                token = state.loginModel.data.token;
                print('my token: $token');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ControlLayout(),
                  ),
                );
              });
              // defaultToast(
              //   message: state.loginModel.message,
              //   state: ToastState.SUCCESSFUL,
              // );
            } else {
              defaultToast(
                message: state.loginModel.message,
                state: ToastState.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          //to use it without typing it each time
          LoginCubit cubit = LoginCubit.get(context);
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
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Sign in to continue..",
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
                      if (state is LoginLoadingState)
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
                                onSubmitted: (_) => login(cubit),
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
                                text: 'Log In',
                                onPressed: () => login(cubit),
                                // onPressed: () {
                                //   if (cubit.formKey.currentState.validate()) {
                                //     cubit.userLogin(
                                //       email: cubit.emailController.text,
                                //       password: cubit.passwordController.text,
                                //       // email: 'weaamMohamed@gmail.com',
                                //       // password: '123456',
                                //     );
                                //   }
                                //
                                //   // Navigator.pushReplacement(
                                //   //   context,
                                //   //   MaterialPageRoute(
                                //   //       builder: (ctx) => ControlScreen()),
                                //   // );
                                // },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Dont\'t have an account?',
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
                                        builder: (ctx) => RegisterScreen(),
                                      ));
                                    },
                                    child: Text(
                                      'Register',
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

  void login(LoginCubit cubit) {
    if (cubit.formKey.currentState.validate()) {
      cubit.userLogin(
        email: cubit.emailController.text,
        password: cubit.passwordController.text,
        //  newToken: cubit.loginModel.data.token,
      );
    }
  }
}
