import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TemporaryDown extends StatelessWidget {
  const TemporaryDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 280,
              height: 100,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              decoration: BoxDecoration(
                // color: Colors.white, // Background color
                color: const Color(0xffF5F5F5), // Background color
                borderRadius:
                    BorderRadius.circular(12.0), // Rounded corners (optional)
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey
                        .withOpacity(0.5), // Shadow color with transparency
                    spreadRadius: 5, // How wide the shadow is spread
                    blurRadius: 7, // How soft the shadow is
                    offset: const Offset(
                        0, 3), // Changes position of the shadow (x, y)
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    "CU Report Rover",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff0b3f63),
                    ),
                  ),
                  Text(
                    "where events end, effortless reports begin",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff0b3f63),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Image.asset("assets/images/teamwork.gif"),
            ),
            Center(
              child: Text(
                "currently only available on desktop/laptop",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff0b3f63),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
