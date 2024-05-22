import "package:flutter/material.dart";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Login> {
  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;//usado para pegar o comprimento inteiro da tela
    
    return Scaffold(


      body: Row(
        children: [
          Container(
              height:screenHeight ,
              width: 611,
              child: Text("textando"),
              color: Color(0xFFF3F9F8),
            ),
          Container(
            height: screenHeight,
            child: Text("Textando"),

          ),
          
        ],
      ),


    );
  }
}