import 'package:flutter/material.dart';

showScaffoldMessenger(BuildContext context, String message) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.white,
    content: Text(
      message,
      style: const TextStyle(color: Colors.black),
    ),
  ));
}
