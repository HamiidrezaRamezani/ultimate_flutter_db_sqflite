import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:ultimate_flutter_db_sqflite/models/products_model.dart';
import 'package:ultimate_flutter_db_sqflite/services/db_service.dart';

class AddEditProductPage extends StatefulWidget {
  final ProductModel? model;
  final bool isEditMode;

  const AddEditProductPage({super.key, this.model, this.isEditMode = false});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  late ProductModel model;
  List<dynamic> categories = [];
  late DBService dbService;

  @override
  void initState() {
    super.initState();
    dbService = DBService();
    model = ProductModel(productName: "", categoryId: -1);

    if (widget.isEditMode) {
      model = widget.model!;
    }
    categories.add({"id": 1, "name": "T-Shirts"});
    categories.add({"id": 2, "name": "Shirts"});
    categories.add({"id": 3, "name": "Jeans"});
    categories.add({"id": 4, "name": "Trousers"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
        title: Text(widget.isEditMode ? 'Edit Product' : 'Add Product'),
      ),
      body: Form(
        key: globalKey,
        child: _formUI(),
      ),
      bottomNavigationBar: SizedBox(
        height: 110.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FormHelper.submitButton("Save", () {
              if (validateAndSave()) {
                if (widget.isEditMode) {
                  dbService.updateProduct(model).then((value) {
                    FormHelper.showSimpleAlertDialog(
                        context, "SQFLITE", "Data Modified Successfully", "Ok",
                        () {
                      Navigator.pop(context);
                    });
                  });
                }else{
                  dbService.addProduct(model).then((value) {
                    FormHelper.showSimpleAlertDialog(
                        context, "SQFLITE", "Data Added Successfully", "Ok",
                            () {
                          Navigator.pop(context);
                        });
                  });
                }
              }
            },
                borderRadius: 10.0,
                btnColor: Colors.green,
                borderColor: Colors.green),
            FormHelper.submitButton("Cancel", () {},
                borderRadius: 10.0,
                btnColor: Colors.grey,
                borderColor: Colors.grey),
          ],
        ),
      ),
    );
  }

  _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FormHelper.inputFieldWidgetWithLabel(
              context,
              "productName",
              "Product Name",
              "",
              (onValidate) {
                if (onValidate.isEmpty) {
                  return "* Required";
                }
                return null;
              },
              (onSaved) {
                model.productName = onSaved.toString().trim();
              },
              initialValue: model.productName,
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.text_fields),
              borderRadius: 10.0,
              contentPadding: 15,
              fontSize: 14,
              labelFontSize: 14,
              paddingLeft: 0,
              paddingRight: 0,
              prefixIconPaddingLeft: 10,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: FormHelper.inputFieldWidgetWithLabel(
                      context, "productPrice", "Product Price", "",
                      (onValidate) {
                    if (onValidate.isEmpty) {
                      return "* Required";
                    }
                    return null;
                  }, (onSaved) {
                    model.price = double.parse(onSaved.trim());
                  },
                      initialValue: model.price != null ? model.price.toString() : "",
                      showPrefixIcon: true,
                      prefixIcon: const Icon(Icons.currency_yuan),
                      borderRadius: 10.0,
                      contentPadding: 15,
                      fontSize: 14,
                      labelFontSize: 14,
                      paddingLeft: 0,
                      paddingRight: 0,
                      prefixIconPaddingLeft: 10,
                      isNumeric: true),
                ),
                Flexible(
                    child: FormHelper.dropDownWidgetWithLabel(
                        context,
                        "Product Category",
                        "--Select--",
                        model.categoryId,
                        categories, (onChanged) {
                  model.categoryId = int.parse(onChanged);
                }, (onValidate) {},
                        borderRadius: 10.0,
                        labelFontSize: 14,
                        paddingLeft: 0,
                        paddingRight: 0,
                        hintFontSize: 14,
                        prefixIcon: const Icon(Icons.category),
                        showPrefixIcon: true,
                        prefixIconPaddingLeft: 10.0))
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            FormHelper.inputFieldWidgetWithLabel(
              context,
              "productDesc",
              "Product Description",
              "",
              (onValidate) {
                if (onValidate.isEmpty) {
                  return "* Required";
                }
                return null;
              },
              (onSaved) {
                model.productDesc = onSaved.toString().trim();
              },
              initialValue: model.productDesc ?? "",
              borderRadius: 10.0,
              contentPadding: 15,
              fontSize: 14,
              labelFontSize: 14,
              paddingLeft: 0,
              paddingRight: 0,
              prefixIconPaddingLeft: 10,
              isMultiline: true,
              multilineRows: 5,
            ),
            SizedBox(
              height: 10.0,
            ),
            _picPicker(
                model.productPic ?? "",
                (file) => {
                      setState(() {
                        model.productPic = file.path;
                      })
                    })
          ],
        ),
      ),
    );
  }

  _picPicker(String fileName, Function onFilePicked) {
    Future<XFile?> _imageFile;
    ImagePicker _picker = ImagePicker();
    return Column(
      children: [
        fileName != ""
            ? Image.file(
                File(fileName),
                width: 300,
                height: 300,
              )
            : SizedBox(
                child: Image.network(
                  "src",
                  width: 350,
                  height: 250.0,
                  fit: BoxFit.scaleDown,
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 35,
              width: 35,
              child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    _imageFile = _picker.pickImage(source: ImageSource.gallery);
                    _imageFile.then((file) async {
                      onFilePicked(file);
                    });
                  },
                  icon: Icon(
                    Icons.camera,
                    size: 35.0,
                  )),
            )
          ],
        )
      ],
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
