import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';

import 'Ui/LoginPage.dart';

void main() async {
  // Usually, you need to initialize the HERE SDK only once during the lifetime of an application.
  _initializeHERESDK();
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

void _initializeHERESDK() async {
  // Needs to be called before accessing SDKOptions to load necessary libraries.
  SdkContext.init(IsolateOrigin.main);

  // Set your credentials for the HERE SDK.
  String accessKeyId = "fJcILjzNTpyAzMLaJsK0uQ";
  String accessKeySecret = "yXYB2UbMBaRIkaKvKC_N1Wa5irEVU7Bj87n1tVJXRczaC6qijqUgMyEYOGjNH7DmGdnPR7v3RtLHYsb2RxITZg";
  SDKOptions sdkOptions = SDKOptions.withAccessKeySecret(accessKeyId, accessKeySecret);

  try {
    await SDKNativeEngine.makeSharedInstance(sdkOptions);
  } on InstantiationException {
    throw Exception("Failed to initialize the HERE SDK.");
  }
}
