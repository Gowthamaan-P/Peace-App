import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:peace/screens/homeScreen.dart';
import 'package:peace/screens/questionaire/sectionD.dart';
import 'package:peace/screens/questionaire/sectionE.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

final questions = [
  "Has this ever happened before?",
  "Do some of these attacks come suddenly out of the blue ⎯ that is, in situations where you don’t expect to be nervous or uncomfortable?",
  "Do these attacks bother you a lot or are you worried about having another attack?",
  "During your last bad anxiety attack, did you have symptoms like shortness of breath, sweating, or your heart racing, pounding or skipping?"
];

class PHQSectionCQuestions extends FormBloc<String, String> {

  final questionOne = SelectFieldBloc(
    validators: [FieldBlocValidators.required],
    items: ['No', 'Yes'],
  );

  final questionList = ListFieldBloc<SelectFieldBloc>(name: 'questionList');

  PHQSectionCQuestions() {
    addFieldBlocs(
      fieldBlocs: [questionOne],
    );
    questionOne.onValueChanges(
      onData: (previous, current) async* {
        for(int i=0;i<4;i++){
          questionList.removeFieldBlocsWhere((element) => true);
        }
        removeFieldBlocs(
          fieldBlocs: [
            questionList
          ],
        );

        if (current.value == 'No') {

        } else if (current.value == 'Yes') {
          for(int i=0;i<4;i++){
            questionList.addFieldBloc(
                SelectFieldBloc(
                  name: '$i',
                  validators: [FieldBlocValidators.required],
                  items: ['Yes', 'No'],
                )
            );
          }
          addFieldBlocs(fieldBlocs: [
            questionList
          ]);
        }
      },
    );
  }

  @override
  void onSubmitting() {
    emitSuccess();
  }
}

class PHQSectionC extends StatelessWidget {
  PHQSectionC({Key? key}) : super(key: key);

  final _scrollController = ScrollController(initialScrollOffset: 0.0);

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => PHQSectionCQuestions(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<PHQSectionCQuestions>();

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
              body: FormBlocListener<PHQSectionCQuestions, String, String>(
                onSubmitting: (context, state) {},
                onSuccess: (context, state) {
                  if(formBloc.questionOne.value=='Yes'){
                    Navigator.of(context, rootNavigator: true).push(
                      new CupertinoPageRoute<bool>(
                        fullscreenDialog: false,
                        builder: (BuildContext context) =>
                            PHQSectionD(),
                      ),
                    );
                  }else{
                    Navigator.of(context, rootNavigator: true).push(
                      new CupertinoPageRoute<bool>(
                        fullscreenDialog: false,
                        builder: (BuildContext context) =>
                            PHQSectionE(),
                      ),
                    );
                  }
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
                      SizedBox(
                        height: height*0.84,
                        child: Scrollbar(
                          showTrackOnHover: true,
                          isAlwaysShown: true,
                          controller: _scrollController,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            physics: ClampingScrollPhysics(),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            "In the last 4 weeks, have you had an anxiety attack ⎯  suddenly feeling fear or panic?",
                                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: height*0.035, height: 0.9, color: Colors.green.shade900),
                                          ),
                                        ),
                                        RadioButtonGroupFieldBlocBuilder(
                                          selectFieldBloc: formBloc.questionOne,
                                          itemBuilder: (context, dynamic value) => value,
                                          decoration: InputDecoration(
                                            prefixIcon: SizedBox(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

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
                                            margin: const EdgeInsets.all(8.0),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "${questions[i]}",
                                                    style: TextStyle(color: Colors.orange.shade600,fontWeight: FontWeight.w700, fontSize: height*0.045, height: 0.9),
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
                            fontSize: 10.0,
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
