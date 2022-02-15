import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 70,
            alignment: Alignment.center,
            color: Colors.lightBlue.shade900,
            child: Row(
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: height*0.04,
                    )),
                Text(
                  'About',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height*0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: height-120,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ListView(
              children: [
                Text(
                  "Peace, 1.1.0",
                  style: TextStyle(fontSize: height*0.04),
                ),
                Text(
                  "Application name and version",
                  style: TextStyle(color: Colors.grey, fontSize: height*0.03),
                ),
                Divider(),

                Text(
                  "Peace is a mobile application developed by students of PTU to keep track on the mental health of college students from the time of admission till graduation."
                  "This is a preliminary screening tool designed based on Medical Standards to track the mental health of an individual  and cannot be used for diagnosis of any mental disorders.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: height*0.035,
                    height: 1.2,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  "Description",
                  style: TextStyle(color: Colors.grey, fontSize: height*0.03),
                ),
                Divider(),

                Text(
                  "ECE Students",
                  style: TextStyle(fontSize: height*0.04),
                ),
                Text(
                  "Developer",
                  style: TextStyle(color: Colors.grey, fontSize: height*0.03),
                ),
                Divider(),

                TouchableOpacity(
                  onTap: _launchMailClient,
                  child: Text(
                    "info.ptupeace@gmail.com",
                    style: TextStyle(
                        fontSize: height*0.04,
                        fontWeight: FontWeight.normal,
                        color: Colors.blue[700]),
                  ),
                ),
                Text(
                  "Contact Information",
                  style: TextStyle(
                      fontWeight: FontWeight.normal, fontSize: height*0.03, color: Colors.grey),
                ),
                Divider(),

                Row(
                  children: <Widget>[
                    Text(
                      "Copyright ",
                      style: TextStyle(color: Colors.grey,fontSize: height*0.03),
                    ),
                    Icon(Icons.copyright, size: height*0.03, color: Colors.grey),
                    Text(
                      " 2022 - PTU",
                      style: TextStyle(color: Colors.grey,fontSize: height*0.03),
                    )
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Puducherry Technological University',
              style: TextStyle(
                color: Colors.grey,
                fontSize: height*0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchMailClient() async {
    const kEmail = "info.ptupeace@gmail.com";
    const mailUrl = 'mailto:$kEmail';
    try {
      await launch(mailUrl);
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: "$kEmail"));
    }
  }
}
