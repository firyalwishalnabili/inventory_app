import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchItems();
  }

  Future<void> fetchItems() async {
    setState(() => isLoading = true);
    try {
      final response = await supabase
          .from('barang_app_inv')
          .select('*')
          .order('id', ascending: true);

      setState(() {
        items = List<Map<String, dynamic>>.from(response);
        filteredItems = items;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal ambil data')),
      );
    }
  }

  void filterItems(String query) {
    final results = items.where((item) {
      final name = item['nama_barang'].toString().toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchQuery = query;
      filteredItems = results;
    });
  }

  Future<void> deleteItem(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Konfirmasi Hapus',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.red,
          ),
        ),
        content: Text(
          'Yakin ingin menghapus item ini?',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 10),
        actions: [
          Padding(
            padding: EdgeInsets.only(bottom: 30), // Memberikan margin bawah
            child: TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
              ),
              child: Text('Batal'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30), // Margin bawah
            child: TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: Text('Hapus'),
            ),
          ),
        ],
      ),
    );

  if (confirm == true) {
      try {
        await supabase.from('barang_app_inv').delete().eq('id', id);
        fetchItems();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item berhasil dihapus')),
        );
      } catch (e) {
        print('❌ Error delete: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus item')),
        );
      }
    }
  }

  Future<void> logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Konfirmasi Logout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.red,
          ),
        ),
        content: Text(
          'Yakin ingin keluar?',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 10),
        actions: [
          Padding(
            padding: EdgeInsets.only(bottom: 30), // Memberikan margin bawah
            child: TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
              ),
              child: Text('Batal'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30), // Memberikan margin bawah
            child: TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              child: Text('Logout'),
            ),
          ),
        ],
      ),
    );

  if (confirm == true) {
      try {
        await supabase.auth.signOut();
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        print('❌ Error logout: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal logout')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disable back button (Android)
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false, // Menonaktifkan tombol back
          backgroundColor: Colors.transparent, // Membuat background transparan
          elevation: 0,
          toolbarHeight: 80, // Menambah tinggi app bar
          title: Container(
            margin: EdgeInsets.only(left: 60, right: 0), // Margin kiri-kanan bisa disesuaikan
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green[700], // Warna hijau untuk container
              borderRadius: BorderRadius.circular(12), // Rounded corner
            ),
            child: Center(
              child: Text(
                'Dashboard', // Ganti judul sesuai kebutuhan
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
            ),
          ),
          centerTitle: true, // Menyelarakan judul di tengah
          actions: [
            // Tombol Refresh
            Container(
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.blue, // Tombol Refresh warna biru
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: fetchItems,
              ),
            ),

            // Tombol Logout
            Container(
              margin: EdgeInsets.only(right: 85),
              decoration: BoxDecoration(
                color: Colors.red, // Tombol Logout warna merah
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: Icon(Icons.logout, color: Colors.white),
                onPressed: logout,
              ),
            ),
          ],
        ),




        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                  child: TextField(
                    onChanged: filterItems,
                    decoration: InputDecoration(
                      hintText: 'Cari barang...',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : filteredItems.isEmpty
                      ? Center(child: Text('Tidak ada data ditemukan.'))
                      : RefreshIndicator(
                    onRefresh: fetchItems,
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      padding: EdgeInsets.only(bottom: 100),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 80, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['nama_barang'] ?? 'Tanpa Nama',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Stok: ${item['jumlah_stok']}   Kategori: ${item['kategori']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: (int.tryParse(
                                        item['jumlah_stok']
                                            .toString()) ??
                                        0) <
                                        5
                                        ? Colors.red
                                        : Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  item['deskripsi'] ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Rp ${item['harga']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color: Colors.blueAccent),
                                  onPressed: () async {
                                    await Navigator.pushNamed(
                                      context,
                                      '/editItem',
                                      arguments: item,
                                    );
                                    fetchItems();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    deleteItem(item['id']);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.pushNamed(context, '/addItem');
            fetchItems();
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
          backgroundColor: Colors.green[700],
          tooltip: 'Tambah Barang',
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      ),
    );
  }
}
