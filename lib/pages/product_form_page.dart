import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
    _descriptionFocus.dispose();
    _priceFocus.dispose();
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg') ||
        url.toLowerCase().endsWith('.webp');
    return isValidUrl && endsWithFile;
  }


  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    if (_formData['name'] == null ||
        _formData['description'] == null ||
        _formData['price'] == null ||
        _formData['imageUrl'] == null) {
      return;
    }

    setState(() => _isLoading = true);

    try {
     await Provider.of<ProductList>(context, listen: false).saveProduct(_formData);
     Navigator.of(context).pop();
    } catch(error){
    await showDialog<void>(
        context: context,
        builder: (ctz) => AlertDialog(
          title: const Text('Ocorreu um erro !'),
          content: const Text('Ocorreu um erro ao salvar o produto:'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    } finally{
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Formulário de Produtos'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _submitForm,
            )
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          initialValue: _formData['name']?.toString(),
                          decoration: const InputDecoration(labelText: 'Nome'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).requestFocus(_priceFocus);
                          },
                          onSaved: (name) => _formData['name'] = name ?? '',
                          // ignore: no_leading_underscores_for_local_identifiers
                          validator: (_name) {
                            final name = _name ?? '';

                            if (name.trim().isEmpty) {
                              return 'Nome é obrigatório';
                            }

                            if (name.trim().length < 3) {
                              return 'O nome deve conter pelo menos 3 letras';
                            }

                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: _formData['price']?.toString(),
                          focusNode: _priceFocus,
                          decoration: const InputDecoration(labelText: 'Preço'),
                          textInputAction: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocus);
                          },
                          onSaved: (price) => _formData['price'] =
                              double.tryParse(price ?? '0') ?? 0.0,
                          // ignore: no_leading_underscores_for_local_identifiers
                          validator: (_price) {
                            final priceString = _price ?? '';
                            final price = double.tryParse(priceString);

                            if (price == null || price <= 0) {
                              return 'Informe um preço válido';
                            }

                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: _formData['description']?.toString(),
                          decoration:
                              const InputDecoration(labelText: 'Descrição'),
                          focusNode: _descriptionFocus,
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          onSaved: (description) =>
                              _formData['description'] = description ?? '',
                          validator: (description) {
                            // ignore: no_leading_underscores_for_local_identifiers
                            final _description = description ?? '';

                            if (_description.trim().isEmpty) {
                              return 'Descrição é obrigatória';
                            }

                            if (_description.trim().length < 10) {
                              return 'O nome deve conter pelo menos 10 letras';
                            }

                            return null;
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                onSaved: (imageUrl) =>
                                    _formData['imageUrl'] = imageUrl ?? '',
                                decoration: const InputDecoration(
                                    labelText: 'Url da Imagem'),
                                focusNode: _imageUrlFocus,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.url,
                                controller: _imageUrlController,
                                onFieldSubmitted: (value) => _submitForm(),
                                validator: (url) {
                                  final imageUrl = url ?? '';
                                  if (!isValidImageUrl(imageUrl)) {
                                    return 'informe uma Url valida';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Container(
                              height: 100,
                              width: 100,
                              margin: const EdgeInsets.only(top: 10, left: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                              ),
                              alignment: Alignment.center,
                              child: _imageUrlController.text.isEmpty
                                  ? const Text('Informe a Url')
                                  : Image.network(_imageUrlController.text),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
      ),
    );
  }
}
