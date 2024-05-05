import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/list_helper.dart';
import 'package:ultimate_flutter_db_sqflite/sql/pages/add_edit_product.dart';
import 'package:ultimate_flutter_db_sqflite/sql/services/db_service.dart';

import '../models/products_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBService dbService = DBService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: const Text("Flutter SQFLITE CRUD"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: FormHelper.submitButton("Add Product", () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddEditProductPage()));
                },
                    borderRadius: 10.0,
                    btnColor: Colors.lightBlue,
                    borderColor: Colors.lightBlue),
              ),
              SizedBox(
                height: 10.0,
              ),
              _fetchData(),
            ],
          ),
        ));
  }

  _fetchData() {
    return FutureBuilder<List<ProductModel>>(
        future: dbService.getProducts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> products) {
          if (products.hasData) {
            return _buildDataTable(products.data!);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  _buildDataTable(List<ProductModel> model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListUtils.buildDataTable(context, ["Product Name", "Price", ""],
          ["productName", "price", ""], false, 0, model, (ProductModel data) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddEditProductPage(
                      isEditMode: true,
                      model: data,
                    )));
      }, (ProductModel data) {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("SQFLITE CRUD"),
                content: const Text("Do you want to delete this record ?"),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FormHelper.submitButton("Yes", () {
                        dbService.deleteProduct(data).then((value) {
                          setState(() {
                            Navigator.pop(context);
                          });
                        });
                      },
                          width: 100.0,
                          borderRadius: 5,
                          borderColor: Colors.green,
                          btnColor: Colors.green),
                      const SizedBox(width: 5),
                      FormHelper.submitButton("No", () {
                        Navigator.pop(context);
                      },
                      width: 100.0,
                      borderRadius: 5, )
                    ],
                  )
                ],
              );
            });
      },
          headingRowColor: Colors.orangeAccent,
          isScrollable: true,
          columnTextFontSize: 15.0,
          columnTextBold: false,
          columnSpacing: 50.0,
          onSort: (columnIndex, columnName, asc) {}),
    );
  }
}
