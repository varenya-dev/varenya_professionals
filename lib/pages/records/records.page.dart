import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/animations/error.animation.dart';
import 'package:varenya_professionals/animations/loading.animation.dart';
import 'package:varenya_professionals/animations/no_data.animation.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/patient/patient.model.dart';
import 'package:varenya_professionals/services/records.service.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/palette.util.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';
import 'package:varenya_professionals/widgets/records/patient_record.widget.dart';

class Records extends StatefulWidget {
  const Records({Key? key}) : super(key: key);

  // Page Route Name
  static const routeName = "/records";

  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  late final RecordsService _recordsService;
  List<Patient>? _patients;

  @override
  void initState() {
    super.initState();

    this._recordsService = Provider.of<RecordsService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: responsiveConfig(
                context: context,
                large: MediaQuery.of(context).size.width * 0.25,
                medium: MediaQuery.of(context).size.width * 0.25,
                small: 0,
              ),
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Palette.black,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(
                      responsiveConfig(
                        context: context,
                        large: MediaQuery.of(context).size.width * 0.03,
                        medium: MediaQuery.of(context).size.width * 0.03,
                        small: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                    child: Text(
                      'Patients\nIn Contact',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FutureBuilder(
                    future: this._recordsService.fetchPatientRecords(),
                    builder: _handleRecordsFuture,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _handleRecordsFuture(
    BuildContext buildContext,
    AsyncSnapshot<List<Patient>> snapshot,
  ) {
    // Check for errors.
    if (snapshot.hasError) {
      // Checking type of error and handling them.
      switch (snapshot.error.runtimeType) {
        case ServerException:
          {
            ServerException exception = snapshot.error as ServerException;
            return Error(message: exception.message);
          }
        default:
          {
            log.e(
              "Records Error",
              snapshot.error,
              snapshot.stackTrace,
            );
            return Error(
                message: "Something went wrong, please try again later");
          }
      }
    }

    // Check if data has been loaded
    if (snapshot.connectionState == ConnectionState.done) {
      this._patients = snapshot.data!;

      // Return and build main page.
      return _buildRecordsBody();
    }

    // If previously fetched doctors exists,
    // display them or loading indicator.
    return this._patients == null
        ? Loading(message: "Loading patient records")
        : this._buildRecordsBody();
  }

  Widget _buildRecordsBody() {
    return this._patients!.length != 0
        ? ListView.builder(
            itemCount: this._patients!.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              Patient patient = this._patients![index];

              return PatientRecord(
                patient: patient,
              );
            },
          )
        : NoData(message: 'No patient record to display');
  }
}
