import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_bloc/modules/edit_profile/edit_profile_screen.dart';
import 'package:shop_app_bloc/shared/cubit/app_cubit.dart';
import 'package:shop_app_bloc/shared/cubit/app_states.dart';
import 'package:shop_app_bloc/shared/styles/colors.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppCubitStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
              body: Padding(
            padding: const EdgeInsets.only(
              top: 20,
              right: 10,
              left: 10,
              bottom: 10,
            ),
            child: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      'assets/images/profile.jpg',
                    ),
                    minRadius: 30,
                    maxRadius: 60,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    children: [
                      Text(
                        AppCubit.get(context).profileModel != null
                            ? AppCubit.get(context).profileModel.data.name
                            : '',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        AppCubit.get(context).profileModel != null
                            ? AppCubit.get(context).profileModel.data.email
                            : '',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      state is AppLoadingLogOutState
                          ? CircularProgressIndicator()
                          : SizedBox(
                              height: 50,
                            ),
                      customListTile(
                          title: 'Edit Profile',
                          icon: Icons.edit,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(),
                              ),
                            );
                          }),
                      customListTile(title: 'Cards', icon: Icons.credit_card),
                      customListTile(
                        title: 'Log Out',
                        icon: Icons.logout,
                        onTap: () {
                          AppCubit.get(context).userLogOut(context: context);
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
        );
      },
    );
  }

  Widget customListTile({icon, title, onTap}) => Container(
        padding: EdgeInsets.only(top: 10),
        child: ListTile(
          onTap: onTap,
          leading: Icon(
            icon,
            color: primaryColor,
          ),
          title: Text(title),
          trailing: Icon(
              // Icons.arrow_forward_ios,
              Icons.navigate_next),
        ),
      );
}
