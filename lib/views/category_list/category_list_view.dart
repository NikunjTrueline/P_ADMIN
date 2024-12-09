import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constants.dart';
import 'package:grocery_app/firebase/firebase_service.dart';
import '../../model/category.dart';
import '../category/category_view.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  List<Category> categoryStore = [];

  @override
  initState() {
    categoryStream2.listen((category) {
      categoryStore = category;
    });

    super.initState();
  }

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Stream<List<Category>> get categoryStream2 {
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

  Future<void> _showDeleteDialog(
      Category category, BuildContext context) async {
    var res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );

    if (res) {
      await FirebaseService().deleteCategory(category.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Category List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent.shade100,
      ),
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: StreamBuilder<List<Category>>(
            stream: FirebaseService().categoryStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                ));
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      categoryStore.sort((a, b) => a.name.compareTo(b.name));

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryView(
                                    category: categoryStore[index]),
                              ));
                        },
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      //const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Image.network(
                                              categoryStore[index].imageUrl,
                                              //color: Colors.orange,
                                            ),
                                          ),
                                        ),
                                      ),
                                      //const Spacer(),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              categoryStore[index].name,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                categoryStore[index]
                                                    .description,
                                                maxLines: 2),
                                          ],
                                        ),
                                      ),
                                      Switch(
                                        activeColor: Colors.blueAccent,
                                        inactiveTrackColor:
                                            Colors.blue.shade100,
                                        inactiveThumbColor: Colors.blueAccent,
                                        value: categoryStore[index].isActive ??
                                            true,
                                        onChanged: (value) {
                                          print(categoryStore[index].id);
                                          FirebaseService()
                                              .updateCategoryStatus(value,
                                                  categoryStore[index].id!);
                                        },
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          print(categoryStore[index].name);
                                          _showDeleteDialog(
                                              categoryStore[index], context);
                                        },
                                        icon: Icon(
                                          size: 25,
                                          Icons.delete,
                                          color: Colors.blueAccent.shade100,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text('No categories found'),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppConstant.categoryView);
        },
        backgroundColor: Colors.blueAccent.shade100,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
