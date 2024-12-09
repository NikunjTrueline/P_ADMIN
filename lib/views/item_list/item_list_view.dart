import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/model/item.dart';
import 'package:grocery_app/views/item/item_view.dart';
import '../../constants/constants.dart';
import '../../firebase/firebase_service.dart';
import '../../model/category.dart';

Future<void> _showDeleteDialog(Item item, BuildContext context) async {
  var res = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Are you sure you want to delete this item?'),
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
    await FirebaseService().deleteItem(item.id!);
  }
}

List<Category> category1 = [];

class ItemListView extends StatefulWidget {
  const ItemListView({super.key});

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  initState() {
    log("Init state called...");
    categoryStream1.listen((category) {
      category1 = category;
    });
    // category1.sort((a, b) => a.name.compareTo(b.name));
    log("init state completed");
    super.initState();
  }

  Stream<List<Category>> get categoryStream1 {
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: category1.length,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(
                Icons.settings,
                color: Colors.blueAccent,
              ),
            )
          ],
          title: const Text(
            'Item List',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent.shade100,
          bottom: TabBar(
            indicatorColor: Colors.blueAccent.shade400,
            indicatorWeight: 2,
            isScrollable: true,
            padding: const EdgeInsets.all(5),
            dividerHeight: 1,
            physics: const BouncingScrollPhysics(),
            labelStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white),
            tabs: [
              for (int i = 0; i < category1.length; i++)
                Tab(
                  text: category1[i].name,
                )
            ],
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        body: TabBarView(
          children: [
            for (int i = 0; i < category1.length; i++)
              Category1(categoryId: category1[i].id!),
            //Category1(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AppConstant.productView);
          },
          backgroundColor: Colors.blueAccent.shade100,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class Category1 extends StatefulWidget {
  final String categoryId;
  const Category1({super.key, required this.categoryId});

  @override
  State<Category1> createState() => _Category1State();
}

class _Category1State extends State<Category1> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<List<Item>>(
          stream: FirebaseService().itemStream1(category1[0].id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.blue,
              ));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              List<Item> data = [];
              for (int n = 0; n < snapshot.data!.length; n++) {
                Item item = snapshot.data![n];

                item.categoryId == widget.categoryId ? data.add(item) : null;
              }

              //data.sort((a, b) => a.name.compareTo(b.name));
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          isThreeLine: true,
                          onTap: () {
                            log(data[index].name);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ItemView(item: data[index]),
                                ));
                          },
                          leading: Image.network(
                            data[index].imageUrl,
                            width: 80,
                            height: 80,
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 24,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data[index].name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                data[index].description,
                                maxLines: 1,
                              ),
                              Text(
                                'Price : ${data[index].price} /${data[index].unit}',
                                maxLines: 1,
                              ),
                              Text(
                                'Stock : ${data[index].stock} ${data[index].unit}',
                                maxLines: 1,
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                activeColor: Colors.blueAccent,
                                value: data[index].inTop,
                                onChanged: (value) {
                                  FirebaseService().updateInTopStatus(
                                      data[index].id!, value!);
                                },
                              ),
                              IconButton(
                                onPressed: () {
                                  _showDeleteDialog(data[index], context);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.blueAccent.shade100,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(child: Text('No categories found'));
            }
          }),
    );
  }
}
//
// import 'package:flutter/material.dart';
// import 'package:grocery_app/model/item.dart';
//
// import '../../constants/constants.dart';
// import '../../firebase/firebase_service.dart';
//
// class ItemListView extends StatefulWidget {
//   const ItemListView({super.key});
//
//   @override
//   State<ItemListView> createState() => _ItemListViewState();
// }
//
// class _ItemListViewState extends State<ItemListView> {
//   Future<void> _showDeleteDialog(Item item, BuildContext context) async {
//     var res = await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Are you sure you want to delete this item?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, false);
//               },
//               child: const Text('CANCEL'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//               child: const Text('DELETE'),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (res) {
//       await FirebaseService().deleteItem(item.id!);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           'Item List',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.green,
//       ),
//       backgroundColor: Colors.grey.shade200,
//       body: SafeArea(
//         child: StreamBuilder<List<Item>>(
//             stream: FirebaseService().itemStream,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                     child: CircularProgressIndicator(
//                   color: Colors.redAccent,
//                 ));
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else if (snapshot.hasData) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ListView.builder(
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) {
//                       Item item = snapshot.data![index];
//                       return Card(
//                         color: Colors.white,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5)),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 5),
//                           child: ListTile(
//                             isThreeLine: true,
//                             onTap: () {
//                               Navigator.pushNamed(
//                                   context, AppConstant.productView,
//                                   arguments: snapshot.data![index]);
//                             },
//                             leading: Image.network(
//                               item.imageUrl,
//                               width: 80,
//                               height: 80,
//                             ),
//                             subtitle: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 SizedBox(
//                                   height: 24,
//                                   child: Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           item.name,
//                                           style: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Text(item.description),
//                                 Text('Price : ${item.price} /${item.unit}'),
//                                 Text('Stock : ${item.stock} ${item.unit}'),
//                               ],
//                             ),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Checkbox(
//                                   value: snapshot.data![index].inTop,
//                                   onChanged: (value) {
//                                     FirebaseService().updateInTopStatus(
//                                         snapshot.data![index].id!, value!);
//                                   },
//                                 ),
//                                 IconButton(
//                                   onPressed: () {
//                                     _showDeleteDialog(
//                                         snapshot.data![index], context);
//                                   },
//                                   icon: Icon(
//                                     Icons.delete,
//                                     color: Colors.grey.shade400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             /*trailing: IconButton(
//                               onPressed: () {
//                                 */ /*_showDeleteDialog(
//                                     snapshot.data![index], context);*/ /*
//                               },
//                               icon: Icon(
//                                 Icons.delete,
//                                 color: Colors.grey.shade400,
//                               ),
//                             ),*/
//                             /*isThreeLine: true,*/
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               } else {
//                 return const Center(child: Text('No categories found'));
//               }
//             }),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, AppConstant.productView);
//         },
//         backgroundColor: Colors.green.shade100,
//         child: const Icon(
//           Icons.add,
//         ),
//       ),
//     );
//   }
// }
