import 'package:flutter/material.dart';
import 'package:grocery_app/constants/constants.dart';
import 'package:grocery_app/model/category.dart';
import 'package:grocery_app/model/item.dart';
import 'package:grocery_app/views/category/category_view.dart';
import 'package:grocery_app/views/category_list/category_list_view.dart';
import 'package:grocery_app/views/home/home_view.dart';
import 'package:grocery_app/views/item/item_view.dart';
import 'package:grocery_app/views/login/login_view.dart';
import 'package:grocery_app/views/item_list/item_list_view.dart';
import 'package:grocery_app/views/orderlist/orderlist_view.dart';
import 'package:grocery_app/views/splash/splash_view.dart';
import 'package:grocery_app/views/user/user_view.dart';

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstant.splashView:
        return MaterialPageRoute(
          builder: (context) => const SplashView(),
        );
      case AppConstant.loginView:
        return MaterialPageRoute(
          builder: (context) => const LoginView(),
        );

      case AppConstant.homeView:
        return MaterialPageRoute(
          builder: (context) => const HomeView(),
        );
      case AppConstant.categoryListView:
        return MaterialPageRoute(
          builder: (context) => const CategoryListView(),
        );
      case AppConstant.categoryView:
        Category? category =
            settings.arguments != null ? settings.arguments as Category : null;

        return MaterialPageRoute(
          builder: (context) => CategoryView(
            category: category,
          ),
        );
      case AppConstant.productListView:
        return MaterialPageRoute(
          builder: (context) => const ItemListView(),
        );
      case AppConstant.productView:

        Item? item =
        settings.arguments != null ? settings.arguments as Item : null;

        return MaterialPageRoute(
          builder: (context) => ItemView(item: item,),
        );

      case AppConstant.userListView:
        return MaterialPageRoute(
          builder: (context) => const UserListView(),
        );

      case AppConstant.orderView:
        return MaterialPageRoute(
          builder: (context) => OrderListView(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const SplashView(),
        );
    }
  }
}
