import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/providers/user_provider.dart';
import 'package:varenya_professionals/utils/palette.util.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';
import 'package:varenya_professionals/widgets/appointment/appointment_day_list.widget.dart';
import 'package:varenya_professionals/widgets/appointment/appointment_display_list.widget.dart';
import 'package:varenya_professionals/widgets/user/user_options_modal.widget.dart';

class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  static const routeName = "/appointments-list";

  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  List<DateTime> nextWeekDateList = [];
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    DateTime dateTime = DateTime.now();

    for (int i = 0; i <= 6; i++) {
      DateTime newDateTime = dateTime.add(Duration(days: i));

      nextWeekDateList.add(newDateTime);
    }

    this._selectedDate = nextWeekDateList.first;
  }

  void _openUserOptions() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            15.0,
          ),
          topRight: Radius.circular(
            15.0,
          ),
        ),
      ),
      backgroundColor: kIsWeb
          ? Colors.transparent
          : Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (BuildContext context) => UserOptionsModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: responsiveConfig(
                context: context,
                large: MediaQuery.of(context).size.width * 0.25,
                medium: MediaQuery.of(context).size.width * 0.25,
                small: 0,
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: responsiveConfig(
                    context: context,
                    large: MediaQuery.of(context).size.height * 0.3,
                    medium: MediaQuery.of(context).size.height * 0.3,
                    small: MediaQuery.of(context).size.height * 0.22,
                  ),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black54,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.05,
                  ),
                  child: Consumer<UserProvider>(
                    builder:
                        (BuildContext context, UserProvider userProvider, _) {
                      User user = userProvider.user;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Hello, ${user.displayName != null ? user.displayName!.split(' ')[0] : 'user'}',
                                style: TextStyle(
                                  fontSize:
                                  MediaQuery.of(context).size.height * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                iconSize:
                                MediaQuery.of(context).size.height * 0.056,
                                onPressed: this._openUserOptions,
                                icon: Icon(
                                  Icons.account_circle_rounded,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Here are your appointments!',
                            style: TextStyle(
                              fontSize:
                              MediaQuery.of(context).size.height * 0.03,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                AppointmentDayList(
                  selectedDate: this._selectedDate!,
                  dates: this.nextWeekDateList,
                  onSelect: (DateTime date) {
                    setState(() {
                      this._selectedDate = date;
                    });
                  },
                ),
                AppointmentDisplayList(
                  dateTime: this._selectedDate!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
