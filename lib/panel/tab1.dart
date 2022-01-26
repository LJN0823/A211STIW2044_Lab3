import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab3/class/user.dart';

class OrderPage extends StatefulWidget {
  final User user;
  const OrderPage({Key? key, required this.user}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late ScrollController scrollController;
  int scrollcount = 10;
  int rowcount = 2;
  int totalorder = 0;
  List orderlist = [];
  String titlecenter = "Loading order...";
  
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    _loadOrder();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }

    return Center(
      child: Text(widget.user.loc.toString()),
    );
  }

  void _loadOrder() {}

  void _scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        if (orderlist.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= orderlist.length) {
            scrollcount = orderlist.length;
          }
        }
      });
    }
  }
}