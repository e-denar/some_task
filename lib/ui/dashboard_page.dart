import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:some_task/models/user.dart';
import 'package:some_task/resources/routes.dart';
import 'package:some_task/resources/strings.dart';
import 'package:some_task/services/auth_service.dart';
import 'package:some_task/services/firestore_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:some_task/ui/user_details_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'common.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  LinkedHashMap<String, UserModel> _users;
  FirestoreService _service;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _users = LinkedHashMap<String, UserModel>();
    _service = FirestoreService();
    _service.fetchUsers().then((value) => setState(() {
          value.forEach((e) {
            _users.addAll({
              e.uid: e,
            });
          });
          setState(() {
            _isLoading = false;
          });
        }));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Logout?'),
                  actions: [
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        AuthService().signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.HOME, (route) => route.isCurrent);
                      },
                    ),
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard'),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildBody(),
      ),
    );
  }

  Container _buildBody() {
    return Container(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Text('Users', style: TextStyle(fontSize: 20)),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              final user = _users.values.elementAt(index);
              return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.blue,
                      icon: Icons.edit,
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => Provider<
                                        LinkedHashMap<String, UserModel>>.value(
                                    value: _users,
                                    child: UserDetailsPage(user: user))))
                            .then((value) => setState(() {}));
                      },
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.clear,
                      onTap: () async {
                        _service
                            .deleteUser(user.uid)
                            .then((value) => setState(() {
                                  _users.remove(user.uid);
                                }));
                      },
                    ),
                  ],
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => Provider<
                                      LinkedHashMap<String, UserModel>>.value(
                                  value: _users,
                                  child: UserDetailsPage(user: user))))
                          .then((value) => setState(() {}));
                    },
                    leading: CircleAvatar(
                        child: CachedNetworkImage(
                      imageUrl: user?.photoUrl ?? "null",
                      imageBuilder: (context, imageProvider) => Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                    )),
                    title: Text(user?.name ?? "null"),
                    subtitle: Text(user?.birthDate ?? "null"),
                  ));
            },
            childCount: _users.values.length,
          )),
        ],
      ),
    );
  }
}
