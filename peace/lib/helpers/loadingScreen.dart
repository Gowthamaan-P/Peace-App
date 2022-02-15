import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class OverlayLoader extends StatefulWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (_) => OverlayLoader(key: key),
  ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  OverlayLoader({Key? key}) : super(key: key);

  @override
  _OverlayLoaderState createState() => _OverlayLoaderState();
}

class _OverlayLoaderState extends State<OverlayLoader> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: SizedBox(
          height: height/2,
          width: width/2,
          child: RiveAnimation.asset(
            'assets/images/loader.riv',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}