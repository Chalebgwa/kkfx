import "package:flutter/material.dart";

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class Discussions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discussions"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.edit),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int i) {
          return _ListItem(
            username: "Pako Chalebgwa",
            content: Text("This is test text, it is no way meant"),
          );
        },
        itemCount: 10,
        shrinkWrap: true,
      ),
    );
  }
}

class _ListItem extends StatefulWidget {
  final String username;
  final Widget content;
  final int id;
  final List<String> comments;

  const _ListItem(
      {Key key, this.username, this.content, this.id, this.comments})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _ListItemState(username, content, id, comments);
  }
}

class _ListItemState extends State<_ListItem> {
  final String username;
  final Widget content;
  final int id;
  final List<String> comments;

  int num_likes = 0;
  int num_comments = 0;

  _ListItemState(this.username, this.content, this.id, this.comments);

  void increment_likes() {
    setState(() {
      num_likes++;
    });
  }

  void increment_comments() {
    setState(() {
      num_comments++;
    });
  }

  void open_comments(BuildContext context){
    Navigator.push(context, MaterialPageRoute<DismissDialogAction>(
        builder: (BuildContext context) => Comments()
    )
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        child: Column(
          children: <Widget>[

            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/pp.jpg"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(this.username),
                )
              ],
            ),
            this.content,

            ButtonBar(
              mainAxisSize: MainAxisSize.min,
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(icon: Icon(Icons.thumb_up), onPressed: increment_likes),
                Text(this.num_likes == 0 ? " ": this.num_likes.toString()),
                IconButton(icon: Icon(Icons.comment), onPressed: (){
                  open_comments(context);
                }),
                Text(this.num_comments == 0 ? " ": this.num_comments.toString()),
                IconButton(icon: Icon(Icons.share), onPressed: increment_comments),
              ],
            )

          ],
        ),
      ),
    );
  }
}

class Comment extends StatelessWidget {

  final String username;
  final Widget content;
  final String time;
  final AnimationController animationController;
  const Comment({this.username,this.content,this.time,this.animationController});


  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      //new
        sizeFactor: new CurvedAnimation(
          //new
            parent: animationController,
            curve: Curves.easeIn), //new
        axisAlignment: 0.0, //new
        child: new Container(
          //modified
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(child: new Text(this.username[0])),
              ),
              new Expanded(
                //new
                child: new Column(
                  //modified
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(this.username, style: Theme.of(context).textTheme.subhead),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: this.content
                    ),
                  ],
                ),
              ),
            ],
          ),
        ) //new
    );

  }

}


class Comments extends StatefulWidget {
  //modified
  @override //new
  State createState() => new CommentState(); //new
}


class CommentState extends State<Comments> with TickerProviderStateMixin {
  final List<Comment> _comments = <Comment>[];
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  @override //new
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Comments")),
      body: new Column(
        //m odified
        children: <Widget>[
          //new
          new Flexible(
            //new
            child: new ListView.builder(
              //new
              padding: new EdgeInsets.all(8.0), //new
              reverse: true, //new
              itemBuilder: (_, int index) => _comments[index], //new
              itemCount: _comments.length, //new
            ), //new
          ), //new
          new Divider(height: 1.0), //new
          new Container(
            //new
            decoration:
            new BoxDecoration(color: Theme.of(context).cardColor), //new
            child: _buildTextComposer(), //modified
          ), //new
        ], //new
      ), //new
    );
  }

  @override
  void dispose() {
    //new
    for (Comment comment in _comments) //new
      comment.animationController.dispose(); //new
    super.dispose(); //new
  }

  Widget _buildTextComposer() {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          new Flexible(
            child: new TextField(
              controller: _textController,
              onChanged: (String text) {
                setState(() {
                  //new
                  _isComposing = text.length > 0; //new
                });
              },
              onSubmitted: _handleSubmitted,
              decoration:
              new InputDecoration.collapsed(hintText: "Comment"),
            ),
          ),
          new Container(
            //new
            margin: new EdgeInsets.symmetric(horizontal: 4.0), //new
            child: new IconButton(
              //new
              icon: new Icon(Icons.send), //new
              onPressed: _isComposing
                  ? () => _handleSubmitted(_textController.text)
                  : null, //new
            ),
          ) //new
        ],
      ),
    );
  }

  //new
  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      //new
      _isComposing = false; //new
    });

    Comment comment = new Comment(
      username: "Pako Chalebgwa",
      content: Text(text),
      animationController: new AnimationController(
        //new
        duration: new Duration(milliseconds: 700), //new
        vsync: this, //new
      ), //new
    ); //new
    setState(() {
      _comments.insert(0, comment);
    });
    comment.animationController.forward(); //new
  }
}