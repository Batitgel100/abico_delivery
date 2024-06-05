import 'dart:convert';

import 'package:abico_delivery_start/globals.dart';
import 'package:abico_delivery_start/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<bool> login(
      String ip, String username, String password, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://$ip/api/auth/get_tokens?username=$username&password=$password'),
        body: {
          'username': username,
          'password': password,
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final jsonData = json.decode(responseBody);
        final userId = jsonData['uid'];
        final accessToken = jsonData['access_token'];
        final companyId = jsonData['company_id'];
        print(response.body);

        Globals.changeCompanyId(companyId);
        Globals.changeUserId(userId);
        Globals.changebaseUrl(ip);
        Globals.changeRegister(accessToken);
        print('company id : $companyId');

        return true;
      } else {
        if (response.statusCode == 404) {
          Utils.flushBarErrorMessage('Сэрвэрт алдаа гарлаа', context);
        } else {
          Utils.flushBarErrorMessage(
              'Нэвтрэх нэр эсвэл нууц үг буруу байна.', context);
        }

        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
