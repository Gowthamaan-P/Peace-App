import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:peace/helpers/loadingScreen.dart';
import 'package:peace/models/testResults.dart';
import 'package:peace/screens/homeScreen.dart';
import 'package:peace/screens/questionaire/sectionB.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

final questions = [
  "Stomach pain",
  "Back pain",
  "Pain in your arms, legs, or joints (knees, hips, etc.)",
  "Feeling tired or having little energy",
  "Trouble falling or staying asleep, or sleeping too much",
  "Menstrual cramps or other problems with your periods",
  "Pain or problems during sexual intercourse",
  "Headaches",
  "Chest pain",
  "Dizziness",
  "Fainting spells",
  "Feeling your heart pound or race",
  "Shortness of breath",
  "Constipation, loose bowels, or diarrhea",
  "Nausea, gas, or indigestion"
];

class PHQSectionAQuestions extends FormBloc<String, String> {

  final questionList = ListFieldBloc<SelectFieldBloc>(name: 'questionList',
      fieldBlocs: List.generate(15, (index) => SelectFieldBloc(
          name: '$index',
          validators: [FieldBlocValidators.required],
          items: ['Not bothered', 'Bothered a little', 'Bothered a lot'],
        ))

  );

  PHQSectionAQuestions() {
    addFieldBlocs(fieldBlocs: [questionList],
    );
  }


  @override
  void onSubmitting()async{
    int index;
    for(int i=0;i<15;i++){
      index = optionsOne.indexOf(questionList.state.fieldBlocs[i].value);
      studentTestResults.phqFifteenScore = studentTestResults.phqFifteenScore + index;
      studentTestResults.phqFifteen = studentTestResults.phqFifteen+","+index.toString();
    }
    await Future.delayed(Duration(milliseconds: 500),(){});
    emitSuccess();
  }
}

class PHQSectionA extends StatelessWidget {
  PHQSectionA({Key? key}) : super(key: key);

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => PHQSectionAQuestions(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<PHQSectionAQuestions>();

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: FormBlocListener<PHQSectionAQuestions, String, String>(
                onSubmitting: (context, state) {
                  OverlayLoader.show(context);
                },
                onSuccess: (context, state) {
                  OverlayLoader.hide(context);
                  Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute<bool>(
                      fullscreenDialog: false,
                      builder: (BuildContext context) =>
                          PHQSectionB(),
                    ),
                  );
                },
                onFailure: (context, state) {},
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.blue.shade50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "Peace",
                                  style: TextStyle(
                                      fontFamily: "Cookie",
                                      fontSize: (MediaQuery.of(context).size.height) * 0.08,
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                      "assets/images/logo.png",
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TouchableOpacity(
                                  onTap: (){
                                    Navigator.of(context, rootNavigator: false).push(
                                      new CupertinoPageRoute<bool>(
                                        fullscreenDialog: false,
                                        builder: (BuildContext context) => HomeScreen(),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.home, size: height*0.05, color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "During the last 4 weeks, how much have you been bothered by any of the following problems?",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: height*0.035, height: 0.9, color: Colors.green.shade900),
                        ),
                      ),
                      SizedBox(
                        height: height*0.708,
                        child: Scrollbar(
                          isAlwaysShown: true,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: ClampingScrollPhysics(),
                            child: Column(
                              children: [
                                BlocBuilder<ListFieldBloc<SelectFieldBloc>,
                                    ListFieldBlocState<SelectFieldBloc>>(
                                  bloc: formBloc.questionList,
                                  builder: (context, state) {
                                    if (state.fieldBlocs.isNotEmpty) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: state.fieldBlocs.length,
                                        itemBuilder: (context, i) {
                                          return Container(
                                            margin: const EdgeInsets.all(15.0),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "${questions[i]}",
                                                    style: TextStyle(color: Colors.orange.shade600,fontWeight: FontWeight.w700, fontSize: height*0.045,height: 0.9),
                                                  ),
                                                  RadioButtonGroupFieldBlocBuilder(
                                                    selectFieldBloc: state.fieldBlocs[i],
                                                    buttonTextStyle: TextStyle(height: 0.6),
                                                    itemBuilder: (context, dynamic value) => value,
                                                    decoration: InputDecoration(
                                                      prefixIcon: SizedBox(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                    return Container();
                                  },
                                ),

                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: width*0.04, vertical: 10),
                                    child: MaterialButton(
                                      onPressed: (){
                                        formBloc.submit();
                                      },
                                      color: Colors.blue.shade900,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                                      child: Text("Next",
                                        style: TextStyle(color: Colors.white, fontSize: height*0.034, height: 1.0 ,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          'Puducherry Technological University',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: height*0.02,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
