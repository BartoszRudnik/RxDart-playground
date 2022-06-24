import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rx_dart/loading/loading_screen_controller.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static late final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? loadingScreenController;

  LoadingScreenController _showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                minWidth: size.width * 0.5,
                maxHeight: size.height * 0.8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    StreamBuilder<String>(
                      stream: _text.stream,
                      builder: (context, snapshot) => snapshot.hasData
                          ? Text(
                              snapshot.requireData,
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    final state = Overlay.of(context);
    state?.insert(overlay);

    return LoadingScreenController(
      closeLoadingScreen: () {
        _text.close();
        overlay.remove();

        return true;
      },
      updateLoadingScreen: (String newValue) {
        _text.add(newValue);

        return true;
      },
    );
  }
}
