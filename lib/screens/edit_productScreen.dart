import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _endProduct = Product(
    id: null,
    title: "",
    description: "",
    price: 0,
    imageUrl: "",
  );
  bool _isNewProduct = true;
  bool _isLoading = false;

  @override
  void initState() {
    _imageUrlFocus.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final productId = ModalRoute.of(context).settings.arguments;
    if (productId != null) {
      _isNewProduct = false;
      _endProduct = Provider.of<Products>(context, listen: false)
          .findById(productId.toString());
      _imageUrlController.text = _endProduct.imageUrl;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocus.removeListener(_updateImageUrl);
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlController.dispose();
    _imageUrlFocus.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocus.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() async {
    setState(() {
      _isLoading = true;
    });
    final _isValid = _formKey.currentState.validate();
    if (!_isValid) return;
    _formKey.currentState.save();
    if (_isNewProduct)
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_endProduct);
      } catch (error) {
        return showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Product not Added"),
                  content: Text("Something went wrong"),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Okay"),
                    )
                  ],
                ));
      }
    try {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_endProduct);
    } catch (error) {
      return showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text("Product not Updated"),
                content: Text("Something went wrong"),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Okay"),
                  )
                ],
              ));
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _endProduct.title,
                        decoration: InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocus);
                        },
                        validator: (val) {
                          if (val.isEmpty)
                            return "Provide an Input";
                          else
                            return null;
                        },
                        onSaved: (val) {
                          _endProduct = Product(
                            id: _isNewProduct ? null : _endProduct.id,
                            title: val,
                            description: _endProduct.description,
                            price: _endProduct.price,
                            imageUrl: _endProduct.imageUrl,
                            isFavorite: _endProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue:
                            _isNewProduct ? "" : _endProduct.price.toString(),
                        decoration: InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocus,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocus);
                        },
                        validator: (val) {
                          if (val.isEmpty) return "Provide an Input";
                          if (double.tryParse(val) == null)
                            return "Provide a valid input";
                          if (double.parse(val) <= 0)
                            return "Enter a value greater than 0";
                          return null;
                        },
                        onSaved: (val) {
                          _endProduct = Product(
                            id: _isNewProduct ? null : _endProduct.id,
                            title: _endProduct.title,
                            description: _endProduct.description,
                            price: double.parse(val),
                            imageUrl: _endProduct.imageUrl,
                            isFavorite: _endProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _endProduct.description,
                        decoration: InputDecoration(labelText: "Description"),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocus,
                        validator: (val) {
                          if (val.isEmpty) return "Provide an Input";
                          if (val.length <= 10)
                            return "Should be atleast 10 character";
                          else
                            return null;
                        },
                        onSaved: (val) {
                          _endProduct = Product(
                            id: _isNewProduct ? null : _endProduct.id,
                            title: _endProduct.title,
                            description: val,
                            price: _endProduct.price,
                            imageUrl: _endProduct.imageUrl,
                            isFavorite: _endProduct.isFavorite,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 8, right: 4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Center(child: Text("Enter URL"))
                                : Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                              child: TextFormField(
                            decoration: InputDecoration(labelText: "Image URL"),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocus,
                            validator: (val) {
                              if (val.isEmpty)
                                return "Provide an Input";
                              else
                                return null;
                            },
                            onSaved: (val) {
                              _endProduct = Product(
                                id: _isNewProduct ? null : _endProduct.id,
                                title: _endProduct.title,
                                description: _endProduct.description,
                                price: _endProduct.price,
                                imageUrl: val,
                                isFavorite: _endProduct.isFavorite,
                              );
                            },
                          ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
