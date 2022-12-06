import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reto_4/controladores/controladorGeneral.dart';
import 'package:reto_4/interfaz/home.dart';

void main() {
  Get.put(controladorGeneral());
  runApp(const MyApp());
}
