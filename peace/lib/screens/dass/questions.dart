import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:peace/models/testResults.dart';
import 'package:peace/screens/dass/successScreen.dart';
import 'package:peace/screens/homeScreen.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

final questions = [
  "I found myself getting upset by quite trivial things",
  "I was aware of dryness of my mouth",
  "I couldn't seem to experience any positive feeling at all",
  "I experienced breathing difficulty (eg, excessively rapid breathing,breathlessness in the absence of physical exertion) ",
  "I just couldn't seem to get going",
  "I tended to over-react to situations",
  "I had a feeling of shakiness (eg, legs going to give way)",
  "I found it difficult to relax",
  "I found myself in situations that made me so anxious I was most relieved when they ended",
  "I felt that I had nothing to look forward to",
  "I found myself getting upset rather easily",
  "I felt that I was using a lot of nervous energy",
  "I felt sad and depressed",
  "I found myself getting impatient when I was delayed in any way(eg, lifts, traffic lights, being kept waiting)",
  "I had a feeling of faintness",
  "I felt that I had lost interest in just about everything",
  "I felt I wasn't worth much as a person",
  "I felt that I was rather touchy",
  "I perspired noticeably (eg, hands sweaty) in the absence of high temperatures or physical exertion",
  "I felt scared without any good reason",
  "I felt that life wasn't worthwhile",
  "I found it hard to wind down",
  "I had difficulty in swallowing",
  "I couldn't seem to get any enjoyment out of the things I did",
  "I was aware of the action of my heart in the absence of physical exertion (eg, sense of heart rate increase, heart missing a beat)",
  "I felt down-hearted and blue",
  "I found that I was very irritable",
  "I felt I was close to panic",
  "I found it hard to calm down after something upset me",
  "I feared that I would be \"thrown\" by some trivial but unfamiliar task",
  "I was unable to become enthusiastic about anything",
  "I found it difficult to tolerate interruptions to what I was doing",
  "I was in a state of nervous tension",
  "I felt I was pretty worthless",
  "I was intolerant of anything that kept me from getting on with what I was doing",
  "I felt terrified",
  "I could see nothing in the future to be hopeful about",
  "I felt that life was meaningless",
  "I found myself getting agitated",
  "I was worried about situations in which I might panic and make a fool of myself",
  "I experienced trembling (eg, in the hands)",
  "I found it difficult to work up the initiative to do things",

];

class DassQuestions extends FormBloc<String, String> {

  final questionList = ListFieldBloc<SelectFieldBloc>(name: 'questionList',
      fieldBlocs: List.generate(42, (index) => SelectFieldBloc(
        name: '$index',
        validators: [FieldBlocValidators.required],
        items: ['0', '1', '2','3'],
      ))

  );

  DassQuestions() {
    addFieldBlocs(fieldBlocs: [questionList],
    );
  }

  @override
  void onSubmitting() {
    int index;
    for(int i=0;i<42;i++){
      index = optionsThree.indexOf(questionList.state.fieldBlocs[i].value);
      if(depression.contains(i+1))
        studentTestResults.depressionDass = studentTestResults.depressionDass + index;
      else if(anxiety.contains(i+1))
        studentTestResults.anxietyDass = studentTestResults.anxietyDass + index;
      else if(stress.contains(i+1))
        studentTestResults.stressDass = studentTestResults.stressDass + index;
      studentTestResults.dass = studentTestResults.dass+","+index.toString();
    }
    emitSuccess();
  }
}

class DassSection extends StatelessWidget {
  DassSection({Key? key}) : super(key: key);

  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => DassQuestions(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<DassQuestions>();

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
              body: FormBlocListener<DassQuestions, String, String>(
                onSubmitting: (context, state) {},
                onSuccess: (context, state) {
                  Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute<bool>(
                      fullscreenDialog: false,
                      builder: (BuildContext context) =>
                          SuccessScreen(),
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
                          "During the last week, how much the following statements applied to you?",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: height*0.035, height: 0.9, color: Colors.green.shade900),
                        ),
                      ),
                      SizedBox(
                        height: height*0.74,
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
                                            margin: const EdgeInsets.all(8.0),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "${questions[i]}",
                                                    style: TextStyle(color: Colors.orange.shade600,fontWeight: FontWeight.w700, fontSize: height*0.04, height: 0.9),
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
