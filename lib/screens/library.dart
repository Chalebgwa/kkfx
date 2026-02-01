import 'package:flutter/material.dart';

class BookList extends StatelessWidget {
  const BookList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Library"
        ),
      ),
      body: ListView.builder(
          itemCount: 34,
          itemBuilder: (BuildContext context,int i){
            return ListTile(
              title: Text("book $i"),
              subtitle: const Text("Text"),
              isThreeLine: true,
              trailing: const Icon(Icons.check_box),
            );
          }),
    );


  }
}

class BookView extends StatelessWidget {

  final Book? book;

  const BookView({Key? key, this.book}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book?.name ?? ''),
      ),
      body: Text(book?.content ?? ''),
    );
  }
}

class Book {

  final String? name;
  final String? content;

  const Book({this.name,this.content});

}