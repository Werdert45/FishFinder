import 'package:flutter/cupertino.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:async';
import 'package:image/image.dart' as Image;


//// Calculate dominant color from ImageProvider
//Future<Color> getImagePalette(image) async {
//  final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImage(image);
//
//
//  print(paletteGenerator);
//  return paletteGenerator.dominantColor.color;
//}