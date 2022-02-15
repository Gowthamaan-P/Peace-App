import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peace/screens/fragments/about.dart';
import 'package:peace/screens/fragments/components/councellorContactsScreen.dart';
import 'package:peace/screens/fragments/components/helpScreen.dart';
import 'package:peace/screens/fragments/components/reportProblemScreen.dart';
import '../loginScreen.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 70,
            alignment: Alignment.center,
            color: Colors.lightBlue.shade900,
            child: Row(
              children: <Widget>[
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(
                  Icons.chevron_left_rounded, color: Colors.white, size: height*0.045,
                )),
                Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height*0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            height: height-130,
            child: ListView(
              children: <Widget>[
               /* ListTile(
                  title: Text("Password and Security",
                    style: TextStyle(color: Colors.grey.shade900, fontSize: height*0.04),
                  ),
                  leading: Icon(Icons.security_rounded, color: Colors.black45, size: height*0.04,),
                ),*/
                ListTile(
                  title: Text(
                    "Councellor Contacts",
                    style: TextStyle(color: Colors.grey.shade900, fontSize: height*0.04),
                  ),
                  leading: Icon(Icons.contact_mail_rounded, color: Colors.black45,size: height*0.04,),
                  onTap: (){
                    Navigator.of(context, rootNavigator: false).push(
                      new CupertinoPageRoute<bool>(
                        fullscreenDialog: false,
                        builder: (BuildContext context) => CouncellorContactsScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "Help & FAQ",
                    style: TextStyle(color: Colors.grey.shade900, fontSize: height*0.04),
                  ),
                  leading: Icon(Icons.help, color: Colors.black45,size: height*0.04,),
                  onTap: (){
                    Navigator.of(context, rootNavigator: false).push(
                      new CupertinoPageRoute<bool>(
                        fullscreenDialog: false,
                        builder: (BuildContext context) => HelpScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "About",
                    style: TextStyle(color: Colors.grey.shade900, fontSize: height*0.04),
                  ),
                  leading: Icon(Icons.info, color: Colors.black45,size: height*0.04,),
                  onTap: (){
                    Navigator.of(context, rootNavigator: false).push(
                      new CupertinoPageRoute<bool>(
                        fullscreenDialog: false,
                        builder: (BuildContext context) => AboutPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    "Report Problem",
                    style: TextStyle(color: Colors.grey.shade900, fontSize: height*0.04),
                  ),
                  leading: Icon(Icons.report_problem_rounded, color: Colors.black45,size: height*0.04,),
                  onTap: (){
                    Navigator.of(context, rootNavigator: false).push(
                      new CupertinoPageRoute<bool>(
                        fullscreenDialog: false,
                        builder: (BuildContext context) => ReportProblemPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  onTap: (){
                    Navigator.of(context, rootNavigator: false).push(
                      new CupertinoPageRoute<bool>(
                        fullscreenDialog: false,
                        builder: (BuildContext context) => LoginScreen(),
                      ),
                    );
                  },
                  title: Text(
                    "Logout",
                    style: TextStyle(color: Colors.grey.shade900, fontSize: height*0.04),
                  ),
                  leading: Icon(Icons.logout, color: Colors.black45,size: height*0.04,),
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
}
