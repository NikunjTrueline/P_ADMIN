import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grocery_app/model/category.dart';
import 'package:grocery_app/model/item.dart';
import 'package:image_picker/image_picker.dart';
import '../../../firebase/firebase_service.dart';
import '../../../utils/app_util.dart';
import '../../../widget/custom_button.dart';

class ItemForm extends StatefulWidget {
  final Item? item;

  const ItemForm({super.key, this.item});

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockQuantityController = TextEditingController();
  late TextEditingController _manufacturingDate = TextEditingController();
  final _expiryDate = TextEditingController();
  final _batchNo = TextEditingController();
  final _companyName = TextEditingController();
  String? _categoryId;
  String? _selectedUnit;
  XFile? _newImage;
  String? existingImageUrl;
  List<Category> _categories = [];
  String manufacturingDate1 = "";
  String expiryDate1 = "";

  Future _selectmanufacturingDate() async {
    var pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      initialEntryMode: DatePickerEntryMode.calendar,
      fieldLabelText: 'Date',
      helpText: 'Select Date',
      confirmText: 'Done',
      cancelText: 'Cancel',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent, // header background color
              onPrimary: Colors.black, // header text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.blueAccent, // button text color
                  fixedSize: const Size(30, 20)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        x = pickedDate;
        manufacturingDate1 =
            '${pickedDate.day.toString()}/${pickedDate.month.toString()}/${pickedDate.year}';
        _manufacturingDate.text = manufacturingDate1;
      });
    }
  }

  late DateTime x;

  Future _selectExpiryDate() async {
    var pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: x,
      lastDate: DateTime(2030),
      initialEntryMode: DatePickerEntryMode.calendar,
      fieldLabelText: 'Date',
      helpText: 'Select Date',
      confirmText: 'Done',
      cancelText: 'Cancel',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent, // header background color
              onPrimary: Colors.black, // header text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blueAccent, // button text color
                fixedSize: const Size(30, 20),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        expiryDate1 =
            '${pickedDate.day.toString()}/${pickedDate.month.toString()}/${pickedDate.year}';
        _expiryDate.text = expiryDate1;
      });
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemDescriptionController.dispose();
    _priceController.dispose();
    _stockQuantityController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate() &&
        (existingImageUrl != null || _newImage != null)) {
      _formKey.currentState!.save();

      bool? result = await FirebaseService().addOrUpdateItem(
          name: _itemNameController.text,
          description: _itemDescriptionController.text,
          newImage: _newImage,
          context: context,
          existingImageUrl: existingImageUrl,
          createdAt: widget.item?.createdAt,
          price: double.parse(_priceController.text),
          stock: int.parse(_stockQuantityController.text),
          unit: _selectedUnit!,
          itemId: widget.item?.id,
          categoryId: _categoryId!,
          manufacturingDate: _manufacturingDate.text.toString(),
          expiryDate: _expiryDate.text.toString(),
          batchNumber: _batchNo.text.toString(),
          companyName: _companyName.text.toString());

      print("ALL DONE ");

      if (result == true) {
        SnackBar(
          content: Text('Added to cart successfully',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blueAccent,
        );
        // AppUtil.showToast('Item Updated successfully');
        Navigator.pop(context);
      } else {
        AppUtil.showToast('Error occurred while managing item.');
      }
    }
  }

  Future<void> pickImage() async {
    var image = await AppUtil.pickImageFromGallery();

    if (image != null) {
      setState(() {
        _newImage = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      existingImageUrl = widget.item!.imageUrl;
      _itemNameController.text = widget.item!.name;
      _itemDescriptionController.text = widget.item!.description;
      _priceController.text = widget.item!.price.toString();
      _stockQuantityController.text = widget.item!.stock.toString();
      _categoryId = widget.item!.categoryId;
      _selectedUnit = widget.item!.unit;
      _manufacturingDate.text = widget.item!.manufacturingDate;
      _expiryDate.text = widget.item!.expiryDate;
      _batchNo.text = widget.item!.batchNumber;
      _companyName.text = widget.item!.companyName;
    }
    _loadCategories().then((value) {
      removeCategory();
      print(_categories.length);
    });
  }

  void removeCategory() {
    print("remove time ${_categories.length}");
    for (int i = 0; i < _categories.length; i++) {
      print(i);
      print(_categories[6].name);
      if (_categories[i].isActive == false) {
        _categories.remove(_categories[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white.withOpacity(.7),
                    child: _newImage == null && existingImageUrl != null
                        ? CircleAvatar(
                            radius: 60,
                            foregroundImage: NetworkImage(existingImageUrl!),
                          )
                        : _newImage != null
                            ? CircleAvatar(
                                radius: 60,
                                foregroundImage: FileImage(
                                  File(_newImage!.path),
                                ),
                              )
                            : const Icon(
                                Icons.add,
                                size: 40,
                                color: Colors.grey,
                              ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _itemNameController,
                  cursorHeight: 32,
                  cursorWidth: 2,
                  cursorColor: Colors.blueAccent,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _itemDescriptionController,
                  cursorHeight: 32,
                  cursorWidth: 2,
                  cursorColor: Colors.blueAccent,
                  decoration: const InputDecoration(
                    labelText: 'Item Description',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _priceController,
                        cursorHeight: 32,
                        cursorWidth: 2,
                        cursorColor: Colors.blueAccent,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _stockQuantityController,
                        cursorHeight: 32,
                        cursorWidth: 2,
                        cursorColor: Colors.blueAccent,
                        decoration: const InputDecoration(
                          labelText: 'Stock Quantity',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the stock quantity';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _categoryId,
                  decoration: const InputDecoration(
                    labelText: 'Select Category',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  items: _categories
                      .map<DropdownMenuItem<String>>((Category category) {
                    return DropdownMenuItem<String>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _categoryId = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedUnit,
                  decoration: const InputDecoration(
                    labelText: 'Select Unit',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  items: <String>[
                    'strip',
                    'ml',
                    'gram',
                    'Tablets',
                    'Mask',
                    'gummies',
                    'Powder',
                    'Pcs'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUnit = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a unit';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _manufacturingDate,
                  cursorHeight: 32,
                  cursorWidth: 2,
                  onTap: () {
                    _selectmanufacturingDate();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  onSaved: (newValue) {
                    manufacturingDate1 = newValue.toString();
                  },
                  cursorColor: Colors.blueAccent,
                  decoration: const InputDecoration(
                    labelText: 'Mfg Date',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    suffixIcon: Icon(
                      Icons.calendar_month,
                      color: Colors.blueAccent,
                      size: 28,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Select manufacturing date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _expiryDate,
                  cursorHeight: 32,
                  cursorWidth: 2,
                  onTap: () {
                    _selectExpiryDate();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  cursorColor: Colors.blueAccent,
                  decoration: const InputDecoration(
                    labelText: 'Exp Date',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    suffixIcon: Icon(
                      Icons.calendar_month,
                      color: Colors.blueAccent,
                      size: 28,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select expiry date';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _batchNo,
                  cursorHeight: 32,
                  cursorWidth: 2,
                  cursorColor: Colors.blueAccent,
                  decoration: const InputDecoration(
                    labelText: 'Batch No',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter batch number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _companyName,
                  cursorHeight: 32,
                  cursorWidth: 2,
                  cursorColor: Colors.blueAccent,
                  decoration: const InputDecoration(
                    labelText: 'Company Name',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  backgroundColor: Colors.blueAccent.shade100,
                  title: widget.item == null ? 'Add Item' : 'Update Item',
                  foregroundColor: Colors.white,
                  callback: _saveForm,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _loadCategories() async {
    List<Category> categories = await FirebaseService().loadCategories();
    setState(() {
      _categories = categories;
      print(_categories.length);
    });
  }
}
