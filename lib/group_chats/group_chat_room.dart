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
import 'package:intl/intl.dart';
import 'package:animations/animations.dart';

class GroupChatRoom extends StatefulWidget {

  final String groupChatId, groupName;
  GroupChatRoom({required this.groupName, required this.groupChatId});

  @override
  State<GroupChatRoom> createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom> {

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController scrollController = new ScrollController();

  bool alreadyScrolled = false;
  bool isLoading = true;
  File? imageFile;
  late bool userUIDFound;
  String userUIDString = "";
  List<String> userUIDList = [];

  Future getImage() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      uploadImage(image);
    }
  }

  Future uploadImage(image) async {

    // ADD TO FIREBASE STORAGE
    String tempURL;
    Reference storageReference = FirebaseStorage.instance.ref().child('images/' + DateTime.now().millisecondsSinceEpoch.toString());
    UploadTask uploadTask = storageReference.putFile(File(image.path));
    uploadTask.then((res) async {
      tempURL = await res.ref.getDownloadURL();
      await _firestore
          .collection('groups')
          .doc(widget.groupChatId)
          .collection('chats').add({
        "sendBy": _auth.currentUser!.uid,
        "message": "",
        "type": "img",
        "imageURL": tempURL,
        "uid": _auth.currentUser!.uid,
        "time": DateTime.now().millisecondsSinceEpoch,
      });
      scrollToEnd();
    });
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "sendBy": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "uid": _auth.currentUser!.uid,
        "time": DateTime.now().millisecondsSinceEpoch,
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
      }
    }

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
          color: Colors.grey,
        ),
      );
    }
  }

  Widget messageTile(Size size, Map<String, dynamic> chatMap, BuildContext context) {
    return Builder(builder: (_) {
      if (chatMap['type'] == "text") {
        return Align(
          alignment: chatMap['uid'] == _auth.currentUser!.uid ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding:  chatMap['uid'] == _auth.currentUser!.uid ? EdgeInsets.only(left: MediaQuery.of(context).size.width / 2) : EdgeInsets.only(right: MediaQuery.of(context).size.width / 2),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: chatMap['uid'] == _auth.currentUser!.uid ? Colors.grey[500] : Colors.grey[700],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: chatMap['uid'] == _auth.currentUser!.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  chatMap['uid'] == _auth.currentUser!.uid ? Container(width: 0.0) : printText(chatMap['uid']),
                  chatMap['uid'] == _auth.currentUser!.uid ? Container(width: 0.0) : SizedBox(height: size.height / 200),
                  Text(
                    chatMap['message'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: size.height / 200),
                  Text(
                    DateFormat("dd MMM - HH:mm").format(DateTime.fromMillisecondsSinceEpoch(int.parse(chatMap['time'].toString()))),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[100],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else if (chatMap['type'] == "img") {
        return Align(
          alignment: chatMap['uid'] == _auth.currentUser!.uid ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding:  chatMap['uid'] == _auth.currentUser!.uid ? EdgeInsets.only(left: MediaQuery.of(context).size.width / 2) : EdgeInsets.only(right: MediaQuery.of(context).size.width / 2),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: chatMap['uid'] == _auth.currentUser!.uid ? Colors.grey[500] : Colors.grey[700],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: chatMap['uid'] == _auth.currentUser!.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  chatMap['uid'] == _auth.currentUser!.uid ? Container(width: 0.0) : printText(chatMap['uid']),
                  chatMap['uid'] == _auth.currentUser!.uid ? Container(width: 0.0, height: 5.0) : Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: SizedBox(height: size.height / 200),
                  ),
                  OpenContainer(
                    openBuilder: (BuildContext context, void Function({Object? returnValue}) action) {
                      return Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Dismissible(
                                    direction: DismissDirection.vertical,
                                    key: UniqueKey(),
                                    onDismissed: (_) => Navigator.of(context).pop(),
                                    child: Image.network(
                                      chatMap['imageURL'],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 70.0, left: 15.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.close,
                                size: 35.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    closedBuilder: (BuildContext context, void Function() action) {
                      return Container(
                        color: chatMap['uid'] == _auth.currentUser!.uid ? Colors.grey[500] : Colors.grey[700],
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.network(
                            chatMap['imageURL'],
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: SizedBox(height: size.height / 200),
                  ),
                  Text(
                    DateFormat("dd MMM - HH:mm").format(DateTime.fromMillisecondsSinceEpoch(int.parse(chatMap['time'].toString()))),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[100],
                    ),
                  ),
                ],
              ),
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

  void getUserUID() {
    // GET ALL THE NAMES OF THE GROUP BY UID
    _firestore.collection('groups').doc(widget.groupChatId).get().then((value) {
      userUIDList.clear();
      for (int i = 0; i < value.data()!['members'].length; i++) {
        setState(() {
          userUIDList.add(value.data()!['members'][i]['uid']  + "," + value.data()!['members'][i]['name']);
        });
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserUID();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {

    });
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
      body: isLoading ? Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ) :
      Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: Column(
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

                        if (alreadyScrolled == false) {
                          Future.delayed(const Duration(milliseconds: 100), () {
                            scrollToEnd();
                          });
                          alreadyScrolled = true;
                        }

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