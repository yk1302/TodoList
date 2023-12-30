import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsipify/utils/FlutterToast.dart';
import 'package:newsipify/widget/round_button.dart';

class AddDataTodoScreen extends StatefulWidget {
  final String uname;

  AddDataTodoScreen(this.uname);

  @override
  State<AddDataTodoScreen> createState() => _AddDataTodoScreenState(this.uname);
}

class _AddDataTodoScreenState extends State<AddDataTodoScreen> {
  final String userId;

  _AddDataTodoScreenState(this.userId);
 
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool _validatetitle = false;
  bool _validatedescription = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        title: Center(
            child: Text(
          "Add Remainder",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
                maxLength: 50,
                controller: titleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    //label: Text("Enter Email"),
                    labelText: 'Enter Title',
                    errorText: _validatetitle ? 'Title is Nessary.' : null,
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
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 2))),
                autofocus: true),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
                controller: descriptionController,
                keyboardType: TextInputType.text,
                maxLines: 4,
                maxLength: 250,
                decoration: InputDecoration(
                    //label: Text("Enter Email"),
                    labelText: 'Enter Description',
                    errorText:
                        _validatedescription ? 'Description Required.' : null,
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
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 2))),
                autofocus: true),
          ),
          SizedBox(
            height: 90,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: RoundButton("Submit", () {
              setState(() {
                loading = true;
              });
              titleController.text.isEmpty
                  ? _validatetitle = true
                  : _validatetitle = false;
              descriptionController.text.isEmpty
                  ? _validatedescription = true
                  : _validatedescription = false;
              if (_validatetitle == true || _validatedescription == true) {
                setState(() {});
              } else {
              
                String identity =
                    DateTime.now().millisecondsSinceEpoch.toString();
                
                FirebaseDatabase.instance.ref('Todo').child(identity).set({
                  'title': titleController.text.toString(),
                  'description': descriptionController.text.toString(),
                  'id': identity,
                 
                }).then((value) {
                  setState(() {
                    loading = false;
                  });
                  FlutterToast().toast("Data Added");
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  FlutterToast().toast(error.toString());
                });
              }
            }, loading),
          )
        ],
      ),
    );
  }
}
