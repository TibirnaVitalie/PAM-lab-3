import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

  static String division  = 'resources/svg/division.svg';
  static String erase     = 'resources/svg/erase.svg';
  static String minus     = 'resources/svg/minus.svg';
  static String multiply  = 'resources/svg/multiply.svg';
  static String plus      = 'resources/svg/plus.svg';

  String equation = '0';
  String result = '0';
  String expression = '';

  Widget calcButton(String buttonText, Color buttonColor, Color textColor){
    return ElevatedButton(
      onPressed:(){
        calculation(buttonText);
      },
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
        onPrimary: textColor,
        elevation: 0.0,
        shadowColor: Colors.transparent,
        minimumSize: const Size(82, 88),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          )
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 32,
          color: textColor,
        ),
      )
    );
  }

  Widget iconButton(Color buttonColor, Color iconColor, String assetName, String buttonText){
    return ElevatedButton(
        onPressed:(){
          calculation(buttonText);
        },
        style: ElevatedButton.styleFrom(
            primary: buttonColor,
            elevation: 0.0,
            shadowColor: Colors.transparent,
            minimumSize: const Size(82, 88),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            )
        ),
        child: SvgPicture.asset(
          assetName,
          color: iconColor,
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50, top: 37+30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Calculator',
              style: TextStyle(
                color: Color(0xFF252C32),
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      equation,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          color: Color(0xFF969696),
                          fontSize: 48
                      ),
                    )
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      result.replaceAll(regex, ''),
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          color: Color(0xFF969696),
                          fontSize: 48
                      ),
                    )
                )
              ],
            ),
            const SizedBox(height: 20,),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1, color: Color(0xFFEEF0F2)),
                ),
                //color: Colors.red,
              ),
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  calcButton('C', Colors.transparent, const Color(0xFFFF887D)),
                  const SizedBox(height: 88, width: 82),
                  iconButton(Colors.transparent, const Color(0xFF11998E), erase,'del'),
                  iconButton(Colors.transparent, const Color(0xFF11998E), division,'÷'),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                calcButton('7', Colors.transparent, const Color(0xFFA9A7A7)),
                calcButton('8', Colors.transparent, const Color(0xFFA9A7A7)),
                calcButton('9', Colors.transparent, const Color(0xFFA9A7A7)),
                iconButton(Colors.transparent, const Color(0xFF11998E), multiply,'×'),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                calcButton('4', Colors.transparent, const Color(0xFFA9A7A7)),
                calcButton('5', Colors.transparent, const Color(0xFFA9A7A7)),
                calcButton('6', Colors.transparent, const Color(0xFFA9A7A7)),
                iconButton(Colors.transparent, const Color(0xFF11998E), minus,'-'),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                calcButton('1', Colors.transparent, const Color(0xFFA9A7A7)),
                calcButton('2', Colors.transparent, const Color(0xFFA9A7A7)),
                calcButton('3', Colors.transparent, const Color(0xFFA9A7A7)),
                iconButton(Colors.transparent, const Color(0xFF11998E), plus,'+'),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(height: 88, width: 82),
                calcButton('0', Colors.transparent, const Color(0xFFA9A7A7)),
                calcButton('.', Colors.transparent, const Color(0xFFA9A7A7)),
                calcButton('=', Colors.yellow, const Color(0xFFEEF0F2)),
              ],
            ),
          ],
        ),
      )
    );
  }

  void calculation(btnText) {
    setState(() {
      if(btnText == 'C'){
        equation = '0';
        result = '0';
      } else if(btnText == 'del'){
        if(equation.length > 1){
          equation = equation.substring(0, equation.length-1);
        } else{
          equation = '0';
        }
      } else if(btnText == '='){
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');
        try{
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch(e){
          result = 'Error';
        }
      } else if(btnText == '÷' || btnText == '×' || btnText == '-' || btnText == '+' || btnText == '.'){
        equation += btnText;
      } else{
        if(equation == '0'){
          equation = btnText;
        } else{
          equation += btnText;
        }
      }
    });
  }
}
