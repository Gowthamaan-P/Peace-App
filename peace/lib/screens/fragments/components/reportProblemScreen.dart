import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:peace/dataBaseProviders/reportProblemProvider.dart';
import 'package:peace/helpers/loadingScreen.dart';
import 'package:peace/helpers/snackBar.dart';

class ReportProblem extends FormBloc<String, String> {

  final date = InputFieldBloc<DateTime, dynamic>(initialValue: DateTime.now());
  final summary = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final description = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final status = SelectFieldBloc(items: ['Yes', 'No']);

  ReportProblem() {
    addFieldBlocs(step: 0, fieldBlocs: [
      date,
      summary,
      description,
      status
    ]);
    date.updateValue(DateTime.now());
  }

  @override
  void onSubmitting() async {
    Problem problem = Problem(date.value!.toIso8601String().substring(0, 10), summary.value!, description.value!, status.value!);
    ReportProblemController report = ReportProblemController();
    report.addProblem(problem, (String response) {
      if(response == ReportProblemController.STATUS_SUCCESS){
        emitSuccess();
      }
    });
  }

  @override
  void onLoading() async {
    date.updateValue(DateTime.now());
  }
}

class ReportProblemPage extends StatelessWidget {
  const ReportProblemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => ReportProblem(),
      child: Builder(
        builder: (context) {
          final formBloc = BlocProvider.of<ReportProblem>(context);

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              body: Column(
                children: [
                  Container(
                    height: 70,
                    alignment: Alignment.center,
                    color: Colors.lightBlue.shade900,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.chevron_left_rounded,
                              color: Colors.white,
                              size: height*0.04,
                            )),
                        Text(
                          'Report Problem',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: height*0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: height-116,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: FormBlocListener<ReportProblem, String, String>(
                      onSubmitting: (context, state) {
                        OverlayLoader.show(context);
                      },
                      onSuccess: (context, state) {
                        OverlayLoader.hide(context);
                        showSnackBar('Problem reported. Out team will address it soon. Have a nice day!', context);
                        formBloc.clear();
                        formBloc.reload();
                      },
                      onFailure: (context, state) {},
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "👉 Please provide clear specific titles and details to helps us diagnose your problem.",
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize:height*0.035, height: 1),
                              ),
                              Text(
                                "👉 If you have multiple problems, submit multiple problems.",
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize:height*0.035, height: 1),
                              ),
                              SizedBox(height: height*0.01,),
                              DateTimeFieldBlocBuilder(
                                isEnabled: false,
                                showClearIcon: false,
                                dateTimeFieldBloc: formBloc.date,
                                format: DateFormat('dd-MM-yyyy'),
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                                decoration: InputDecoration(
                                  labelText: 'Date',
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.summary,
                                style: TextStyle(fontSize: height * 0.035),
                                maxLines: null,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Problem',
                                  prefixIcon:
                                  Icon(Icons.text_fields_rounded),
                                ),
                              ),
                              TextFieldBlocBuilder(
                                textFieldBloc: formBloc.description,
                                style: TextStyle(fontSize: height * 0.035),
                                maxLines: null,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Comments',
                                  prefixIcon:
                                  Icon(Icons.text_fields_rounded),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Have you ever faced this problem before?",
                                      style: TextStyle(fontWeight: FontWeight.w500, fontSize:height*0.035),
                                    ),
                                    RadioButtonGroupFieldBlocBuilder(
                                      selectFieldBloc: formBloc.status,
                                      buttonTextStyle: TextStyle(fontSize: height*0.035),
                                      itemBuilder: (context, dynamic value) => value,
                                      decoration: InputDecoration(
                                        prefixIcon: SizedBox(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 25.0),
                                  width: double.infinity,
                                  child: MaterialButton(
                                    elevation: 5.0,
                                    onPressed: () => formBloc.submit(),
                                    padding: EdgeInsets.all(5.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    color: Colors.lightBlue.shade900,
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                        fontSize: (MediaQuery.of(context)
                                            .size
                                            .height) *
                                            0.035,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Puducherry Technological University',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: height*0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
