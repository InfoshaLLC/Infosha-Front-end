import 'dart:convert';

// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/Controller/Viewmodel/userviewmodel.dart';
import 'package:infosha/config/const.dart';
import 'package:infosha/screens/home/home_screen.dart';
import 'package:infosha/utils/error_boundary.dart';
import 'package:infosha/views/colors.dart';
import 'package:infosha/views/ui_helpers.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SubscriptionPayment extends StatefulWidget {
  String paymentLink;
  bool isNewUser;
  SubscriptionPayment({super.key, required this.paymentLink, required this.isNewUser});

  @override
  State<SubscriptionPayment> createState() => _SubscriptionPaymentState();
}

class _SubscriptionPaymentState extends State<SubscriptionPayment> {
  late WebViewController controller;
  bool isLoading = true;
  late UserViewModel provider;

  @override
  void initState() {
    provider = Provider.of<UserViewModel>(context, listen: false);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // ..setOnConsoleMessage((message) async {
      //   print('${message.level}: ${message.message} (${message.toString()})');
      //   var response = json.decode(message.toString());
      //   print("response ==> 1 ${response}");
      //   var response1 = json.decode(response);
      //   print("response ==> 2 $response1");
      // })
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              isLoading = true;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) async {
            final response = await controller.runJavaScriptReturningResult("document.documentElement.innerText");
            String? responseString;

            if (response is String) {
              responseString = response;
            } else {
              responseString = response.toString();
            }

            try {
              var responseData = json.decode(responseString);
              // If the decoded data is itself a JSON-encoded string, decode again
              var checkjson = responseData is String ? json.decode(responseData) : responseData;
              if (checkjson != null && checkjson is Map<String, dynamic>) {
                if (checkjson["message"] == "Subscription create successfully") {
                  provider.userModel = await provider.getUserProfileById(Params.UserToken);
                  Get.offAll(() => const HomeScreen());
                  UIHelper.showMySnak(title: "Subscription", message: "Subscription create successfully".tr, isError: false);
                } else {
                  provider.userModel = await provider.getUserProfileById(Params.UserToken);
                  Get.offAll(() => const HomeScreen());
                  UIHelper.showMySnak(title: "Subscription", message: checkjson["message"].tr, isError: true);
                }
              }
            } catch (e) {
              print("Error parsing response: $e");
            }

            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            print("url ==> 1 ${request}");

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentLink));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      child: Scaffold(body: SafeArea(
          child: /* isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: baseColor))
                  : */
              Consumer<UserViewModel>(builder: (context, provider, child) {
        return WebViewWidget(controller: controller);
      }) /* WebViewWidget(controller: controller) */)),
    );
  }
}
