import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/services/doctor.service.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/palette.util.dart';
import 'package:varenya_professionals/utils/responsive_config.util.dart';
import 'package:varenya_professionals/widgets/common/custom_field_widget.dart';

class JobSelector extends StatefulWidget {
  final String job;
  final Function addOrRemoveJob;

  JobSelector({
    Key? key,
    required this.job,
    required this.addOrRemoveJob,
  }) : super(key: key);

  @override
  _JobSelectorState createState() => _JobSelectorState();
}

class _JobSelectorState extends State<JobSelector> {
  late final DoctorService _doctorService;
  List<String>? _jobTitles;
  List<String> _newJobTitles = [];

  final TextEditingController _jobController = new TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey();

  @override
  void initState() {
    super.initState();

    this._doctorService = Provider.of<DoctorService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    this._jobController.dispose();
  }

  void _addJob() {
    if (!this._formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      this._newJobTitles.add(this._jobController.text);
    });

    this.widget.addOrRemoveJob(this._jobController.text);
  }

  void _onAddNewJob() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        this._jobController.clear();

        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text('Add a new job title'),
          content: Form(
            key: this._formKey,
            child: CustomFieldWidget(
              textFieldController: this._jobController,
              label: 'Job',
              validators: [
                RequiredValidator(errorText: 'Job is required.'),
              ],
              textInputType: TextInputType.text,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                this._addJob();
                Navigator.of(context).pop();
              },
              child: Text('Okay'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: this._doctorService.fetchJobTitles(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<String>> snapshot,
        ) {
          if (snapshot.hasError) {
            switch (snapshot.error.runtimeType) {
              case ServerException:
                {
                  ServerException exception = snapshot.error as ServerException;
                  return Text(exception.message);
                }
              default:
                {
                  log.e(
                    "DisplayCategories Error",
                    snapshot.error,
                    snapshot.stackTrace,
                  );
                  return Text("Something went wrong, please try again later");
                }
            }
          }

          if (snapshot.connectionState == ConnectionState.done) {
            this._jobTitles = snapshot.data!;

            return _buildJobList();
          }

          return this._jobTitles == null
              ? CircularProgressIndicator()
              : _buildJobList();
        },
      ),
    );
  }

  bool _checkSelected(String job) => job == this.widget.job;

  Widget _buildJobList() {
    List<String> combinedJobs = [...this._jobTitles!, ...this._newJobTitles];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: responsiveConfig(
              context: context,
              large: MediaQuery.of(context).size.width * 0.01,
              medium: MediaQuery.of(context).size.width * 0.01,
              small: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          child: Row(
            children: [
              Text('Job Title'),
              IconButton(
                onPressed: this._onAddNewJob,
                icon: Icon(
                  Icons.add,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.08,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: combinedJobs.length,
            itemBuilder: (BuildContext context, int index) {
              String jobTitle = combinedJobs[index];
              return GestureDetector(
                onTap: () {
                  this.widget.addOrRemoveJob(jobTitle);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _checkSelected(jobTitle)
                        ? Theme.of(context).primaryColor
                        : Palette.secondary,
                    borderRadius: BorderRadius.circular(
                      15.0,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.02,
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                  ),
                  margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01,
                    horizontal: MediaQuery.of(context).size.width * 0.015,
                  ),
                  child: Text(
                    jobTitle,
                    style: TextStyle(
                      color: _checkSelected(jobTitle)
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
