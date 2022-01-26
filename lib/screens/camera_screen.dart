import 'package:apptest/screens/image_preview_screen.dart';
import 'package:apptest/utils/navigation.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CamerScreen extends StatefulWidget {
  const CamerScreen({Key? key}) : super(key: key);

  @override
  _CamerScreenState createState() => _CamerScreenState();
}

class _CamerScreenState extends State<CamerScreen> with WidgetsBindingObserver {
  CameraController? controller;
  List<CameraDescription> cameras = [];
  bool cameraLoaded = false;
  CameraDescription? frontCamera;
  CameraDescription? rearCamera;
  bool isRear = false;
  bool isFront = false;
  // bool flashMenu = false;

  bool flashOff = true;
  bool flashOn = false;
  bool flashAuto = false;
  bool flashLight = false;

  XFile? image;

  @override
  void initState() {
    getCameras();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
    // TODO: implement initState
    super.initState();
    print('back again');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);

    controller?.dispose();
    super.dispose();
  }

  void getCameras() {
    availableCameras().then((value) {
      cameras = value;
      for (CameraDescription c in cameras) {
        if (c.lensDirection == CameraLensDirection.back) {
          rearCamera = c;
        } else if (c.lensDirection == CameraLensDirection.front) {
          frontCamera = c;
        }
      }
      print('Camera ' + cameras.length.toString());
      controller = CameraController(rearCamera!, ResolutionPreset.ultraHigh);
      controller!.initialize().then((value) {
        setState(() {
          cameraLoaded = true;
          isRear = true;
        });
      });
    });
  }

  void changeCamera() async {
    if (controller != null) {
      await controller!.dispose();
    }
    if (isRear) {
      controller = CameraController(frontCamera!, ResolutionPreset.ultraHigh);
      controller!.initialize().then((value) {
        setState(() {
          isFront = true;
          isRear = false;
        });
      });
    } else if (isFront) {
      controller = CameraController(rearCamera!, ResolutionPreset.ultraHigh);
      controller!.initialize().then((value) {
        setState(() {
          isFront = false;
          isRear = true;
        });
      });
    }
  }

  void setFlashMode() {
    if (flashAuto) {
      controller?.setFlashMode(FlashMode.auto);
    } else if (flashOn) {
      controller?.setFlashMode(FlashMode.always);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('1');
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onCameraResume();
    }
    // TODO: implement didChangeAppLifecycleState
    // super.didChangeAppLifecycleState(state);
  }

  void onCameraResume() async {
    if (controller != null) {
      await controller!.dispose();
    }
    if (isRear) {
      controller = CameraController(rearCamera!, ResolutionPreset.ultraHigh);
      controller!.initialize().then((value) {
        setState(() {});
      });
    }
    if (isFront) {
      controller = CameraController(frontCamera!, ResolutionPreset.ultraHigh);
      controller!.initialize().then((value) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final mediaSize = MediaQuery.of(context).size;
    final scale = (controller != null)
        ? 1 / (controller!.value.aspectRatio * mediaSize.aspectRatio)
        : 1.0;

    return Scaffold(
      body: SafeArea(
        child: cameraLoaded
            ? Stack(children: [
                Container(
                  width: double.infinity,
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.topCenter,
                    child: CameraPreview(controller!),
                  ),
                ),
                Column(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    GestureDetector(
                      onTap: () => AppNavigation.popScreen(context),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.2),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (flashOff) {
                                      flashOn = true;

                                      flashOff = false;
                                    } else {
                                      flashOn = false;

                                      flashOff = true;
                                    }

                                    // controller?.setFlashMode(FlashMode.always);
                                  });
                                },
                                child: flashOn
                                    ? Icon(
                                        Icons.flash_on,
                                        color: Colors.white,
                                      )
                                    : Icon(
                                        Icons.flash_off,
                                        color: Colors.white,
                                      ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Camera',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (!flashLight && !flashOff) {
                                setFlashMode();
                              }

                              controller?.takePicture().then((img) async {
                                image = img;
                                // controller?.setFlashMode(FlashMode.always);
                                if (!flashLight) {
                                  controller?.setFlashMode(FlashMode.off);
                                }

                                AppNavigation.pushToScreen(context,
                                    screen: ImagePreview(image!));
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  border: Border.all(
                                      color: Colors.white, width: 4)),
                            ),
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  changeCamera();
                                },
                                child: Icon(
                                  Icons.cameraswitch,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final ImagePicker _picker = ImagePicker();
                                  final XFile? image = await _picker.pickImage(
                                      source: ImageSource.gallery);
                                  if (image != null) {
                                    AppNavigation.pushToScreen(context,
                                        screen: ImagePreview(image));
                                  }
                                },
                                child: Text(
                                  'Gallery',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
              ])
            : Container(
                width: double.infinity,
                color: Colors.black,
              ),
      ),
    );
  }
}

T? _ambiguate<T>(T? value) => value;
