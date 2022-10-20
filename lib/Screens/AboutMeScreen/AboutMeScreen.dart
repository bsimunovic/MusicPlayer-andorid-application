import 'dart:ui';

import 'package:flutter/material.dart';

class AboutMeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About me",
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.lightBlue[300],
                Colors.lightGreen[200],
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              stops: [0.0, 0.8],
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/type6.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              child: Container(
                color: Colors.black12,
              ),
              filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
            ),
          ),
          Container(
            width: 350,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 40, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "Ime:\t\t",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black54)),
                        TextSpan(
                            text: "Bruno",
                            style: TextStyle(
                              color: Colors.black54,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "Prezime:\t\t",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black54)),
                        TextSpan(
                            text: "Šimunović",
                            style: TextStyle(
                              color: Colors.black54,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "eMail:\t\t",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black54)),
                        TextSpan(
                            text: "simunovic1988@gmail.com",
                            style: TextStyle(
                              color: Colors.black54,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "Fakultet:\t\t",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Colors.black54)),
                        TextSpan(
                            text:
                                "Fakultet elektrotehnike, računarstva i informacijskih tegnologija",
                            style: TextStyle(
                              color: Colors.black54,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
