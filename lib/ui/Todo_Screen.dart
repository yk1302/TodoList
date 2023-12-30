import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsipify/ui/AddInTodo_Screen.dart';
import 'package:newsipify/utils/FlutterToast.dart';

import '../widget/round_button.dart';

class TodoScreen extends StatefulWidget {
  final String uname;

  TodoScreen(this.uname);

  @override
  State<TodoScreen> createState() => _TodoScreenState(this.uname);
}

class _TodoScreenState extends State<TodoScreen> {
  final String userName;

  _TodoScreenState(this.userName);

  final filterController = TextEditingController();
  final titleUpdateController = TextEditingController();
  final descriptionUpdateController = TextEditingController();
  bool loading = false;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool _validatetitle = false;
  bool _validatedescription = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        title: Center(
            child: Text(
          "TODO",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddDataTodoScreen(this.userName)));
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              controller: filterController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  //label: Text("Enter Email"),
                  labelText: 'Search',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.deepPurpleAccent,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2))),
              autofocus: true,
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          SizedBox(
            height: 40,
          ),

          Expanded(
            child: FirebaseAnimatedList(
                query: FirebaseDatabase.instance.ref('Todo'),
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  final subtitle =
                      snapshot.child('description').value.toString();
                  if (filterController.text.isEmpty) {
                    return ListTile(
                        onLongPress: () {
                          showDeleteDialogue(title, subtitle,
                              snapshot.child('id').value.toString(), snapshot);
                        },
                        onTap: () {
                          showMyDialog(title, subtitle,
                              snapshot.child('id').value.toString());
                        },
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(
                            snapshot.child('description').value.toString()));
                  } else if ((title.toLowerCase().contains(
                          filterController.text.toLowerCase().toString())) ||
                      (subtitle.toLowerCase().contains(
                          filterController.text.toLowerCase().toString()))) {
                    return ListTile(
                        onLongPress: () {
                          showDeleteDialogue(title, subtitle,
                              snapshot.child('id').value.toString(), snapshot);
                        },
                        onTap: () {
                          showMyDialog(title, subtitle,
                              snapshot.child('id').value.toString());
                        },
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(
                            snapshot.child('description').value.toString()));
                  } else {
                    return Container();
                  }
                }),
          ), //firebaseAnimatedList
        ],
      ),
    );
  }

  Future<void> showMyDialog(String title, String subtitle, String id) async {
    titleUpdateController.text = title;
    descriptionUpdateController.text = subtitle;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update'),
            content: Column(
              children: [
                TextField(
                    maxLength: 50,
                    controller: titleUpdateController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        //label: Text("Enter Email"),
                        labelText: 'Enter New Title',
                        prefixIcon: Icon(
                          Icons.textsms,
                          color: Colors.deepPurpleAccent,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2))),
                    autofocus: true),
                TextField(
                    maxLength: 50,
                    controller: descriptionUpdateController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        //label: Text("Enter Email"),
                        labelText: 'Enter New Description',
                        prefixIcon: Icon(
                          Icons.description_outlined,
                          color: Colors.deepPurpleAccent,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2))),
                    autofocus: true),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    FirebaseDatabase.instance.ref('Todo').child(id).update({
                      'title': titleUpdateController.text.toString(),
                      'description':
                          descriptionUpdateController.text.toString(),
                    }).then((value) {
                      FlutterToast().toast("Updating");
                    }).onError((error, stackTrace) {
                      FlutterToast().toast(error.toString());
                    });
                  },
                  child: Text('Update')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'))
            ],
          );
        });
  }

  Future<void> showDeleteDialogue(
      String title, String subtitle, String id, DataSnapshot snapshot) async {
    titleUpdateController.text = title;
    descriptionUpdateController.text = subtitle;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.delete),
                Text('Confirm Delete?'),
              ],
            ),
            content: Column(
              children: [
                TextField(
                    enabled: false,
                    maxLength: 50,
                    controller: titleUpdateController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      //label: Text("Enter Email"),
                      labelText: 'Enter New Name',
                      prefixIcon: Icon(
                        Icons.text_fields,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                    autofocus: true),
                TextField(
                    enabled: false,
                    maxLength: 50,
                    controller: descriptionUpdateController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        //label: Text("Enter Email"),
                        labelText: 'Description',
                        prefixIcon: Icon(
                          Icons.numbers_rounded,
                          color: Colors.deepPurpleAccent,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide(
                            color: Colors.deepPurpleAccent,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2))),
                    autofocus: true),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    FirebaseDatabase.instance
                        .ref('Todo')
                        .child(snapshot.child('id').value.toString())
                        .remove()
                        .then((value) {
                      FlutterToast().toast("Contact Deleted");
                    }).onError((error, stackTrace) {
                      FlutterToast().toast(error.toString());
                    });
                  },
                  child: Text('Delete')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'))
            ],
          );
        });
  }
}
