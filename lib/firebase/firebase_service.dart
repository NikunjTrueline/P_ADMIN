import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/model/admin.dart';
import 'package:grocery_app/model/category.dart';
import 'package:grocery_app/model/item.dart';
import 'package:image_picker/image_picker.dart';
import '../model/dashboard_data.dart';
import '../model/order.dart';
import '../model/user.dart';

/*
void main()
{
}
 */

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  Future<bool> createUser(UserData user) async {
    try {
      await _database.ref('users').child(user.id).set(user.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Stream<List<Item>> itemStream1(String id) {
    return _database.ref().child('items').onValue.map((event) {
      List<Item> items = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> itemsMap =
            event.snapshot.value as Map<dynamic, dynamic>;
        itemsMap.forEach((key, value) {
          final item = Item.fromJson(value);
          items.add(item);
        });
      }
      return items;
    });
  }

  Future<bool?> addOrUpdateCategory(
      {String? categoryId,
      required String name,
      required String description,
      XFile? newImage,
      String? existingImageUrl,
      int? createdAt,
      required BuildContext context}) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const Center(
            child: CircularProgressIndicator(
          color: Colors.red,
        )),
      );

      String imageUrl = existingImageUrl ?? '';
      if (newImage != null) {
        // If a new image is selected, upload it
        String filePath =
            'categories/${DateTime.now().millisecondsSinceEpoch}.png';
        File file = File(newImage.path);
        TaskSnapshot snapshot =
            await _storage.ref().child(filePath).putFile(file);
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      int timestamp = createdAt ?? DateTime.now().millisecondsSinceEpoch;

      Category category = Category(
          id: categoryId,
          name: name,
          description: description,
          imageUrl: imageUrl,
          createdAt: timestamp,
          isActive: true);

      if (categoryId == null) {
        var id = _database.ref().child('categories').push().key;
        category.id = id;
        await _database
            .ref()
            .child('categories')
            .child(id!)
            .set(category.toJson());
      } else {
        // Update existing category
        await _database
            .ref()
            .child('categories')
            .child(categoryId)
            .update(category.toJson());
      }
      Navigator.pop(context);
      return true;
    } catch (e) {
      print(e);
      Navigator.pop(context);
      return false;
    }
  }

  Future<void> updateInTopStatus(String itemId, bool status) async {
    // Updating the 'name' field of the product
    await _database.ref().child("items").child(itemId).update({
      'inTop': status,
    });
  }

  Stream<List<Category>> get categoryStream {
    return _database.ref().child('categories').onValue.map((event) {
      List<Category> categories = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> categoriesMap =
            event.snapshot.value as Map<dynamic, dynamic>;
        categoriesMap.forEach((key, value) {
          final category = Category.fromJson(value);
          categories.add(category);
        });
      }
      return categories;
    });
  }

  Future<bool> deleteCategory(String categoryId) async {
    try {
      await _database.ref().child('categories').child(categoryId).remove();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Category>> loadCategories() async {
    DataSnapshot snapshot = await _database.ref().child('categories').get();
    List<Category> categories = [];
    if (snapshot.exists) {
      Map<dynamic, dynamic> categoriesMap =
          snapshot.value as Map<dynamic, dynamic>;
      categoriesMap.forEach((key, value) {
        final category = Category.fromJson(value);
        categories.add(category);
      });
    }
    return categories;
  }

  /*
   --------------------------  Add or Update products ------------------------------
                              products manage method().
   */

  Future<bool?> addOrUpdateItem(
      {String? itemId,
      required String name,
      required String description,
      required String categoryId,
      required double price,
      required int stock,
      required String unit,
      XFile? newImage,
      String? existingImageUrl,
      int? createdAt,
      required String expiryDate,
      required String companyName,
      required String batchNumber,
      required String manufacturingDate,
      required BuildContext context}) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const Center(
            child: CircularProgressIndicator(
          color: Colors.red,
        )),
      );

      String imageUrl = existingImageUrl ?? '';
      if (newImage != null) {
        // If a new image is selected, upload it
        String filePath = 'items/${DateTime.now().millisecondsSinceEpoch}.png';
        File file = File(newImage.path);
        TaskSnapshot snapshot =
            await _storage.ref().child(filePath).putFile(file);
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      int timestamp = createdAt ?? DateTime.now().millisecondsSinceEpoch;

      Item item = Item(
        id: itemId,
        name: name,
        description: description,
        categoryId: categoryId,
        price: price,
        stock: stock,
        unit: unit,
        imageUrl: imageUrl,
        createdAt: timestamp,
        expiryDate: expiryDate,
        companyName: companyName,
        batchNumber: batchNumber,
        manufacturingDate: manufacturingDate,
      );

      if (itemId == null) {
        var id = _database.ref().child('items').push().key;
        item.id = id;

        await _database.ref().child('items').child(id!).set(item.toJson());
      } else {
        // Update existing category
        await _database
            .ref()
            .child('items')
            .child(itemId)
            .update(item.toJson());
      }
      Navigator.pop(context);
      return true;
    } catch (e) {
      print(e);
      Navigator.pop(context);
      return false;
    }
  }

  Stream<List<Item>> get itemStream {
    return _database.ref().child('items').onValue.map((event) {
      List<Item> items = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> itemsMap =
            event.snapshot.value as Map<dynamic, dynamic>;
        itemsMap.forEach((key, value) {
          final item = Item.fromJson(value);
          items.add(item);
        });
      }
      return items;
    });
  }

  Future<bool> deleteItem(String itemId) async {
    try {
      await _database.ref().child('items').child(itemId).remove();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<DashboardData> fetchDashboardData() {
    try {
      return _database.ref().onValue.map((event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};

        return DashboardData(
          totalCategories:
              data['categories'] != null ? data['categories'].length : 0,
          totalItems: data['items'] != null ? data['items'].length : 0,
          totalUsers: data['users'] != null ? data['users'].length : 0,
          totalOrders: data['orders'] != null ? data['orders'].length : 0,
        );
      });
    } catch (e) {
      throw Exception('Failed to load dashboard data');
    }
  }

  Stream<List<UserData>> get userStream {
    return _database.ref().child('users').onValue.map((event) {
      List<UserData> categories = [];
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> userMap =
            event.snapshot.value as Map<dynamic, dynamic>;
        userMap.forEach((key, value) {
          final user = UserData.fromJson(value);
          categories.add(user);
        });
      }
      return categories;
    });
  }

  Stream<List<Order>> get orderStream {
    return _database.ref().child('orders').onValue.map((event) {
      dynamic ordersMap = event.snapshot.value ?? {};
      List<Order> orders = [];
      ordersMap.forEach((key, value) {
        orders.add(Order.fromJson(Map<String, dynamic>.from(value)));
      });
      return orders;
    });
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _database
        .ref()
        .child('orders')
        .child(orderId)
        .update({'status': newStatus});
  }

  Future<void> updateCategoryStatus(bool status, String categoryId) async {
    try {
      await _database.ref("categories").child(categoryId).update({
        'isActive': status,
        // You can add more fields to update here if needed
      });
    } catch (e) {
      print('Error updating category status: $e');
      throw e;
    }
  }

  Future<AdminModel?> getUserData1() async {
    try {
      var adminId = _firebaseAuth.currentUser!.uid;

      DataSnapshot snapshot = await _database.ref("admin").child(adminId).get();
      if (snapshot.value != null) {
        return AdminModel.fromJson(snapshot.value);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
}
