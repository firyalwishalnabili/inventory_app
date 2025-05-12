import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'HomePage.dart';
import 'dart:ui';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  Future<void> _login() async {
    setState(() => loading = true);

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      setState(() => loading = false);

      if (response.session != null && response.user != null) {
        // Bersihkan form hanya kalau berhasil login
        emailController.clear();
        passwordController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login berhasil!"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          ),

        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login gagal. Periksa email & password"),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          ),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Salah Bolo"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        ),


      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(top: 20),  // Menambahkan margin atas
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding di dalam container
          width: 250, // Mengatur lebar judul AppBar
          decoration: BoxDecoration(
            color: Colors.green[700],  // Warna background container
            borderRadius: BorderRadius.circular(24), // Sudut membulat
          ),
          child: Center(  // Menempatkan teks di tengah
            child: Text(
              "Halaman Login",
              style: TextStyle(
                color: Colors.white,        // Warna teks
                fontSize: 24,               // Ukuran teks
                fontWeight: FontWeight.bold, // Ketebalan teks
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // Membuat AppBar transparan
        elevation: 0,  // Menghilangkan shadow pada AppBar
        toolbarHeight: 80,  // Sesuaikan tinggi toolbar jika perlu
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.transparent, // Membuat fleksibel space transparan
          ),
        ),
        centerTitle: true, // Menengahkan container
        leading: Padding(
          padding: EdgeInsets.only(left: 16), // Mengatur posisi tombol back lebih ke kanan
          child: IconButton(
            icon: Container(
              margin: EdgeInsets.only(top: 16), // Atur jarak dari atas
              width: 40, // Ukuran bulat tombol
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red, // Warna tombol
                shape: BoxShape.circle, // Membuat bentuk bulat
              ),
              child: Icon(
                Icons.arrow_back, // Ikon back button
                color: Colors.white, // Warna ikon
              ),
            ),

            onPressed: () {
              Navigator.pop(context); // Fungsi tombol back
            },
          ),
        ),
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
                  double width = constraints.maxWidth * 0.8;
                  double padding = 24;
                  if (constraints.maxWidth > 600) {
                    width = 400;
                    padding = 32;
                  }

                  return Container(
                    width: 300,
                    height: 350,
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 45),
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: "Masukkan email kamu",
                            hintStyle: TextStyle(color: Colors.grey[700]),
                            filled: true,
                            fillColor: Colors.green[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.email, color: Colors.black),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          autocorrect: false,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: "Masukkan password kamu",
                            hintStyle: TextStyle(color: Colors.grey[700]),
                            filled: true,
                            fillColor: Colors.green[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.lock, color: Colors.black),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                          ),
                        ),
                        SizedBox(height: 50),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(200, 50),
                            backgroundColor: Colors.green[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: loading ? null : _login,
                          child: loading
                              ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              : Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
