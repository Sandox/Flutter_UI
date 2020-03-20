import 'package:client_flutter_app/category.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'List of Categories'),
      routes: {
        Category.routeName: (ctx) => Category()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  List<dynamic> items;
  bool isLoading = true;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  getCategories() async {
    setState(() {
      widget.isLoading = true;
    });
    var response =
        await http.get('http://10.0.2.2:8080/api/category/get_all_categories');
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        widget.items = jsonResponse;
        widget.isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: widget.isLoading
            ? CircularProgressIndicator()
            : Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        return ListTile(
                          title: GestureDetector(
                            child: Text(
                              item,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () => _onViewDetails(widget.items[index]),
                          ),
                          subtitle: GestureDetector(
                              child: Text('Click to view more'),
                          onTap: () => _onViewDetails(widget.items[index]),),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _onViewDetails(item) {
    print(item);
    Navigator.of(context).pushNamed(Category.routeName,
        arguments: {'item': item});
  }
}
