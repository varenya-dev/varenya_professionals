import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/specialization/specialization.model.dart';
import 'package:varenya_professionals/services/doctor.service.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/palette.util.dart';
import 'package:varenya_professionals/widgets/common/custom_field_widget.dart';

class SpecializationSelector extends StatefulWidget {
  final List<Specialization> selectedSpecializations;
  final Function addOrRemoveSpecialization;

  SpecializationSelector({
    Key? key,
    required this.selectedSpecializations,
    required this.addOrRemoveSpecialization,
  }) : super(key: key);

  @override
  _SpecializationSelectorState createState() => _SpecializationSelectorState();
}

class _SpecializationSelectorState extends State<SpecializationSelector> {
  late final DoctorService _doctorService;
  List<Specialization>? _specializations;
  List<Specialization> _newSpecializations = [];

  final TextEditingController _specializationController =
      new TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey();

  @override
  void initState() {
    super.initState();

    this._doctorService = Provider.of<DoctorService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    this._specializationController.dispose();
  }

  void _addSpecialization() {
    if (!this._formKey.currentState!.validate()) {
      return;
    }

    Specialization specialization = new Specialization(
      id: 'NEW',
      specialization: this._specializationController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setState(() {
      this._newSpecializations.add(specialization);
    });

    this.widget.addOrRemoveSpecialization(specialization);
  }

  void _onAddNewSpecialization() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        this._specializationController.clear();

        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text('Add a new specialization'),
          content: Form(
            key: this._formKey,
            child: CustomFieldWidget(
              textFieldController: this._specializationController,
              label: 'Specialization',
              validators: [
                RequiredValidator(errorText: 'Specialization is required.'),
              ],
              textInputType: TextInputType.text,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                this._addSpecialization();
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
        future: this._doctorService.fetchSpecializations(),
        builder: (
          BuildContext context,
          AsyncSnapshot<List<Specialization>> snapshot,
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
            this._specializations = snapshot.data!;

            return _buildSpecializationList();
          }

          return this._specializations == null
              ? CircularProgressIndicator()
              : _buildSpecializationList();
        },
      ),
    );
  }

  bool _checkSelected(Specialization specialization) {
    return this
        .widget
        .selectedSpecializations
        .where(
          (element) => element.id == specialization.id,
        )
        .isNotEmpty;
  }

  Widget _buildSpecializationList() {
    List<Specialization> combinedSpecializations = [
      ...this._specializations!,
      ...this._newSpecializations
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Row(
            children: [
              Text('Specialization'),
              IconButton(
                onPressed: this._onAddNewSpecialization,
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
            itemCount: combinedSpecializations.length,
            itemBuilder: (BuildContext context, int index) {
              Specialization specialization = combinedSpecializations[index];
              return GestureDetector(
                onTap: () {
                  this.widget.addOrRemoveSpecialization(specialization);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _checkSelected(specialization)
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
                    specialization.specialization,
                    style: TextStyle(
                      color: _checkSelected(specialization)
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
