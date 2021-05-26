import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/shared/components/components.dart';
import 'package:shop_app_bloc/shared/cubit/app_cubit.dart';
import 'package:shop_app_bloc/shared/cubit/app_states.dart';
import 'package:shop_app_bloc/shared/styles/colors.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (context, state) {
        if (state is AppSuccessfulUpdateUserDataState) {
          clearFormField(AppCubit.get(context));
          Navigator.pop(context);
        }
        if (state is AppErrorUpdateUserDataState) {
          defaultToast(
            message: state.error,
            state: ToastState.ERROR,
          );
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: Form(
              key: cubit.formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Image.asset(
                          'assets/images/personal_informtion.png',
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      customTextField(
                        icon: Icons.person,
                        labelText: 'Name',
                        controller: cubit.nameController,
                        keyboardType: TextInputType.name,
                        validator: (String value) => cubit.validateName(value),
                      ),
                      customTextField(
                        icon: Icons.email,
                        labelText: 'Email',
                        controller: cubit.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (String value) => cubit.validateEmail(value),
                      ),
                      customTextField(
                        icon: Icons.phone,
                        labelText: 'Phone',
                        controller: cubit.phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (String value) => cubit.validatePhone(value),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              if (cubit.formKey.currentState.validate()) {
                                cubit.updateUserData(
                                  phone: cubit.phoneController.text,
                                  name: cubit.nameController.text,
                                  email: cubit.emailController.text,
                                );
                                // Navigator.pop(context);

                              }
                            },
                            child: Text(
                              'Update',
                              style:
                                  TextStyle(color: primaryColor, fontSize: 18),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              clearFormField(cubit);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style:
                                  TextStyle(color: primaryColor, fontSize: 18),
                            ),
                          )
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () {
                      //         if (cubit.formKey.currentState.validate()) {
                      //           cubit.updateUserData(
                      //             phone: cubit.phoneController.text,
                      //             name: cubit.nameController.text,
                      //             email: cubit.emailController.text,
                      //           );
                      //           // Navigator.pop(context);
                      //
                      //         }
                      //       },
                      //       child: Container(
                      //         padding: EdgeInsets.symmetric(
                      //             horizontal: 15, vertical: 10),
                      //         decoration: BoxDecoration(
                      //           color: primaryColor,
                      //           borderRadius: BorderRadius.circular(15),
                      //         ),
                      //         child: Text(
                      //           'Update',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //       ),
                      //     ),
                      //     // TextButton(
                      //     //   onPressed: () {
                      //     //     if (cubit.formKey.currentState.validate()) {
                      //     //       cubit.updateUserData(
                      //     //         phone: cubit.phoneController.text,
                      //     //         name: cubit.nameController.text,
                      //     //         email: cubit.emailController.text,
                      //     //       );
                      //     //       // Navigator.pop(context);
                      //     //
                      //     //     }
                      //     //   },
                      //     //   child: Text('Update'),
                      //     // ),
                      //     // TextButton(
                      //     //   onPressed: () {
                      //     //     clearFormField(cubit);
                      //     //     Navigator.pop(context);
                      //     //   },
                      //     //   child: Text('Cancel'),
                      //     // ),
                      //     GestureDetector(
                      //       onTap: () {
                      //         clearFormField(cubit);
                      //         Navigator.pop(context);
                      //       },
                      //       child: Container(
                      //         padding: EdgeInsets.symmetric(
                      //             horizontal: 15, vertical: 10),
                      //         decoration: BoxDecoration(
                      //           color: primaryColor,
                      //           borderRadius: BorderRadius.circular(15),
                      //         ),
                      //         child: Text(
                      //           'Cancel',
                      //           style: TextStyle(color: Colors.white),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget customTextField({
  @required IconData icon,
  @required String labelText,
  @required TextEditingController controller,
  @required TextInputType keyboardType,
  Function onSubmitted,
  Function validator,
  Function onTap,
}) =>
    Column(
      children: [
        TextFormField(
          onFieldSubmitted: onSubmitted,
          validator: validator,
          onTap: onTap,
          keyboardType: keyboardType,
          controller: controller,
          decoration: InputDecoration(
            errorStyle: TextStyle(
              fontSize: 13,
              color: Colors.red[700], // or any other color
            ),

            labelText: labelText,
            prefixIcon: Icon(
              icon,
            ),

            //  border: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );

void clearFormField(AppCubit cubit) {
  cubit.emailController.clear();
  cubit.phoneController.clear();
  cubit.nameController.clear();
}
