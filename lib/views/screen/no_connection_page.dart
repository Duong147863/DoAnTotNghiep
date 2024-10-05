import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.error_outline,
                size: 100,
                color: Colors.deepPurple,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Oops, something went wrong',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.canPop(context);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
                ),
                child: const Text(
                  'Back',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
