import 'package:flutter/material.dart';
import 'package:grocery_app/model/category.dart';
import 'package:grocery_app/views/category/components/category_form.dart';

class CategoryView extends StatelessWidget {

  Category? category;


   CategoryView({this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          'Manage Category',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent.shade100,
        iconTheme:const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: CategoryForm(category),
          ),
        ),
      ),
    );
  }
}
