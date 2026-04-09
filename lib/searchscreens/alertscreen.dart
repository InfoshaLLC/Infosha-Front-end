import 'package:flutter/material.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(),
          ElevatedButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                //      shadowColor: Colors.transparent,
                elevation: 0,
                shape: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(25),
                ),
                title: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: const Text(
                        'Are you sure you want to delete?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                    ),
                  ],
                ),
                //Ye wala code delete ker lena GOD screen ke liye is text ki zaroorat nahi
                //(
                content: const Text(
                  'In order to delete this comment, you have to purchase status subscriptions ',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                //)
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xff1B2870),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xff1B2870),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
