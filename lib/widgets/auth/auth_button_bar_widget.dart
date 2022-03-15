import 'package:flutter/material.dart';
import 'package:varenya_professionals/enum/auth_page_status.dart';
import 'package:varenya_professionals/utils/palette.util.dart';

class AuthButtonBarWidget extends StatefulWidget {
  final Function onSelect;
  final AuthPageStatus authPageStatus;

  AuthButtonBarWidget({
    Key? key,
    required this.onSelect,
    required this.authPageStatus,
  }) : super(key: key);

  @override
  _AuthButtonBarWidgetState createState() => _AuthButtonBarWidgetState();
}

class _AuthButtonBarWidgetState extends State<AuthButtonBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Palette.secondary,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  widget.onSelect(AuthPageStatus.REGISTER);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.authPageStatus == AuthPageStatus.REGISTER
                        ? Palette.primary
                        : Palette.secondary,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 45.0,
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: widget.authPageStatus == AuthPageStatus.REGISTER
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.onSelect(AuthPageStatus.LOGIN);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.authPageStatus == AuthPageStatus.LOGIN
                        ? Palette.primary
                        : Palette.secondary,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 50.0,
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: widget.authPageStatus == AuthPageStatus.LOGIN
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
