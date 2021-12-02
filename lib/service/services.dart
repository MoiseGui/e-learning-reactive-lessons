import 'dart:io';
// import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:elearning/models/models.dart';
import 'package:elearning/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get_connect/connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authuser_service.dart';
part 'auth_service.dart';
part 'class_service.dart';
part 'api_service.dart';
part 'quiz_service.dart';