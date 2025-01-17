import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Internet_Check_Widget extends StatefulWidget {
  const Internet_Check_Widget({super.key});

  @override
  State<Internet_Check_Widget> createState() => _Internet_Check_WidgetState();
}

class _Internet_Check_WidgetState extends State<Internet_Check_Widget> {
  StreamSubscription<List<ConnectivityResult>>? subscription;
  bool isInternetConnected = true;

  @override
  void initState() {
    super.initState();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      bool isConnected =
          await InternetConnectionChecker.createInstance().hasConnection;
      setState(() {
        isInternetConnected = isConnected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isInternetConnected ? Colors.green[50] : Colors.red[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isInternetConnected ? Icons.wifi : Icons.signal_wifi_off,
              size: 100,
              color: isInternetConnected ? Colors.green : Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              isInternetConnected ? "You're online!" : "No internet connection",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isInternetConnected ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
    
  }
}
