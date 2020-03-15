import 'package:flutter/material.dart';
import 'package:flutter_app/resources/firebase_repository.dart';
import 'package:flutter_app/utils/universal_variables.dart';
import 'package:flutter_app/utils/utilities.dart';
import 'package:flutter_app/widgets/appbar.dart';
import 'package:flutter_app/widgets/custom_tile.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

final FirebaseRepository _repository = FirebaseRepository();

class _ChatListScreenState extends State<ChatListScreen> {

  String currentUserID;
  String initials;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrentUser().then((user){
      setState(() {
        currentUserID = user.uid;
        initials = Utils.getInitials(user.displayName);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(currentUserID),
    );
  }

 CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(Icons.notifications),
        color: Colors.white,
        onPressed: (){},
      ),
      title: UserCircle(initials) ,
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/search_screen');

          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
 }
}

class UserCircle extends StatelessWidget {
  final String  text;

  const UserCircle( this.text);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: UniversalVariables.separatorColor,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: UniversalVariables.onlineDotColor
                  )
                ),
              ),
          )
        ],
      ),
    );
  }
}

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: UniversalVariables.fabGradient,
        borderRadius: BorderRadius.circular(50)
      ),
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 16,
      ),
      padding: EdgeInsets.all(15),
    );
  }
}


class ChatListContainer extends StatefulWidget {

  final String currentUserId;

  const ChatListContainer(this.currentUserId);

  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
          itemCount: 2,
          itemBuilder: (context, index){
            return CustomTile(
              mini: false,
              onTap: () {},
              title: Text(
                "Wilson Pinto",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Arial",
                  fontSize: 19
                ),
              ),
              subtitle: Text(
                "Hello",
                style: TextStyle(
                  color: UniversalVariables.greyColor,
                  fontSize: 14,
                ),
              ),
              leading: Container(
                constraints: BoxConstraints(
                  maxHeight: 60, maxWidth: 60
                ),
                child: Stack(
                  children: <Widget>[
                    CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        "https://lh3.googleusercontent.com/a-/AOh14GifH4CKC2b6fCIYwORXZM7Uc-PTMjL71tE3TCehng=s96-c"
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 13,
                        width: 13,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: UniversalVariables.onlineDotColor,
                            border: Border.all(
                                color: UniversalVariables.blackColor,
                                width: 2
                            )
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
