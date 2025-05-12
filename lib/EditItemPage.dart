import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';

class EditItemPage extends StatefulWidget {
  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final supabase = Supabase.instance.client;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController namaController;
  late TextEditingController kategoriController;
  late TextEditingController stokController;
  late TextEditingController hargaController;
  late TextEditingController deskripsiController;

  late int itemId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final item = ModalRoute
        .of(context)!
        .settings
        .arguments as Map<String, dynamic>;

    itemId = item['id'];
    namaController = TextEditingController(text: item['nama_barang']);
    kategoriController = TextEditingController(text: item['kategori']);
    stokController =
        TextEditingController(text: item['jumlah_stok'].toString());
    hargaController = TextEditingController(text: item['harga'].toString());
    deskripsiController = TextEditingController(text: item['deskripsi']);
  }

  Future<void> updateItem() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await supabase.from('barang_app_inv').update({
        'nama_barang': namaController.text,
        'kategori': kategoriController.text,
        'jumlah_stok': int.parse(stokController.text),
        'harga': int.parse(hargaController.text),
        'deskripsi': deskripsiController.text,
      }).eq('id', itemId);

      print('✅ Updated: $response');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Barang berhasil diperbarui')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('❌ Error update: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update barang')),
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
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: 250,
          decoration: BoxDecoration(
            color: Colors.green[700],
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              "Edit Barang",
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
                  padding: EdgeInsets.fromLTRB(24, 16, 24, 24), // Top-nya lebih kecil dari sebelumnya
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
                          onPressed: updateItem,
                          child: Text(
                            "Simpan Perubahan",
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
