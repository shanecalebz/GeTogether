import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../utils/constants.dart';
import 'group_info.dart';

class GroupChatRoomTemp extends StatefulWidget {

  final String groupChatId, groupName;
  GroupChatRoomTemp({required this.groupName, required this.groupChatId});

  @override
  State<GroupChatRoomTemp> createState() => _GroupChatRoomTempState();
}

class _GroupChatRoomTempState extends State<GroupChatRoomTemp> {

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController scrollController = new ScrollController();

  File? imageFile;
  late bool userUIDFound;
  String userUIDString = "";
  List<String> userUIDList = [];

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('groups')
        .doc(widget.groupChatId)
        .collection('chats').doc(fileName).set({
      "sendby": _auth.currentUser!.displayName,
      "message": "",
      "type": "img",
      "uid": _auth.currentUser!.uid,
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
    FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('groups')
          .doc(widget.groupChatId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('groups')
          .doc(widget.groupChatId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }


  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "sendBy": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "uid": _auth.currentUser!.uid,
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();

      await _firestore
          .collection('groups')
          .doc(widget.groupChatId)
          .collection('chats')
          .add(chatData);

      // SCROLL TO END
      scrollToEnd();
    }
  }

  void scrollToEnd() {
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve:Curves.fastOutSlowIn);
  }

  Widget printText(String uid) {
    userUIDFound = false;
    for (int i = 0; i < userUIDList.length; i++) {
      if (uid == userUIDList[i].split(',')[0]) {
        userUIDFound = true;
        userUIDString = userUIDList[i].split(',')[1];
        print("YES");
      }
    }
    print("NO");

    if (userUIDFound == true) {
      return Text(
        userUIDString,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    } else {
      return Text(
        'User Not Found',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      );
    }
  }

  Widget messageTile(Size size, Map<String, dynamic> chatMap, BuildContext context) {

    // GET ALL THE NAMES OF THE GROUP BY UID
    _firestore.collection('groups').doc(widget.groupChatId).get().then((value) {
      userUIDList.clear();
      for (int i = 0; i < value.data()!['members'].length; i++) {
        setState(() {
          userUIDList.add(value.data()!['members'][i]['uid']  + "," + value.data()!['members'][i]['name']);
        });
      }
    });

    return Builder(builder: (_) {
      if (chatMap['type'] == "text") {
        return chatMap['type'] == "text" ? Container(
          width: size.width,
          alignment: chatMap['uid'] == _auth.currentUser!.uid
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blueAccent,
              ),
              child: Column(
                crossAxisAlignment: chatMap['uid'] == _auth.currentUser!.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  printText(chatMap['uid']),
                  SizedBox(
                    height: size.height / 200,
                  ),
                  Text(
                    chatMap['message'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
        ) : Container(
          height: size.height / 2.5,
          width: size.width,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          alignment: chatMap['uid'] == _auth.currentUser!.uid
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ShowImage(
                  imageUrl: chatMap['message'],
                ),
              ),
            ),

          ),
        );
      } else if (chatMap['type'] == "img") {
        return Container(
          width: size.width,
          alignment: chatMap['uid'] == _auth.currentUser!.uid
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            height: size.height / 2.5,
            width: size.width / 2,
            decoration: BoxDecoration(border: Border.all()),
            alignment: chatMap['message'] != "" ? null : Alignment.center,
            child: Image.network(
              chatMap['message'],
              fit: BoxFit.cover,
            ),
          ),
        );
      } else if (chatMap['type'] == "notify") {
        return Container(
          width: size.width,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black38,
            ),
            child: Text(
              chatMap['message'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        return SizedBox();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) { scrollToEnd(); });
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        backgroundColor: Palette.primaryColor,
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => GroupInfo(
                    groupName: widget.groupName,
                    groupId: widget.groupChatId,
                  ),
                ),
              ),
              icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('groups')
                  .doc(widget.groupChatId)
                  .collection('chats')
                  .orderBy('time')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> chatMap =
                      snapshot.data!.docs[index].data()
                      as Map<String, dynamic>;

                      return messageTile(size, chatMap, context);
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          Container(
            height: size.height / 10,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height / 12,
              width: size.width / 1.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.height / 17,
                    width: size.width / 1.3,
                    child: TextField(
                      controller: _message,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () => getImage(),
                            icon: Icon(Icons.photo),
                          ),
                          hintText: "Send Message",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.send), onPressed: onSendMessage),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}