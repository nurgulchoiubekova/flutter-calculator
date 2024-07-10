// ignore: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:flutter_calculator_app/buttons.dart';
import 'package:math_expressions/math_expressions.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var userQuestion = '';
  var userAnswer = '0';

  // final myTextStyle = TextStyle(fontSize: 30, color: Colors.deepPurple[900]);

  final List<String> buttons = [
    'C',
    'DEL',
    '%',
    '/',
    '9',
    '8',
    '7',
    'x',
    '6',
    '5',
    '4',
    '-',
    '3',
    '2',
    '1',
    '+',
    '0',
    '.',
    '00',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 189, 188, 222),
      body: Column(
        children: <Widget>[
          Expanded(
            // ignore: avoid_unnecessary_containers
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    userQuestion,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerRight,
                  child: Text(userAnswer, style: const TextStyle(fontSize: 30)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: GridView.builder(
                //GridView.builder элементтердин торчосун түзүү үчүн колдонулат
                itemCount: buttons
                    .length, //itemCount Тордогу элементтердин жалпы саны.
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    // gridDelegate Элементтер тордо кантип жайгашаарын аныктайт.
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  // itemBuilder Тордогу ар бир элемент үчүн виджетти кайтаруучу функция.
                  //Clear Button
                  if (index == 0) {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          userQuestion = '';
                          userAnswer = '0';
                        });
                      },
                      buttonText: buttons[index],
                      color: const Color.fromARGB(255, 42, 109, 44),
                      textColor: Colors.white,
                    );
                  }

                  //Delete button
                  else if (index == 1) {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          userQuestion = userQuestion.substring(
                              0, userQuestion.length - 1);
                        });
                      },
                      buttonText: buttons[index],
                      color: const Color.fromARGB(255, 174, 31, 143),
                      textColor: Colors.white,
                    );
                  }

                  //Equal Button
                  else if (index == buttons.length - 1) {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          equalPressed();
                        });
                      },
                      buttonText: buttons[index],
                      color: const Color.fromARGB(255, 31, 47, 117),
                      textColor: Colors.white,
                    );
                  }

                  //Rest of the Buttons
                  else {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          userQuestion += buttons[index];
                        });
                      },
                      buttonText: buttons[index],
                      color: isOperator(buttons[index])
                          ? const Color.fromARGB(255, 31, 47, 117)
                          : Colors.deepPurple[50],
                      textColor: isOperator(buttons[index])
                          ? Colors.white
                          : const Color.fromARGB(255, 31, 47, 117),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    if (x == '%' || x == '/' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

  void equalPressed() {
    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll('x', '*'); // x ти * алмаштырат

    Parser p = Parser();
    //Parser сапты математикалык туюнтма менен талдап,
    //аны эсептөөлөргө ылайыктуу формага айландыруу үчүн керек.
    Expression exp = p.parse(finalQuestion);
    /*(p) колдонуу менен finalQuestion сабы математикалык 
    туюнтмага (exp) айландырылат. 
    Parser сапты талдап, тиешелүү маалымат структурасын түзөт.
    */
    ContextModel cm = ContextModel();
    /*Контексттик моделдин объектиси (ContextModel) түзүлдү. 
    Бул модель өзгөрмөлөрдүн маанилерин камтышы мүмкүн, 
    эгерде алар туюнтмада бар болсо (мисалы, x = 5).
    */
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    /*туюнтма (exp) eval (баалоо) ыкмасы менен бааланат, ал эки аргументти алат: 
    eval-баалоо түрү (EvaluationType.REAL) жана контексттик модель (см). 
    Эсептөөнүн натыйжасы баа өзгөрмөсүндө сакталат.
    */

    userAnswer = eval.toString();
    /* Эсептөөнүн натыйжасы eval(баалоо) сапка айландырылат жана 
    колдонуучунун суроосуна жоопту камтыган userAnswer өзгөрмөсүндө сакталат.
    */
  }
}
