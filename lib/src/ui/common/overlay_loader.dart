import 'package:flutter/material.dart';

class OverlayLoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        child: SizedBox(
          width: 80,
          height: 80,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation(
                    Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
