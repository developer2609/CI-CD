import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  ObxotPage(),
    );
  }
}



class ObxotPage extends StatefulWidget {
  const ObxotPage({super.key});

  @override
  State<ObxotPage> createState() => _ObxotPageState();
}

class _ObxotPageState extends State<ObxotPage> {
  List<File> _takenPhotos = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Obxot")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CameraScreen()),
              );

              if (result != null && result is List<File>) {
                // Qaytgan rasm fayllarini saqlang
                print("Rasm(lar) soni: ${result.length}");
              }
            },
            child: const Text("Obxot to‘ldirish"),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _takenPhotos
                .map((file) => Image.file(
              file,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(camera, ResolutionPreset.medium);
    await _cameraController.initialize();

    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<void> _takePicture() async {
    final XFile file = await _cameraController.takePicture();
    final File image = File(file.path);

    setState(() {
      _images.add(image);
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Rasmga olish"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, _images);
            },
            child: const Text("Tayyor", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Column(
        children: [
          if (_isCameraInitialized)
            CameraPreview(_cameraController)
          else
            const Expanded(child: Center(child: CircularProgressIndicator())),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _takePicture,
            icon: const Icon(Icons.camera_alt),
            label: const Text("Rasmga olish"),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _images
                    .map((file) => Image.file(
                  file,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ))
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
