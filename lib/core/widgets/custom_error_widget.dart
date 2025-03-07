import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key, required this.details});
  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Transform.scale(
        scale: .9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              color: Colors.grey.shade300,
              size: 42,
            ),
            SizedBox(height: 12,),
            Container(
              color: Colors.black,
              alignment: AlignmentDirectional.center,
              child: Text('Something went wrong:\n${details.exception}',
                  style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 22,
                      fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
