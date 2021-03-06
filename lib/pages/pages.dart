import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:elearning/controllers/controllers.dart';
import 'package:elearning/models/models.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/service/services.dart';
import 'package:elearning/shared/shared.dart';
import 'package:elearning/theme.dart';
import 'package:elearning/utils/youtube_utils.dart';
import 'package:elearning/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:video_player/video_player.dart';
import './course_form.dart';

part '../home_page.dart';
part 'course_detail.dart';
part 'courses_page.dart';
part 'dashboard.dart';
part 'login_page.dart';
part 'register_page.dart';
