import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:some_task/models/user.dart';
import 'package:some_task/resources/strings.dart';
import 'package:some_task/services/firestore_service.dart';
import 'package:some_task/ui/common.dart';
import 'package:provider/provider.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({Key key, this.user}) : super(key: key);

  final UserModel user;

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
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

  @override
  void initState() {
    super.initState();
    _service = FirestoreService();
    _controllers['name'].text = widget.user.name;
    _controllers['birthdate'].text = widget.user.birthDate;
    _controllers['address'].text = widget.user.address;
    _controllers['contact'].text = widget.user.contact;
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
                Text(
                  'User Details',
                  style: TextStyle(fontSize: 18),
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
                    loadingTitle: 'Updating...',
                    context: context,
                    title: 'Update',
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

                              _service.updateUser(_tempUser).then((user) {
                                Provider.of<LinkedHashMap<String, UserModel>>(
                                    context,
                                    listen: false)[_tempUser.uid] = _tempUser;
                                Navigator.of(context).pop();
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
