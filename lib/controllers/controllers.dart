
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:elearning/models/models.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/service/services.dart';
import 'package:elearning/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'course_controller.dart';
part 'user_controller.dart';
part 'category_controller.dart';