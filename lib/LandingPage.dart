import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'RegisterPage.dart';
import 'dart:ui';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // ini penting
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // opsional, buat ngilangin tombol back
      ),


      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Responsif: Mengubah ukuran kotak tergantung ukuran layar
                  double width = constraints.maxWidth * 0.8; // 80% dari lebar layar
                  double padding = 24;
                  if (constraints.maxWidth > 600) {
                    // Lebih besar pada tablet dan desktop
                    width = 400;
                    padding = 32;
                  }

                  return Container(
                    width: 300,     // lebar tetap
                    height: 350,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5), // semi-transparan
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3), // border kaca
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [///////////////////////////////////////////////////
                        SizedBox(height: 45),
                        Text(
                          "Inventory Buat Bolo Yang Jis Jos",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 75),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(200, 50),
                            backgroundColor: Colors.green[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 10),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(200, 50),
                            side: BorderSide(color: Colors.green[700]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
