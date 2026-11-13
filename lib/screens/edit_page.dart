import 'package:flutter/material.dart';
import 'package:nicnic/models/product.dart';
import 'package:nicnic/services/api_service.dart';

class EditPage extends StatefulWidget {
  final Product product;
  const EditPage({super.key,required this.product});

  @override
  State<EditPage> createState() => _EditPageState();
  
}

class _EditPageState extends State<EditPage> {
  final _formKey=GlobalKey<FormState>();
  final namaController=TextEditingController();
  final hargaController=TextEditingController();
  final stockController=TextEditingController();
  final deskripsiController=TextEditingController();
  final ApiService api=ApiService();
  bool loading=false;

 @override
  void initState(){
    super.initState();
    namaController.text=widget.product.nama;
    hargaController.text=widget.product.harga.toString();
    stockController.text=widget.product.stock.toString();
    deskripsiController.text=widget.product.deskripsi;
  }
  Future<void>updateData()async {
    if(!_formKey.currentState!.validate()){
      return;
    }
    setState(() {
      loading=true;
    });
    Product product=Product(
      id: widget.product.id,
      nama:namaController.text,
      harga:int.parse(hargaController.text),
      stock:int.parse(stockController.text),
      deskripsi:deskripsiController.text,
      );
      bool berhasil=await api.updateProduct(product);
      setState(() {
        loading=false;
      });
      if(berhasil){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:Text("Produk Berhasil Diperbarui"),
            ),
        );
        Navigator.pop(context,true);
      }else{
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:Text("Produk Gagal Diperbarui"),
            ),
        );
      }
  }
  Future<void>konfirmasiUpdate()async{
    bool?hasil=await showDialog(
      context: context, builder: (_) {
        return AlertDialog(
          title: const Text("konfirmasi"),
          content: const Text("Apakah data akan diperbarui?"),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context,false);
            },
            child: const Text("Batal"),
            ),
            ElevatedButton(onPressed:(){
              Navigator.pop(context,true);
            },
            child: const Text("Ya"),
            ),
          ],
        );
      },
      );
      if(hasil==true){
        updateData();
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Produk"),
        centerTitle: true,
      ),
      body:Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: "Nama Produk",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "Nama Wajib Diisi";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              //harga
               TextFormField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Harga Produk",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "harga Wajib Diisi";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              //stock
               TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Stock Produk",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "Stock Wajib Diisi";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              //deskripsi
               TextFormField(
                controller: deskripsiController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Deskripsi Produk",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return "Deskripsi Wajib Diisi";
                  }
                  return null;
                },
              ),
            const SizedBox(height: 30),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: loading?null:konfirmasiUpdate,
                  icon: loading
                  ?const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  :const Icon(Icons.edit),
                  label: Text(
                    loading
                    ?"Mengubah.."
                    :"Update Produk"
                  )
                )
              )
            ],
          ),
        ),
        )
    );
  }
}