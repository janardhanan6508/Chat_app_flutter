import 'package:chat_app_flutter/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chart_screen';

  const ChatScreen({super.key});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  late String messageText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser!;
      loggedInUser = user;
      print(loggedInUser);
    } catch (e) {
      print(e);
    }
  }

  /*
* This method to fetch data only once
* we need to fetch data by pressing button each time.
* */

  // void getMessages() async {
  //   await _fireStore.collection('messages').get().then((event) {
  //     for (var message in event.docs) {
  //       print(message.data());
  //     }
  //   });
  // }

/*
* This method to fetch data in stream
* if any change in fireStore, it notify in app
* */

  // void getMessagesStream() async {
  //   await for (var snapshot in _fireStore.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            // getMessagesStream();
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImageIcon(
              AssetImage('images/left.png'),
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _auth.signOut();
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ImageIcon(
                AssetImage('images/cancel.png'),
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder(
              stream: _fireStore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!.docs.reversed.toList();
                print(messages);
                List<MessageBubble> messageBubbles = [];
                for (var message in messages) {
                  Map<String, dynamic> data = message.data();
                  final messageText = data['text'];
                  final messageSender = data['sender'];
                  final currentUser = loggedInUser.email;
                  final messageBubble = MessageBubble(
                      text: messageText,
                      sender: messageSender,
                      isMe: currentUser == messageSender);
                  messageBubbles.add(messageBubble);
                }
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: ListView(
                      reverse: true,
                      children: messageBubbles,
                    ),
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _fireStore.collection("messages").add(
                          {'text': messageText, 'sender': loggedInUser.email});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {super.key,
      required this.text,
      required this.sender,
      required this.isMe});
  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          sender,
          style: TextStyle(color: Colors.white54),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Material(
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            elevation: 5.0,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                '$text',
                style: TextStyle(
                    fontSize: 15.0, color: isMe ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
    ;
  }
}
