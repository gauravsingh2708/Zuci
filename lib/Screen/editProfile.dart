import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zuci/provider/user_provider.dart';
import 'package:zuci/resources/firebase_methods.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final name;
  final age;
  final uid;
  final callrate;
  final mobilenumber;
  final profile_pic;
  final onlinetime;
  final bio;
  final country;
  EditProfile(
      {this.name,
      this.uid,
      this.age,
      this.bio,
      this.callrate,
      this.mobilenumber,
      this.onlinetime,
      this.profile_pic,
      this.country});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var _image;
  String _name,
      _age,
      _callrate,
      _mobilenumber,
      _profile_pic,
      _onlinetime,
      _bio,
      _country;
  bool _isLoading;
  String profile_url;
  final _formKey = new GlobalKey<FormState>();
  FirebaseMethods firebaseMethods = FirebaseMethods();
  UserProvider userProvider;
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    _isLoading = false;
    super.initState();
  }

  Future<void> updateProfile(url) async {
    await Firestore.instance
        .collection('USER')
        .document('${widget.uid}')
        .updateData({
      'profile_pic': '$profile_url',
    }).whenComplete((){
      setState(() {
        _isLoading = false;
        _profile_pic = url;
      });
    });
  }

  Future<void> getImage() async {
    setState(() {
      _isLoading = true;
    });
    _isLoading = true;
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    profile_url =
        await firebaseMethods.uploadImageToStorage(image).whenComplete(() {
        updateProfile(profile_url).whenComplete(() {
        setState(() {
          updateProfile(profile_url);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Upadte profile'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Form(
          key: _formKey,
          child: Stack(
            children: <Widget>[
              _isLoading?Center(child: CircularProgressIndicator())
                  :
              Card(
                child: ListView(
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        radius: size.height * .07,
                        backgroundColor: Colors.red,
                        backgroundImage: NetworkImage(userProvider.getUser.profilePhoto == null
                            ? "https://images.pexels.com/photos/3762775/pexels-photo-3762775.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940"
                            :userProvider.getUser.profilePhoto),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () => getImage(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                  color: Colors.purpleAccent, fontSize: 20.0),
                            ),
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: size.height * .02,
                        right: size.height * .02,
                        top: size.height * .01,
                        bottom: size.height * .01,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Username',
                          hintText: '${userProvider.getUser.name}',
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                        ),
                        initialValue: '${userProvider.getUser.name}',
                        validator: (value) =>
                            value.isEmpty ? 'Name cann\'t empty' : null,
                        onSaved: (value) => _name = value.trim(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: size.height * .02,
                        right: size.height * .02,
                        top: size.height * .01,
                        bottom: size.height * .01,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Age',
                          hintText: '${userProvider.getUser.age}',
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                        ),
                        initialValue: '${userProvider.getUser.age}',
                        validator: (value) =>
                            value.isEmpty ? 'Age cann\'t empty' : null,
                        onSaved: (value) => _age = value.trim(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: size.height * .02,
                        right: size.height * .02,
                        top: size.height * .01,
                        bottom: size.height * .01,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Biography',
                          hintText: 'About',
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                        ),
                        initialValue: userProvider.getUser.age,
                        validator: (value) =>
                            value.isEmpty ? 'Bio cann\'t empty' : null,
                        onSaved: (value) => _bio = value.trim(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: size.height * .02,
                        right: size.height * .02,
                        top: size.height * .01,
                        bottom: size.height * .01,
                      ),
                      child: TextFormField(
                        initialValue: userProvider.getUser.phone_no,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          hintText: 'Current mobile number',
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                        ),
                        validator: (value) =>
                            value.length == 9 ? 'Enter correct number ' : null,
                        onSaved: (value) => _mobilenumber = value.trim(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: size.height * .02,
                        right: size.height * .02,
                        top: size.height * .01,
                        bottom: size.height * .01,
                      ),
                      child: TextFormField(
                        initialValue: userProvider.getUser.onlinetime,
                        decoration: InputDecoration(
                          labelText: 'Online Time',
                          hintText: '${widget.onlinetime}',
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                        ),
                        validator: (value) =>
                            value.isEmpty ? 'Online Time cann\'t empty' : null,
                        onSaved: (value) => _onlinetime = value.trim(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: size.height * .02,
                        right: size.height * .02,
                        top: size.height * .01,
                        bottom: size.height * .01,
                      ),
                      child: TextFormField(
                        initialValue: userProvider.getUser.callrate,
                        decoration: InputDecoration(
                          labelText: 'Call Rate/Min',
                          hintText: '${widget.callrate}',
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                        ),
                        validator: (value) =>
                            value.isEmpty ? 'Call Rate cann\'t empty' : null,
                        onSaved: (value) => _callrate = value.trim(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: size.height * .02,
                        right: size.height * .02,
                        top: size.height * .01,
                        bottom: size.height * .01,
                      ),
                      child: TextFormField(
                        initialValue:userProvider.getUser.country,
                        decoration: InputDecoration(
                          labelText: 'Country',
                          hintText: '${widget.country}',
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.black38),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Colors.black87),
                          ),
                        ),
                        validator: (value) =>
                            value.isEmpty ? 'Country cann\'t empty' : null,
                        onSaved: (value) => _country = value.trim(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLoading = true;
                        });

                        if (validateAndSave()) {
                          firebaseMethods.editprofile(
                              widget.uid,
                              _name,
                              _age,
                              _bio,
                              _onlinetime,
                              _callrate,
                              _country,
                              _mobilenumber,
                              _profile_pic == null
                                  ? widget.profile_pic
                                  : _profile_pic);
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: size.height * .09,
                          right: size.height * .09,
                          top: size.height * .01,
                          bottom: size.height * .01,
                        ),
                        child: Container(
                          height: size.height * .065,
                          child: Center(
                            child: Text(
                              'Update',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: Colors.red,
                            ),
                            // color: Colors.black26,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.2, 1],
                              colors: [Color(0xFFB44EB1), Color(0xFFDA4D91)],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
