import "package:flutter/material.dart";

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class Discussions extends StatelessWidget {
  const Discussions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discussions"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: const Icon(Icons.edit),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int i) {
          return const _ListItem(
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
  final String? username;
  final Widget? content;
  final int? id;
  final List<String>? comments;

  const _ListItem(
      {Key? key, this.username, this.content, this.id, this.comments})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListItemState(username, content, id, comments);
  }
}

class _ListItemState extends State<_ListItem> {
  final String? username;
  final Widget? content;
  final int? id;
  final List<String>? comments;

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
        builder: (BuildContext context) => const Comments()
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
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/pp.jpg"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(username ?? ''),
                )
              ],
            ),
            content ?? Container(),

            ButtonBar(
              mainAxisSize: MainAxisSize.min,
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(icon: const Icon(Icons.thumb_up), onPressed: increment_likes),
                Text(num_likes == 0 ? " ": num_likes.toString()),
                IconButton(icon: const Icon(Icons.comment), onPressed: (){
                  open_comments(context);
                }),
                Text(num_comments == 0 ? " ": num_comments.toString()),
                IconButton(icon: const Icon(Icons.share), onPressed: increment_comments),
              ],
            )

          ],
        ),
      ),
    );
  }
}

class Comment extends StatelessWidget {

  final String? username;
  final Widget? content;
  final String? time;
  final AnimationController? animationController;
  const Comment({Key? key, this.username,this.content,this.time,this.animationController}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: animationController!,
          curve: Curves.easeIn),
        axisAlignment: 0.0,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(child: Text((username ?? '')[0])),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(username ?? '', style: Theme.of(context).textTheme.titleMedium),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: content ?? Container()
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );

  }

}


class Comments extends StatefulWidget {
  const Comments({Key? key}) : super(key: key);

  @override
  State createState() => CommentState();
}


class CommentState extends State<Comments> with TickerProviderStateMixin {
  final List<Comment> _comments = <Comment>[];
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comments")),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _comments[index],
              itemCount: _comments.length,
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration:
            BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (Comment comment in _comments)
      comment.animationController?.dispose();
    super.dispose();
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onChanged: (String text) {
                setState(() {
                  _isComposing = text.length > 0;
                });
              },
              onSubmitted: _handleSubmitted,
              decoration:
              const InputDecoration.collapsed(hintText: "Comment"),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _isComposing
                  ? () => _handleSubmitted(_textController.text)
                  : null,
            ),
          )
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });

    Comment comment = Comment(
      username: "Pako Chalebgwa",
      content: Text(text),
      animationController: AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _comments.insert(0, comment);
    });
    comment.animationController?.forward();
  }
}