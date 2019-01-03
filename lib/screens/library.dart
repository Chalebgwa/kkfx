import 'package:flutter/material.dart';

class BookList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Library"
        ),
      ),
      body: ListView.builder(
          itemCount: 34,
          itemBuilder: (BuildContext context,int i){
            return ListTile(
              title: Text("book $i"),
              subtitle: Text("Text"),
              isThreeLine: true,
              trailing: Icon(Icons.check_box),
            );
          }),
    );


  }
}

class BookView extends StatelessWidget {

  final Book book;

  const BookView({this.book});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.book.name),
      ),
      body: Text(this.book.content),
    );
  }
}

class Book {

  final String name;
  final String content;

  const Book({this.name,this.content});

}