import 'package:flutter/material.dart';

class TemporaryDown extends StatelessWidget {
  const TemporaryDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text("currently only available on desktop/laptop"),
            )
          ],
        ),
      ),
    );
  }
}
