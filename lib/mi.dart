import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmfx/const.dart';




List<Chat> messages = List.generate(100, (int i){
  return new Chat(user:i.toString(),messages: List.generate(10, (int k)=> Message(id: i,timestamp: DateTime.now().millisecondsSinceEpoch.toString(),idFrom: "Other",content: "assets/pp.jpg",type: 2)));
});

class Message {

  final String idFrom;
  final String content;
  final int type;
  final int id;
  final String timestamp;

  Message({this.id, this.timestamp, this.idFrom, this.content, this.type});

}

class Chat {

  final String user;
  final String userAvatar;
  final List<Message> messages;

  Chat({this.userAvatar ,this.user, this.messages});

  @override
  String toString () {
    return "chat with $user";
  }


}

class ChatList extends StatefulWidget {

  ChatList({Key key}) : super(key: key);

  @override
  ChatListState createState() {
    return new ChatListState();
  }
}





class ChatListState extends State<ChatList> {

  final _Delegate _delegate = _Delegate();

  @override
  Widget build(BuildContext context) {
    var scrollController = ScrollController(
        keepScrollOffset: true
    );
    return Scaffold(
      floatingActionButton: FloatingActionButton(child:Icon(Icons.add),onPressed: null),
      appBar: AppBar(
        title: Icon(Icons.mail),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () async {

              final Chat selected  = await showSearch<Chat> (
                  context: context,
                  delegate: _delegate
              );

            },
          )
        ],
      ),
      body: Container(

        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: _buildItem,
          controller: scrollController,
        ),
      ),
    );
  }

  void create_chat(){

  }

  void delete_message(BuildContext context,int i){
    showDialog<String>(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Delete"),
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: (){

                  setState((){
                    Navigator.pop(context);
                    messages.removeAt(i);
                  });
                },
              ),
              FlatButton(
                child: Text("Cancel"),
              )
            ],
          );
        }
    );
  }

  void openChat(BuildContext context){

  }

  void openDialog(BuildContext context,int i){
    showDialog(

        context: context,
        builder:(context){
          return SimpleDialog(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0)
            ),
            title: Text("Options"),
            children: <Widget>[
              ListTile(
                title: Text("delete"),
                onTap: (){
                  Navigator.pop(context);
                  delete_message(context,i);
                },
              ),
              ListTile(title: Text("mark as unread"),),
              ListTile(title: Text("block user"),),
              ListTile(title: Text("archive"),),

            ],
          );
        }
    );
  }

  Widget _buildItem(BuildContext context,int i){

    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext c){
            return ChatView(chat: messages[i],);
          }));
        },
        leading: CircleAvatar(
          backgroundImage: AssetImage("assets/pp.jpg"),
        ),
        title: Text(messages[i].user),
        subtitle: Text("hello"),
        trailing: Column(
          children: <Widget>[
            Text("16:56"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.check,
                size: 15.0,
              ),
            )
          ],
        ),
        onLongPress: (){
          openDialog(context,i);
        },

      ),
    );

  }
}

class ChatView extends StatefulWidget {

  final Chat chat;


  const ChatView({Key key, this.chat}) : super(key: key);

  @override
  ChatViewState createState() {
    return new ChatViewState();
  }
}

class ChatViewState extends State<ChatView> {

  SharedPreferences prefs;
  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;
  String groupChatId;
  String id;
  var listMessage;




  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();
  String peerId;
  String peerAvatar = "assets/pp.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                // List of messages
                buildListMessage(),

                (isShowSticker ? buildSticker() : Container()),
                // Input content
                buildInput(),
              ],
            ),

            // Loading
            buildLoading()
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: getImage,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.face),
                onPressed: getSticker,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Material(
              child: Container(
                child: TextField(
                  style: TextStyle(color: primaryColor, fontSize: 15.0),
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(color: greyColor),
                  ),
                  focusNode: focusNode,
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(color: greyColor2, width: 0.5)), color: Colors.white),
    );
  }

  Widget buildItem(int index) {

    var message = widget.chat.messages[index];

    if (index%2 == 0) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
              message.content,
              style: TextStyle(color: primaryColor),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(color: greyColor2, borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );

    } else {
      // Left (peer message)
      return Row(
        children: <Widget>[
          Container(
            child: Text(
              message.content,
              style: TextStyle(color: primaryColor),
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(color: greyColor, borderRadius: BorderRadius.circular(8.0)),
            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      );
    }
  }




  Widget buildListMessage() {
    return Flexible(
        child: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index) => buildItem(index),
          itemCount: widget.chat.messages.length,
          reverse: true,
          controller: listScrollController,
        )

    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
        ),
        color: Colors.white.withOpacity(0.8),
      )
          : Container(),
    );
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi1', 2),
                child: new Image.asset(
                  'images/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', 2),
                child: new Image.asset(
                  'images/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', 2),
                child: new Image.asset(
                  'images/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi4', 2),
                child: new Image.asset(
                  'images/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', 2),
                child: new Image.asset(
                  'images/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', 2),
                child: new Image.asset(
                  'images/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi7', 2),
                child: new Image.asset(
                  'images/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', 2),
                child: new Image.asset(
                  'images/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', 2),
                child: new Image.asset(
                  'images/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(color: greyColor2, width: 0.5)), color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }




  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    peerId = widget.chat.user;
    peerAvatar = widget.chat.userAvatar;

    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';

    readLocal();

  }


  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1].idFrom == id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }



  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1].idFrom != id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }


  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }


}

class _Delegate extends SearchDelegate<Chat> {


  final Iterable<Chat> _history = List<Chat>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      query.isEmpty
          ? IconButton(
        tooltip: 'Voice Search',
        icon: const Icon(Icons.mic),
        onPressed: () {
          query = 'TODO: implement voice input';
        },
      )
          : IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    Iterable<Chat> suggestions;

    if (query == null) {

      return Center(
        child: Text(
          '"$query"\n is not a available.',
          textAlign: TextAlign.center,
        ),
      );

    } else {

      suggestions = messages.where((Chat m) => m.user.contains(query));
    }

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (BuildContext context,int i){
          return _ResultCard(
            title: suggestions.elementAt(i).user,
            message: suggestions.elementAt(i),
            searchDelegate: this,
          );

        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    Iterable<Chat> suggestions;

    if (query.isEmpty) {
      suggestions = _history;
    } else {

      suggestions = messages.where((Chat m) => m.user.startsWith(query));
    }

    return _SuggestionList(
      query: query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }
}

class _ResultCard extends StatelessWidget {
  final Chat message;

  final String title;
  final SearchDelegate<Chat> searchDelegate;
  const _ResultCard({this.message, this.title, this.searchDelegate});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => new ChatView(chat: message,)));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(title),
              Text(
                message.user,
                style: theme.textTheme.headline.copyWith(fontSize: 40.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _SuggestionList extends StatelessWidget {
  final List<Chat> suggestions;

  final String query;
  final ValueChanged<String> onSelected;
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i].user;
        return ListTile(
          leading: query.isEmpty ? const Icon(Icons.history) : const Icon(null),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: theme.textTheme.subhead,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}