import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:some_task/models/user.dart';
import 'package:some_task/resources/routes.dart';
import 'package:some_task/resources/strings.dart';
import 'package:some_task/services/auth_service.dart';
import 'package:some_task/services/firestore_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'common.dart';

class RegistrationDetailsPage extends StatefulWidget {
  const RegistrationDetailsPage({Key key, this.user}) : super(key: key);

  final UserModel user;

  @override
  _RegistrationDetailsPageState createState() =>
      _RegistrationDetailsPageState();
}

class _RegistrationDetailsPageState extends State<RegistrationDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  FirestoreService _service;
  Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'birthdate': TextEditingController(),
    'address': TextEditingController(),
    'contact': TextEditingController(),
  };
  File _profilePic;
  String _photoUrl;

  @override
  void initState() {
    super.initState();
    _service = FirestoreService();
  }

  @override
  void dispose() {
    _controllers.forEach((key, value) {
      value.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: _buildBody(context),
    );
  }

  ListView _buildBody(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        ImagePicker()
                            .getImage(source: ImageSource.gallery)
                            .then((photo) {
                          _service
                              .uploadFile(photo.path, widget.user.uid)
                              .then((value) async {
                            _photoUrl =
                                await _service.getDownloadUrl(widget.user.uid);

                            setState(() {
                              _profilePic = File(photo.path);
                            });
                          }).catchError((e) {
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          });
                        });
                      },
                      child: CircleAvatar(
                          minRadius: 70,
                          maxRadius: 70,
                          backgroundImage: _profilePic == null
                              ? null
                              : FileImage(_profilePic),
                          child: _profilePic == null
                              ? Text('Tap to add photo')
                              : null),
                    ),
                  ],
                ),
                TextFormField(
                  readOnly: _isLoading,
                  controller: _controllers['name'],
                  decoration: InputDecoration(
                    hintText: Strings.NAME_HINT,
                    labelText: Strings.NAME_LABEL,
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) =>
                      value.isEmpty ? Strings.NAME_ERROR : null,
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  readOnly: _isLoading,
                  controller: _controllers['birthdate'],
                  decoration: InputDecoration(
                    hintText: Strings.BIRTHDAY_HINT,
                    labelText: Strings.BIRTHDAY_LABEL,
                    prefixIcon: Icon(Icons.date_range),
                  ),
                  validator: (value) =>
                      value.isEmpty ? Strings.BIRTHDAY_ERROR : null,
                ),
                TextFormField(
                  readOnly: _isLoading,
                  controller: _controllers['address'],
                  decoration: InputDecoration(
                    hintText: Strings.ADDRESS_HINT,
                    labelText: Strings.ADDRESS_LABEL,
                    prefixIcon: Icon(Icons.home),
                  ),
                  validator: (value) =>
                      value.isEmpty ? Strings.ADDRESS_ERROR : null,
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  readOnly: _isLoading,
                  controller: _controllers['contact'],
                  decoration: InputDecoration(
                    hintText: Strings.CONTACT_HINT,
                    labelText: Strings.CONTACT_LABEL,
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) =>
                      value.isEmpty ? Strings.CONTACT_ERROR : null,
                ),
                SizedBox(
                  height: 8,
                ),
                CustomButton(
                    isLoading: _isLoading,
                    loadingTitle: 'Saving...',
                    context: context,
                    title: 'Save',
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              var _tempUser = UserModel.copy(widget.user);
                              _tempUser.address = _controllers['address'].text;
                              _tempUser.contact = _controllers['contact'].text;
                              _tempUser.name = _controllers['name'].text;
                              _tempUser.birthDate =
                                  _controllers['birthdate'].text;
                              _tempUser.photoUrl = _photoUrl;

                              _service.createUser(_tempUser).then((user) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    Routes.DASHBOARD,
                                    (routes) => routes.isCurrent,
                                    arguments: {
                                      'user': _tempUser,
                                    });
                              }).catchError((e) {
                                setState(() {
                                  _isLoading = false;
                                });
                                _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(content: Text(e.toString())));
                              });
                            }
                          }),
                SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
