import 'package:flutter/material.dart';
import 'package:varenya_professionals/models/patient/patient.model.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';

class PatientRecord extends StatefulWidget {
  final Patient patient;

  PatientRecord({
    Key? key,
    required this.patient,
  }) : super(key: key);

  @override
  _PatientRecordState createState() => _PatientRecordState();
}

class _PatientRecordState extends State<PatientRecord> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
          vertical: MediaQuery.of(context).size.height * 0.015,
        ),
        child: Padding(
          padding: EdgeInsets.all(
            responsiveConfig(
              context: context,
              large: MediaQuery.of(context).size.width * 0.025,
              medium: MediaQuery.of(context).size.width * 0.025,
              small: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.017,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.widget.patient.fullName,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Track Progress?'),
                  TextButton(
                    onPressed: () {},
                    child: Text('Track'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
