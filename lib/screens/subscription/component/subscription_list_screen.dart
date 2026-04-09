import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/text_styles.dart';
import 'package:infosha/views/custom_button.dart';
import 'package:infosha/utils/error_boundary.dart';
import 'package:infosha/screens/subscription/controller/subscription_model.dart';
import 'package:infosha/screens/subscription/model/subscription_list_model.dart';

class SubscriptionListScreen extends StatefulWidget {
  String plan;
  bool isNewUser;
  SubscriptionListScreen({super.key, required this.plan, required this.isNewUser});
  @override
  State<SubscriptionListScreen> createState() => _SubscriptionListScreenState();
}

class _SubscriptionListScreenState extends State<SubscriptionListScreen> {
  late SubscriptionModel provider;

  @override
  void initState() {
    provider = Provider.of<SubscriptionModel>(context, listen: false);
    provider.planList.clear();

    // Provider.of<SubscriptionModel>(context, listen: false)
    //     .getSubscriptionData()
    //     .then((value) {
    //   provider.planList = provider.subscriptionListModel.data!
    //       .where((e) => e.name!.contains(widget.plan == "King Status"
    //           ? "king"
    //           : widget.plan == "God Status"
    //               ? "god"
    //               : "god"))
    //       .toList();
    //   if (provider.planList.isNotEmpty) {
    //     provider.selectedPlan = provider.planList[0];
    //   }
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.getSubscriptionData();

      provider.planList = provider.subscriptionListModel.data!
          .where((e) => e.name!.contains(
                widget.plan == "King Status"
                    ? "king"
                    : widget.plan == "God Status"
                        ? "god"
                        : "god",
              ))
          .toList();

      if (provider.planList.isNotEmpty) {
        provider.selectedPlan = provider.planList.first;
      }

      setState(() {}); // safe now
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Consumer<SubscriptionModel>(builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'images/infosha.png',
                width: Get.width,
              ),
              SizedBox(height: Get.height * 0.05),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome to Infosha".tr,
                      style: const TextStyle(fontSize: 22, fontWeight: fontWeightBold),
                    ),
                    SizedBox(height: Get.height * 0.01),
                    Text(
                      "You are now a Standard User. To unlock all features subscribe status.".tr,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              if (provider.subscriptionListModel.data != null && provider.subscriptionListModel.data!.isNotEmpty) ...[
                provider.isLoading
                    ? const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(color: baseColor),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.planList.length,
                        itemBuilder: (context, index) {
                          return radioListTile(provider.planList[index]);
                        },
                      )
              ]
            ],
          );
        }),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<SubscriptionModel>(builder: (context, provider, child) {
                return CustomButton(
                  () {
                    provider.submitPlan();
                  },
                  text: provider.isSubmit ? "loading" : "Continue".tr,
                  textcolor: whiteColor,
                  color: primaryColor,
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  radioListTile(Data data) {
    return RadioListTile(
      value: data,
      groupValue: provider.selectedPlan,
      onChanged: (ind) {
        setState(() {
          provider.selectedPlan = ind!;
        });
      },
      title: Text(data.name != null ? planName(data.name!) : ""),
    );
  }

  String planName(String name) {
    String plan = "";
    if (name == "lord-monthly") {
      plan = "Lord Monthly";
    } else if (name == "lord-quarterly") {
      plan = "Lord Quarterly";
    } else if (name == "lord-yearly") {
      plan = "Lord Yearly";
    } else if (name == "king-monthly") {
      plan = "King Monthly";
    } else if (name == "king-quarterly") {
      plan = "King Quarterly";
    } else if (name == "king-yearly") {
      plan = "King Yearly";
    } else if (name == "god-monthly") {
      plan = "God Monthly";
    } else if (name == "god-quarterly") {
      plan = "God Quarterly";
    } else if (name == "god-yearly") {
      plan = "God Yearly";
    }
    return plan;
  }
}
