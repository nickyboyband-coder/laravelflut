import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nicnic/models/product.dart';
import 'package:nicnic/services/api_service.dart';



class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final hargaController = TextEditingController();
  final stockController = TextEditingController();
  final deskripsiController = TextEditingController();

  final ApiService api = ApiService();
  bool loading = false;
  File? image;
  final picker = ImagePicker();

  Future<void> pilihGambar() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  Future<void> simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      loading = true;
    });

    Product product = Product(
      nama: namaController.text,
      harga: int.parse(hargaController.text),
      stock: int.parse(stockController.text),
      deskripsi: deskripsiController.text,
    );

    bool berhasil = await api.storeProduct(product,image);

    setState(() {
      loading = false;
    });

    if (berhasil) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produk berhasil ditambahkan!")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menambahkan produk")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Produk"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: pilihGambar,
                child: image == null
                    ? Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.add_a_photo, size: 60),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          image!,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: namaController,
                    decoration: const InputDecoration(
                      labelText: "Nama Produk",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.shopping_bag),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Nama wajib diisi"
                        : null,
                  ),
                  const SizedBox(height: 20),

                  // Harga Produk
                  TextFormField(
                    controller: hargaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Harga Produk",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.money),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Harga wajib diisi"
                        : null,
                  ),
                  const SizedBox(height: 20),

                  // Stok Produk
                  TextFormField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Stok Produk",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inventory),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Stok wajib diisi"
                        : null,
                  ),
                  const SizedBox(height: 20),

                  // Deskripsi Produk
                  TextFormField(
                    controller: deskripsiController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: "Deskripsi Produk",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Deskripsi wajib diisi"
                        : null,
                  ),
                  const SizedBox(height: 30),

                  // Tombol Simpan
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: loading ? null : simpanData,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (loading)
                            const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          else
                            const Icon(Icons.save),
                          const SizedBox(width: 10),
                          Text(loading ? "Menyimpan..." : "Simpan"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}