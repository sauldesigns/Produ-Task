import 'package:book_read/models/user.dart';
import 'package:book_read/ui/custom_card.dart';
import 'package:book_read/ui/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewCategory extends StatefulWidget {
  NewCategory(
      {Key key,
      this.catID = 'new_category',
      this.user,
      this.listColors,
      this.update = false,
      this.initialText,
      this.colorIndex})
      : super(key: key);
  final String catID;
  final User user;
  final String initialText;
  final List<Color> listColors;
  final int colorIndex;
  final bool update;

  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  final _formkey = GlobalKey<FormState>();
  final Firestore _db = Firestore.instance;
  bool _autoValidate = false;
  String _category;
  int _colorIndex;

  @override
  void initState() {
    super.initState();
    _colorIndex = widget.colorIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _formkey,
            autovalidate: _autoValidate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 50.0, right: 50.0, top: 30.0, bottom: 40),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: widget.update == false
                                ? 'Create a new '
                                : 'Update ',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          TextSpan(
                            text: 'Category',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ]),
                  ),
                ),
                Center(
                  child: Hero(
                    tag: widget.catID,
                    child: Material(
                      child: CustomCard(
                        blurRadius: 10,
                        width: 250,
                        height: 250,
                        color: widget.listColors[_colorIndex],
                        title: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          autofocus: true,
                          cursorColor: Colors.white,
                          initialValue: widget.initialText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          keyboardType: TextInputType.text,
                          maxLines: 4,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hasFloatingPlaceholder: false,
                              hintText: 'Enter Text Here'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Must enter some text';
                            }
                            return null;
                          },
                          onSaved: (value) => _category = value,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 10),
                  child: Container(
                    height: 40,
                    child: ListView.builder(
                      itemCount: widget.listColors.length,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(left: 10),
                      itemBuilder: (context, index) {
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              _colorIndex = index;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: CircleAvatar(
                              backgroundColor: widget.listColors[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 50.0, left: 50.0, top: 30),
                  child: Center(
                    child: RoundedButton(
                      title: widget.update == false
                          ? 'Create Category'
                          : 'Update Category',
                      onClick: () {
                        _formkey.currentState.save();
                        if (_formkey.currentState.validate()) {
                          if (widget.update == false) {
                            var data = {
                              'content': _category,
                              'color': _colorIndex,
                              'createdat': DateTime.now(),
                              'done': true,
                              'uid': widget.user.uid,
                              'uids': [widget.user.uid],
                              'users': []
                            };
                            _db.collection('category').add(data);
                          } else {
                            var data = {
                              'content': _category,
                              'color': _colorIndex,
                              'done': true,
                            };
                            _db
                                .collection('category')
                                .document(widget.catID)
                                .updateData(data);
                          }

                          Navigator.of(context).pop();
                        } else {
                          setState(() {
                            _autoValidate = true;
                          });
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
