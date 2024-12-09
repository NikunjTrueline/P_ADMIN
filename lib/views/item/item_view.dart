import 'package:flutter/material.dart';
import 'package:grocery_app/model/item.dart';
import 'package:grocery_app/views/item/components/item_form.dart';


class ItemView extends StatelessWidget {

  Item? item;


  ItemView({this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Item',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent.shade100,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ItemForm(item: item,),
          ),
        ),
      ),
    );
  }
}
