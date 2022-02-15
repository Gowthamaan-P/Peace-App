import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:peace/dataBaseProviders/mailHandlers.dart';
import 'package:peace/helpers/loadingScreen.dart';
import 'package:peace/helpers/snackBar.dart';
import 'package:peace/models/user.dart';

BuildContext? dialogContext;

void scheduleTestFunction(BuildContext context) async {
  showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        final size = MediaQuery.of(context).size;
        return Dialog(
            child: SizedBox(
                height: size.height * 0.5,
                child: AddItemForm()));
      }).then((value) {

  });
}

class GetScheduleDetails extends FormBloc<String, String> {

  final mailId = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final scheduledTime  = InputFieldBloc<DateTime, dynamic>(validators: [FieldBlocValidators.required]);


  GetScheduleDetails() {
    addFieldBlocs(step: 0, fieldBlocs: [mailId, scheduledTime]);
    mailId.updateValue(user.email);
  }

  @override
  void onSubmitting() async {
    DateTime time = scheduledTime.value!;
    String date = DateFormat.yMMMMd('en_US').format(time) +"   "+ DateFormat.jm().format(time);
    ScheduleData data = ScheduleData(user.email, date, user.name);
    SendScheduleEmail().sendMail(data, (String response) {
      if(response == SendScheduleEmail.STATUS_SUCCESS)
        emitSuccess();
      else
        emitFailure();
    });
  }

  @override
  void onLoading() async {
    mailId.updateValue(user.email);
  }
}

class AddItemForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => GetScheduleDetails(),
      child: Builder(
        builder: (context) {
          final scheduleForm = BlocProvider.of<GetScheduleDetails>(context);

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: FormBlocListener<GetScheduleDetails, String, String>(
              onSubmitting: (context, state) => OverlayLoader.show(context),
              onSuccess: (context, state) {
                showSnackBar("SHQ Test scheduled successfully. Please check your mail for schedule.", dialogContext!);
                OverlayLoader.hide(context);
                Navigator.pop(context);
              },
              onFailure: (context, state) {
                OverlayLoader.hide(context);
                scheduleForm.clear();
                scheduleForm.reload();
              },
              child: Center(
                child: Container(
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Text(
                            'Schedule Test',
                            style: TextStyle(
                                fontSize: 25 * ((size.width / 3) / 100),
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900),
                          ),
                          TextFieldBlocBuilder(
                            textFieldBloc: scheduleForm.mailId,
                            isEnabled: false,
                            style: TextStyle(
                              fontSize: 20 * ((size.width / 3) / 100),
                            ),
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                          DateTimeFieldBlocBuilder(
                            dateTimeFieldBloc: scheduleForm.scheduledTime,
                            canSelectTime: true,
                            initialTime: TimeOfDay.now(),
                            format: DateFormat('dd-MM-yyyy  hh:mm'),
                            style: TextStyle(
                              fontSize: 20 * ((size.width / 3) / 100),
                            ),
                            initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+1),
                            firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+1),
                            lastDate: DateTime(2100),
                            decoration: InputDecoration(
                              labelText: 'Time',
                              prefixIcon: Icon(Icons.date_range),
                            ),
                          ),
                          SizedBox(height: 20),
                          MaterialButton(
                            onPressed: () => scheduleForm.submit(),
                            color: Colors.blue.shade900,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 25.0),
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25 * ((size.width / 3) / 100),
                                  height: 1,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}