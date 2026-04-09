import 'package:flutter/material.dart';
import 'package:infosha/screens/subscription/component/subscription_screen.dart';
import 'package:infosha/views/custom_text.dart';
import 'package:infosha/views/ui_helpers.dart';

class SubscribtionMessageBox extends StatelessWidget {
  var message;
  SubscribtionMessageBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFFAAEDFF),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        // height: 190,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
                padding:
                    EdgeInsets.only(top: 30, bottom: 30, right: 22, left: 22),
                child: CustomText(
                  text: message,
                  color: Color(
                    0xFF46464F,
                  ),
                  fontSize: 15.0,
                  height: 1.5,
                  textaligh: TextAlign.center,
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SubscriptionScreen(
                          isNewUser: false,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xFF1B2870),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Subscribe Now",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
              ),
            ),
            UIHelper.verticalSpaceMd
          ],
        ),
      ),
    );
  }
}
