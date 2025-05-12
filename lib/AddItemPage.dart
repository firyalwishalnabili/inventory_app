import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final kategoriController = TextEditingController();
  final stokController = TextEditingController();
  final hargaController = TextEditingController();
  final deskripsiController = TextEditingController();

  bool isLoading = false;

  Future<void> addItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await supabase.from('barang_app_inv').insert({
        'nama_barang': namaController.text,
        'kategori': kategoriController.text,
        'jumlah_stok': int.parse(stokController.text),
        'harga': int.parse(hargaController.text),
        'deskripsi': deskripsiController.text,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Barang berhasil ditambahkan')),
      );

      // Reset form
      namaController.clear();
      kategoriController.clear();
      stokController.clear();
      hargaController.clear();
      deskripsiController.clear();
    } catch (e) {
      print('❌ Error insert: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan barang')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    kategoriController.dispose();
    stokController.dispose();
    hargaController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: 250,
          decoration: BoxDecoration(
            color: Colors.green[700],
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              "Tambah Barang",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(left: 16),
          child: IconButton(
            icon: Container(
              margin: EdgeInsets.only(top: 16),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
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
        child: SafeArea(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  width: 300,
                  padding: EdgeInsets.fromLTRB(24, 16, 24, 24), // Sama seperti Edit Barang
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        buildInput("Nama Barang", namaController),
                        SizedBox(height: 16),
                        buildInput("Kategori", kategoriController),
                        SizedBox(height: 16),
                        buildInput("Jumlah Stok", stokController, isNumber: true),
                        SizedBox(height: 16),
                        buildInput("Harga", hargaController, isNumber: true),
                        SizedBox(height: 16),
                        buildInput("Deskripsi", deskripsiController, maxLines: 3),
                        SizedBox(height: 32),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(200, 50),
                            side: BorderSide(color: Colors.green[700]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: isLoading ? null : addItem,
                          child: isLoading
                              ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                            ),
                          )
                              : Text(
                            "Simpan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInput(String label, TextEditingController controller,
      {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      validator: (val) => (val == null || val.isEmpty) ? 'Wajib diisi' : null,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        hintText: "Masukkan $label",
        hintStyle: TextStyle(color: Colors.grey[700]),
        filled: true,
        fillColor: Colors.green[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      ),
    );
  }
}

