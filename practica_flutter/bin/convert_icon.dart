import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

void main() async {
  // Inicializar Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Crear un widget para renderizar el SVG
  final svg = SvgPicture.asset(
    'assets/icons/app_icon.svg',
    width: 1024,
    height: 1024,
  );

  // Crear un widget con RepaintBoundary
  final widget = RepaintBoundary(
    child: Container(
      width: 1024,
      height: 1024,
      child: svg,
    ),
  );

  // Crear un pipeline de renderizado
  final pipelineOwner = PipelineOwner();
  final buildOwner = BuildOwner(focusManager: FocusManager());
  
  // Crear un RenderBox concreto
  final renderBox = RenderConstrainedBox(
    additionalConstraints: const BoxConstraints.tightFor(width: 1024, height: 1024),
  );

  // Crear el elemento raíz
  final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
    container: renderBox,
    child: widget,
  ).attachToRenderTree(buildOwner);

  // Forzar el layout
  buildOwner.buildScope(rootElement);
  buildOwner.finalizeTree();

  pipelineOwner.flushLayout();
  pipelineOwner.flushCompositingBits();
  pipelineOwner.flushPaint();

  // Encontrar el RepaintBoundary
  final renderObject = rootElement.findRenderObject();
  if (renderObject == null) {
    print('No se pudo encontrar el RenderObject');
    return;
  }

  // Buscar el RepaintBoundary en el árbol de renderizado
  RenderRepaintBoundary? boundary;
  void visit(RenderObject object) {
    if (object is RenderRepaintBoundary) {
      boundary = object;
      return;
    }
    object.visitChildren(visit);
  }
  visit(renderObject);

  if (boundary == null) {
    print('No se pudo encontrar el RepaintBoundary');
    return;
  }

  // Convertir a imagen
  final image = await boundary!.toImage(pixelRatio: 1.0);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer.asUint8List();

  // Guardar el archivo
  final file = File('assets/icons/app_icon.png');
  await file.writeAsBytes(buffer);
} 