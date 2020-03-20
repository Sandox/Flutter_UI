import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Category extends StatefulWidget {
  static const routeName = '/category';
  String item;
  String randomJoke;


  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool isLoading = true;
  getRandomJoke(String category) async {
    var response = await http.get(
        'http://10.0.2.2:8080/api/category/get_joke_by_category/$category');
    print(response.body);
    if (response.statusCode == 200 && isLoading) {
      widget.randomJoke = response.body;
      print(widget.randomJoke);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    print(routeArgs);
    widget.item = routeArgs['item'];
    getRandomJoke(widget.item);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item),
      ),
      body: Container(
        child: Center(
          child: Card(
            borderOnForeground: true,
            elevation: 12,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: isLoading
                ? CircularProgressIndicator()
                : Text(widget.randomJoke, style: TextStyle(fontSize: 40),),
          ),
        ),
      ),
    );
  }
}
