import 'package:flutter/material.dart';
import 'package:some_task/resources/routes.dart';
import 'package:some_task/resources/strings.dart';
import 'package:some_task/services/auth_service.dart';

import 'common.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  AuthService _service;
  Map<String, TextEditingController> _controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _service = AuthService();
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
        title: Text('Login'),
      ),
      body: _buildBody(context),
    );
  }

  Stack _buildLoadingBody(BuildContext context) {
    return Stack(children: [
      _buildBody(context),
      LoadingIndicator(
        title: 'Signing in...',
      ),
    ]);
  }

  ListView _buildBody(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SOME TASK',
                  style: TextStyle(fontSize: 24, letterSpacing: 3),
                ),
                TextFormField(
                  readOnly: _isLoading,
                  controller: _controllers['email'],
                  decoration: InputDecoration(
                    hintText: Strings.EMAIL_HINT,
                    labelText: Strings.EMAIL_LABEL,
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) =>
                      value.isEmpty ? Strings.EMAIL_ERROR : null,
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  readOnly: _isLoading,
                  controller: _controllers['password'],
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: Strings.PW_HINT,
                    labelText: Strings.PW_LABEL,
                    prefixIcon: Icon(Icons.privacy_tip),
                  ),
                  validator: (value) => value.isEmpty ? Strings.PW_ERROR : null,
                ),
                SizedBox(
                  height: 8,
                ),
                CustomButton(
                    isLoading: _isLoading,
                    loadingTitle: 'Signing in...',
                    context: context,
                    title: 'Login',
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              _service
                                  .signInWithEmailAndPassword(
                                      email: _controllers['email'].text,
                                      password: _controllers['password'].text)
                                  .then((user) {
                                if (user != null) {
                                  Navigator.of(context)
                                      .popAndPushNamed(Routes.DASHBOARD);
                                }
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
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.REGISTER);
                  },
                  child: Text(
                    Strings.UNREGISTERED,
                    style: TextStyle(color: Colors.grey),
                  ),
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
