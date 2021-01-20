import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:some_task/resources/strings.dart';

class CommonWidgets {
  static Widget getButton(
      BuildContext context, String title, Function callback) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FlatButton(
          color: Theme.of(context).primaryColor,
          onPressed: () {
            callback(context);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white),
          )),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key key,
      this.context,
      this.title,
      this.onPressed,
      this.loadingTitle,
      this.isLoading})
      : super(key: key);
  final BuildContext context;
  final String title, loadingTitle;
  final Function onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FlatButton(
          disabledColor: Colors.grey,
          color: Theme.of(context).primaryColor,
          onPressed: onPressed,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: isLoading
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator()),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      loadingTitle,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    )
                  ],
                )
              : Text(
                  title,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                )),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key key,
    this.title = Strings.LOADING,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Color(0x00000000)),
        Align(
          alignment: Alignment.center,
          child: Wrap(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8),
                ),
                // height: 80.0,
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 24),
                      child: Text(title),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
