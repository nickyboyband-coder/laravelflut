import 'package:flutter/material.dart';
import 'package:nicnic/models/product.dart';
import 'package:nicnic/screens/add_page.dart';
import 'package:nicnic/screens/detail_product.dart';
import 'package:nicnic/screens/login_page.dart';
import 'package:nicnic/services/api_service.dart';
import 'package:nicnic/widgets/dashboard_card.dart';
import '../widgets/product_card.dart';
import 'edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService api = ApiService();
  final TextEditingController searchController = TextEditingController();

  List<Product> semuaProduk = [];
  List<Product> hasilPencarian = [];

  String filterHarga = "Semua";
  String sorting = "Nama A-Z";

  Future<void> loadProducts() async {
    try {
      final data = await api.getProducts();

      if (!mounted) return;

      setState(() {
        semuaProduk = data;
        hasilPencarian = List.from(data);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengambil data: $e"),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void prosesData() {
    List<Product> data = List.from(semuaProduk);

    final keyword = searchController.text.toLowerCase();

    if (keyword.isNotEmpty) {
      data = data.where((product) {
        return product.nama.toLowerCase().contains(keyword);
      }).toList();
    }

    if (filterHarga == "< Rp500000") {
      data = data.where((product) {
        return product.harga < 500000;
      }).toList();
    } else if (filterHarga == "Rp500000-Rp2000000") {
      data = data.where((product) {
        return product.harga >= 500000 && product.harga <= 2000000;
      }).toList();
    } else if (filterHarga == ">Rp2000000") {
      data = data.where((product) {
        return product.harga > 2000000;
      }).toList();
    }

    if (sorting == "Nama A-Z") {
      data.sort(
        (a, b) => a.nama.toLowerCase().compareTo(b.nama.toLowerCase()),
      );
    } else if (sorting == "Nama Z-A") {
      data.sort(
        (a, b) => b.nama.toLowerCase().compareTo(a.nama.toLowerCase()),
      );
    } else if (sorting == "Harga tertinggi") {
      data.sort(
        (a, b) => b.harga.compareTo(a.harga),
      );
    } else if (sorting == "Harga terendah") {
      data.sort(
        (a, b) => a.harga.compareTo(b.harga),
      );
    } else if (sorting == "Stock banyak") {
      data.sort(
        (a, b) => b.stock.compareTo(a.stock),
      );
    } else if (sorting == "Stock sedikit") {
      data.sort(
        (a, b) => a.stock.compareTo(b.stock),
      );
    }

    setState(() {
      hasilPencarian = data;
    });
  }

  void cariProduct(String keyword) {
    prosesData();
  }

  void pilihfilterHarga(String? pilihan) {
    if (pilihan == null) return;

    setState(() {
      filterHarga = pilihan;
    });
    prosesData();
  }

  void pilihsorting(String? pilihan) {
    if (pilihan == null) return;

    setState(() {
      sorting = pilihan;
    });
    prosesData();
  }

  int totalStock() {
    return semuaProduk.fold(
      0,
      (total, item) => total + item.stock,
    );
  }

  int totalHarga() {
    return semuaProduk.fold(
      0,
      (total, item) => total + (item.harga * item.stock),
    );
  }

  String formatRupiah(int angka) {
    String hasil = angka.toString();
    String result = '';
    int counter = 0;

    for (int i = hasil.length - 1; i >= 0; i--) {
      result = hasil[i] + result;
      counter++;

      if (counter == 3 && i != 0) {
        result = ".$result";
        counter = 0;
      }
    }

    return "Rp$result";
  }

  Future<void> hapusProduk(Product product) async {
    bool? konfirmasi = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: Text(
            "Apakah yakin akan menghapus ${product.nama}?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true) {
      return;
    }

    try {
      bool hasil = await api.deleteProduct(product.id!);

      if (!mounted) return;

      if (hasil) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data berhasil dihapus"),
          ),
        );

        await loadProducts();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Produk gagal dihapus"),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menghapus produk: $e"),
        ),
      );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Produk XII RPL-1"),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await api.logout();

              if (!mounted) return;

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final hasil = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddPage(),
            ),
          );

          if (hasil == true) {
            loadProducts();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: loadProducts,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hallo Admin",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Selamat datang di Aplikasi Crud XII RPL!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              controller: searchController,
              onChanged: cariProduct,
              decoration: InputDecoration(
                hintText: "Cari Produk",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          cariProduct("");
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: filterHarga,
              decoration: const InputDecoration(
                labelText: "Filter Harga",
                prefixIcon: Icon(Icons.filter_alt),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Semua",
                  child: Text("Semua Produk"),
                ),
                DropdownMenuItem(
                  value: "< Rp500000",
                  child: Text("< Rp500.000"),
                ),
                DropdownMenuItem(
                  value: "Rp500000-Rp2000000",
                  child: Text("Rp500.000 - Rp2.000.000"),
                ),
                DropdownMenuItem(
                  value: ">Rp2000000",
                  child: Text("> Rp2.000.000"),
                ),
              ],
              onChanged: pilihfilterHarga,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: sorting,
              decoration: const InputDecoration(
                labelText: "Urutkan Produk",
                prefixIcon: Icon(Icons.sort),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Nama A-Z",
                  child: Text("Nama A-Z"),
                ),
                DropdownMenuItem(
                  value: "Nama Z-A",
                  child: Text("Nama Z-A"),
                ),
                DropdownMenuItem(
                  value: "Harga tertinggi",
                  child: Text("Harga tertinggi"),
                ),
                DropdownMenuItem(
                  value: "Harga terendah",
                  child: Text("Harga terendah"),
                ),
                DropdownMenuItem(
                  value: "Stock banyak",
                  child: Text("Stock banyak"),
                ),
                DropdownMenuItem(
                  value: "Stock sedikit",
                  child: Text("Stock sedikit"),
                ),
              ],
              onChanged: pilihsorting,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: DashboardCard(
                    title: "Product",
                    value: "${semuaProduk.length}",
                    icon: Icons.shopping_bag,
                    color: Colors.indigo,
                  ),
                ),
                Expanded(
                  child: DashboardCard(
                    title: "Stock",
                    value: "${totalStock()}",
                    icon: Icons.inventory,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: DashboardCard(
                    title: "Total Harga",
                    value: formatRupiah(totalHarga()),
                    icon: Icons.payment,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Daftar Product",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (hasilPencarian.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Center(
                  child: Text(
                    "Produk Tidak Ditemukan",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            else
              ...hasilPencarian.map(
                (product) {
                  return ProductCard(
                    product: product,
                    onEdit: () async {
                      final hasil = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditPage(
                            product: product,
                          ),
                        ),
                      );

                      if (hasil == true) {
                        loadProducts();
                      }
                    },
                    onDelete: () {
                      hapusProduk(product);
                    },
                    onDetail: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailProduct(
                            product: product,
                          ),
                        ),
                      );

                      loadProducts();
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}