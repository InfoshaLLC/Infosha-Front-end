import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/Controller/models/user_full_model.dart';
import 'package:infosha/Controller/models/user_model.dart';
import 'package:provider/provider.dart';

class LockWidget extends StatelessWidget {
  const LockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(builder: (context, provider, child) {
      return getIsUserCanViewTheOpponentProfile(null, provider.userModel)
          ? const SizedBox()
          : Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.black38.withOpacity(0.1),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock, size: 28, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          "Profile Locked",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
    });
  }

  getIsUserCanViewTheOpponentProfile(UserFullModel? viewProfileModel, UserModel appUser) {
    if ((appUser.is_subscription_active == true &&
        ((appUser.active_subscription_plan_name!.contains("god")) || appUser.active_subscription_plan_name!.contains("king")))) {
      return false;
    } else {
      return false;
    }
    // if (viewProfileModel != null && viewProfileModel.data != null) {
    //   if ((appUser.is_subscription_active == true && appUser.active_subscription_plan_name!.contains("god"))) {
    //     return true;
    //   } else if ((appUser.is_subscription_active == true && appUser.active_subscription_plan_name!.contains("king")) &&
    //       (viewProfileModel.data!.is_subscription_active == true && viewProfileModel.data!.active_subscription_plan_name!.contains("god"))) {
    //     return false;
    //   } else {
    //     return true;
    //   }
    // } else {
    //   return false;
    // }
  }
}
