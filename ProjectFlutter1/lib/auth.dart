import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projectflutter1/home.dart';


class AuthenticationController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = "".obs;
  final errorEmail = "".obs;
  final errorPassword = "".obs;

  Future<void> Register({
    required String Username,
    required String Provinsi,
    required String Kabupaten,
    required String Kecamatan,
    required String Detail_alamat,
    required String Phone_number,
    required String Email,
    required String Password,
    required String Konfirmasi_Password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        "nama_member": Username,
        "provinsi": Provinsi,
        "kabupaten": Kabupaten,
        "kecamatan": Kecamatan,
        "detail_alamat": Detail_alamat,
        "no_hp": Phone_number,
        "email": Email,
        "password": Password,
        "konfirmasi_password": Konfirmasi_Password
      };

      var response = await http.post(
        Uri.parse("http://192.168.1.6:80/api/auth/register"),
        headers: {
          "Accept": "application/json"
        },
        body: data,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        var responseData = jsonDecode(response.body);
        errorMessage.value = "Register SUCCESS";
        debugPrint(responseData.toString());
      } else {
        isLoading.value = false;
        var responseData = jsonDecode(response.body);
        Get.snackbar("Error",
            responseData.toString(),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        errorEmail.value = "Error: " + responseData["email"].toString();
        errorMessage.value = "Error: The all Field is Required";
        errorPassword.value = "Error: " + responseData["password"].toString();
        debugPrint('Error: $responseData');
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint('Exception: ${e.toString()}');
    }
  }

  Future<void> Login({
    required String Email,
    required String Password,
  }) async {
    try {
      isLoading.value = true;
      var data = {
        "email": Email,
        "password": Password,
      };

      var response = await http.post(
        Uri.parse("http://192.168.1.6:80/api/auth/login_member"),
        headers: {
          "Accept": "application/json"
        },
        body: data,
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if(responseData["message"].toString() == "success") {
          isLoading.value = false;
          Get.offAll(() => const HomePage());
        }else{
          isLoading.value = false;
          var responseData = jsonDecode(response.body);
          Get.snackbar("Error",
              responseData.toString(),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white);
          debugPrint(responseData.toString());
        }
      } else {
        isLoading.value = false;
        var responseData = jsonDecode(response.body);
        Get.snackbar("Error",
        responseData.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white);
        debugPrint('Error: $responseData');
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint('Exception: ${e.toString()}');
    }
  }
}
