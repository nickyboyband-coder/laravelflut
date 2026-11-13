import 'package:flutter/material.dart';
import 'package:nicnic/screens/edit_page.dart';
import '../models/product.dart';

class DetailProduct extends StatelessWidget {
  final Product product;
  const DetailProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail product"),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
           Hero(
              tag: product.id!,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: (product.gambar == null || product.gambar!.isEmpty)
                      ? Image.asset(
                          "asset/p.jpg",
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          "http://127.0.0.1:8000/storage/products/${product.gambar}",
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "asset/p.jpg",
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                ),
              ),
            ),
             SizedBox(height: 20),
             Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.nama,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.attach_money),
                        const SizedBox(width: 10),
                        Text(
                          "Rp ${product.harga}",
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                      SizedBox(height: 15),
                    Row(
                      children: [
                        const Icon(Icons.inventory),
                        const SizedBox(width: 10),
                        Text(
                          "Stock: ${product.stock}",
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                        const Divider(height: 15),
                        const Text("Deskripsi",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                        ),
                          const SizedBox(width: 10),
                          Text(product.deskripsi,
                          style:TextStyle(fontSize: 16),
                          ),
                      ],
                    ),                 
                ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon:const Icon(Icons.edit),
                    label:const Text("Edit Product"),
                    style: ElevatedButton.styleFrom(
                       padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: ()async {
                      final hasil=await Navigator.push(
                        context,
                       MaterialPageRoute(
                        builder: (_)=>EditPage(product: product,
                        ),
                       ),
                       );
                       if (hasil==true){
                        Navigator.pop(context,true);
                       }
                    }
                )
             ),
              const SizedBox(height: 15),
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon:const Icon(Icons.arrow_back),
                    label:const Text("KEMBALI"),
                    style: OutlinedButton.styleFrom(
                       padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: (){
                       Navigator.pop(context);
                    },
                  ),
              )
          ],
        ),
      ),
    );
  }
}