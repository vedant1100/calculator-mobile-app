import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(appBarTheme: const AppBarTheme(color: Colors.blue)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var userInput='';
  var answer='';
  double number1=0.0; var operand=''; double number2=0.0;

  bool isOperator(String x){
    if(x=='+' || x=='-' || x=='/' || x=='x' ||x=='=')
      return true;
    else
      return false;
  }

  void equalPressed(){
    String finalInput=userInput;
    finalInput=userInput.replaceAll('x', '*');

    Parser P=Parser();
    Expression exp=P.parse(finalInput);

    ContextModel cm=ContextModel();
    double eval=exp.evaluate(EvaluationType.REAL, cm);
    answer=eval.toString();
  }

  final List<String> buttons=['C','+/-','%','DEL','7','8','9','/','4','5','6','x','1','2','3','-','0','.','=','+'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Text('Calculator'),
      ),

      body:
        Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: Colors.grey,
                    height: 70,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.all(20),
                    child: Text(userInput, style: const TextStyle(fontSize: 18, color: Colors.white),),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerRight,
                    color: Colors.grey,
                    child: Text(answer, style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w500)),
                  )
                ],
              ),
            ),

        Expanded(
          flex: 3,
          child: Container(
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              itemBuilder: (context,index){
                // Clear button
                if(index==0){
                  return MyButton(
                    buttonTapped:(){
                      setState(() {
                        userInput='';
                        answer='0';
                      });
                    },
                    buttonText:buttons[index],
                    color:Colors.blue[50],
                    textColor:Colors.black,
                  );
                }

                // +/- button
                else if(index==1){
                  return MyButton(
                    buttonTapped: (){
                      setState(() {
                        double number;
                        try{
                          number=double.parse(userInput);
                          number*=-1;
                          answer=number.toString();
                        }catch(e){
                          answer='error';
                        }
                      });
                    },
                    buttonText: buttons[index],
                    color: Colors.blue[50],
                    textColor: Colors.black,
                  );
                }

                // % button
                else if(index==2){
                  return MyButton(
                    buttonTapped:(){
                      setState(() {
                        double number;
                        try{
                          number=double.parse(userInput);
                          number1=number/100;
                          answer=number1.toString();
                        }catch(e){
                          answer='error';
                        }
                      });
                    },
                    buttonText: buttons[index],
                    color: Colors.blue[50],
                    textColor: Colors.black,
                  );
                }

                // delete button
                else if(index==3){
                  return MyButton(
                    buttonTapped: (){
                      setState(() {
                        if(userInput.isEmpty){
                          return;
                        }
                        userInput=userInput.substring(0, userInput.length-1);
                      });
                    },
                    buttonText: buttons[index],
                    color: Colors.blue[50],
                    textColor: Colors.black,
                  );
                }

                // equal_to button
                else if(index==18){
                  return MyButton(
                    buttonTapped: (){
                      setState(() {
                        equalPressed();
                      });
                    },
                    buttonText: buttons[index],
                    color: Colors.orange[500],
                    textColor: Colors.black,
                  );
                }

                // other buttons
                else{
                  return MyButton(
                    buttonTapped: (){
                      setState(() {
                        userInput+=buttons[index];
                      });
                    },
                    buttonText: buttons[index],
                    color: isOperator(buttons[index])?Colors.blue:Colors.white,
                    textColor: isOperator(buttons[index])?Colors.white:Colors.black,
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

}

class MyButton extends StatelessWidget {
  final textColor;
  final color;
  final String buttonText;
  final buttonTapped;

  const MyButton({super.key, this.textColor, this.color, required this.buttonText, this.buttonTapped});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonTapped,
      child: Padding(
          padding: EdgeInsets.all(0.2),
        child: ClipRRect(
          child: Container(
            color: color,
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),),
            ),
          ),
        ),
      )
    );
  }
}
