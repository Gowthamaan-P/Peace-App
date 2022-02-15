import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:peace/models/testResults.dart';
import 'package:peace/screens/homeScreen.dart';
import 'package:peace/screens/questionaire/sectionE.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

final questions = [
"Little interest or pleasure in doing things",
"Feeling down, depressed, or hopeless",
"Trouble falling or staying asleep, or sleeping too much",
"Feeling tired or having little energy",
"Poor appetite or overeating",
"Feeling bad about yourself — or that you are a failure or have let yourself or your family down",
"Trouble concentrating on things, such as reading the newspaper or watching television",
"Moving or speaking so slowly that other people could have noticed? Or the opposite – being so fidgety or restless that you have been moving around a lot more than usual",
"Thoughts that you would be better off dead of or hurting yourself in some way"
];

class PHQSectionDQuestions extends FormBloc<String, String> {

  final questionList = ListFieldBloc<SelectFieldBloc>(name: 'questionList',
      fieldBlocs: List.generate(9, (index) => SelectFieldBloc(
        name: '$index',
        validators: [FieldBlocValidators.required],
        items: ['Not at all', 'Several days', 'More than half the days','Nearly every day'],
      ))

  );

  PHQSectionDQuestions() {
    addFieldBlocs(fieldBlocs: [questionList],
    );
  }

  @override
  void onSubmitting() {
    int index;
    for(int i=0;i<7;i++){
      index = optionsTwo.indexOf(questionList.state.fieldBlocs[i].value);
      studentTestResults.phqNineScore = studentTestResults.phqNineScore + index;
      studentTestResults.phqNine = studentTestResults.phqNine+","+index.toString();
    }
    emitSuccess();
  }
}

class PHQSectionD extends StatelessWidget {
  const PHQSectionD({Key? key}) : super(key: key);

  static final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => PHQSectionDQuestions(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<PHQSectionDQuestions>();

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
              body: FormBlocListener<PHQSectionDQuestions, String, String>(
                onSubmitting: (context, state) {},
                onSuccess: (context, state) {
                  Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute<bool>(
                      fullscreenDialog: false,
                      builder: (BuildContext context) =>
                          PHQSectionE(),
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
                          "Over the last 2 weeks, how often have you been bothered by any of the following problems?",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: height*0.035, height: 0.9, color: Colors.green.shade900),
                        ),
                      ),

                      SizedBox(
                        height: height*0.7,
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
