import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Uint8List?> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
      ?.buffer
      .asUint8List();
}

Future<BitmapDescriptor> getImageBitMapFromPath(String path,
    [int width = 64]) async {
  final imageBytes = await getBytesFromAsset(path, width);
  final imageBitMap = BitmapDescriptor.fromBytes(imageBytes!);

  return imageBitMap;
}

Future<BitmapDescriptor> getImageBitMapFromCategory(String category) async {
  String path = 'images/';

  switch (category) {
    case 'Lodging':
      {
        path += 'lodging.png';
      }
      break;
    case 'Entertainment + Lifestyle':
      {
        path += 'entertainment.png';
      }
      break;
    case 'DIY Events':
      {
        path += 'diy.png';
      }
      break;
    case 'Commercial':
      {
        path += 'commercial.png';
      }
      break;
    case 'Outdoor Adventures':
      {
        path += 'outdoor.png';
      }
      break;
    case 'Pop-Up Space':
      {
        path += 'pop_up_space.png';
      }
      break;
    case 'Health + Wellness':
      {
        path += 'health.png';
      }
      break;
    case 'DIY Tool':
      {
        path += 'tools.png';
      }
      break;

    default:
      {
        throw 'Category not found';
      }
  }

  final imageBytes = await getBytesFromAsset(path, 64);
  final imageBitMap = BitmapDescriptor.fromBytes(imageBytes!);

  return imageBitMap;
}
