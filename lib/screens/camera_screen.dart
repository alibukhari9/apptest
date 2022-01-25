import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
  bool flashMenu = false;
  bool timerMenu = false;
  bool isPhoto = true;
  bool isVideo = true;
  bool flashOff = true;
  bool flashOn = false;
  bool flashAuto = false;
  bool flashLight = false;
  bool isRecording = false;
  bool showTimer = false;
  String timer = '0';
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
                GestureDetector(
                    onHorizontalDragEnd: (DragEndDetails details) {
                      if (details.primaryVelocity! > 0) {
                        // User swiped Left
                        // setState(() {
                        //   isPhoto = !isPhoto;
                        // });
                        if (isPhoto) {
                          Navigator.pop(context);
                        } else if (isVideo) {
                          setState(() {
                            isPhoto = true;
                            isVideo = false;
                          });
                        }
                        // /print('Going Left');
                      } else if (details.primaryVelocity! < 0) {
                        // User swiped Right

                        // Navigator.pop(context);
                        if (isPhoto) {
                          setState(() {
                            isVideo = true;
                            isPhoto = false;
                          });
                        }
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      child: Transform.scale(
                        scale: scale,
                        alignment: Alignment.topCenter,
                        child: CameraPreview(controller!),
                      ),
                    )
                    // onPanUpdate: (details) {
                    //   // Swiping in right direction.
                    //   if (details.delta.dx > 0) {
                    //     print('Going Right');
                    //   }

                    //   // Swiping in left direction.
                    //   if (details.delta.dx < 0) {
                    //     print('Going Left');
                    //   }
                    // },
                    ),
                Column(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          // height: 200,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          color: Colors.white.withOpacity(0.2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    flashMenu = !flashMenu;
                                    if (timerMenu) {
                                      timerMenu = false;
                                    }
                                  });
                                },
                                child: Image.asset(
                                  'assets/images/flash.png',
                                  height: 20,
                                ),
                              ),
                              Text(
                                'HDR',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    timerMenu = !timerMenu;
                                    if (flashMenu) {
                                      flashMenu = false;
                                    }
                                  });
                                },
                                child: Image.asset(
                                  'assets/images/time.png',
                                  height: 20,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  changeCamera();
                                },
                                child: Image.asset(
                                  'assets/images/rotate-camera.png',
                                  height: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                        getFlashMenu(),
                        getTimerMenu(),
                      ],
                    ),
                    // Visibility(
                    //   visible: showTimer,
                    //   child: Countdown(
                    //       seconds: int.parse(timer),
                    //       build: (c, n) {
                    //         return Text(
                    //           n.ceil().toString(),
                    //           textScaleFactor: 3.0,
                    //           style: TextStyle(color: Colors.white),
                    //         );
                    //       }),
                    // ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (isPhoto)
                              ? Image.asset(
                                  'assets/images/folder.png',
                                  height: 30,
                                )
                              : Image.asset(
                                  'assets/images/camera.png',
                                  height: 30,
                                ),
                          isPhoto
                              ? GestureDetector(
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
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (c) =>
                                      //         ImageDialog(File(img.path)));
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (c) => ImagePreview(image!)));
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
                                )
                              : (!isRecording)
                                  ? GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                            border: Border.all(
                                                color: Colors.white, width: 4)),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 4)),
                                        child: Container(
                                          color: Colors.red,
                                          height: 10,
                                          width: 10,
                                        ),
                                      ),
                                    ),
                          isPhoto
                              ? Image.asset(
                                  'assets/images/video cam.png',
                                  height: 30,
                                )
                              : SizedBox(
                                  width: 30,
                                ),
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

  Widget getFlashMenu() {
    return Visibility(
      visible: flashMenu,
      child: Container(
        color: Colors.black.withOpacity(0.2),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  flashOn = true;
                  flashAuto = false;
                  flashOff = false;
                  flashLight = false;
                  // controller?.setFlashMode(FlashMode.always);
                });
              },
              child: Column(
                children: [
                  Image.asset(
                    flashOn
                        ? 'assets/images/flash-on2.png'
                        : 'assets/images/flash-on.png',
                    height: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'ON',
                    style: TextStyle(
                        color: flashOn ? Colors.yellow : Colors.white),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  flashOn = false;
                  flashAuto = false;
                  flashOff = true;
                  flashLight = false;
                  controller?.setFlashMode(FlashMode.off);
                });
              },
              child: Column(
                children: [
                  Image.asset(
                    flashOff
                        ? 'assets/images/flash-off2.png'
                        : 'assets/images/flash-off.png',
                    height: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'OFF',
                    style: TextStyle(
                        color: flashOff ? Colors.yellow : Colors.white),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  flashOn = false;
                  flashAuto = true;
                  flashOff = false;
                  flashLight = false;
                  // controller?.setFlashMode(FlashMode.auto);
                });
              },
              child: Column(
                children: [
                  Image.asset(
                    flashAuto
                        ? 'assets/images/flash-auto2.png'
                        : 'assets/images/flash-auto.png',
                    height: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'AUTO',
                    style: TextStyle(
                        color: flashAuto ? Colors.yellow : Colors.white),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  flashOn = false;
                  flashAuto = false;
                  flashOff = false;
                  flashLight = true;
                  controller?.setFlashMode(FlashMode.torch);
                });
              },
              child: Column(
                children: [
                  Image.asset(
                    flashLight
                        ? 'assets/images/flash-light2.png'
                        : 'assets/images/flash-light.png',
                    height: 20,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'FLASH',
                    style: TextStyle(
                        color: flashLight ? Colors.yellow : Colors.white),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTimerMenu() {
    return Visibility(
        visible: timerMenu,
        child: Container(
          color: Colors.black.withOpacity(0.2),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    timer = '0';
                  });
                },
                child: Text(
                  '0 sec',
                  style: TextStyle(
                      color: timer == '0' ? Colors.yellow : Colors.white),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    timer = '3';
                  });
                },
                child: Text(
                  '3 sec',
                  style: TextStyle(
                      color: timer == '3' ? Colors.yellow : Colors.white),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    timer = '5';
                  });
                },
                child: Text(
                  '5 sec',
                  style: TextStyle(
                      color: timer == '5' ? Colors.yellow : Colors.white),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    timer = '10';
                  });
                },
                child: Text(
                  '10 sec',
                  style: TextStyle(
                      color: timer == '10' ? Colors.yellow : Colors.white),
                ),
              )
            ],
          ),
        ));
  }
}

class _MediaSizeClipper extends CustomClipper<Rect> {
  final Size mediaSize;
  const _MediaSizeClipper(this.mediaSize);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

T? _ambiguate<T>(T? value) => value;
