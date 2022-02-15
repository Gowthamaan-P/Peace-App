import 'package:flutter/material.dart';
import 'package:peace/models/user.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 70,
            alignment: Alignment.center,
            color: Colors.lightBlue.shade900,
            child: Row(
              children: <Widget>[
                IconButton(
                    onPressed: () {Navigator.pop(context);},
                    icon: Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: height*0.04,
                    )),
                Text(
                  'Profile',
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
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Icon(
                      Icons.account_circle,
                      size: height * 0.20,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "${user.name}",
                    maxLines: 2,
                    softWrap: true,
                    style: TextStyle(fontSize: height*0.06, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "${user.registerNumber}",
                            style: TextStyle(fontSize: height*0.04),
                          ),
                        ),
                        Container(
                            child: Text("Registration Number",
                              style: TextStyle(color: Colors.grey,fontSize: height*0.03),
                            )),
                        Divider(),

                        Container(
                          child: Text(
                            "${user.department}",
                            style: TextStyle(fontSize: height*0.04),
                          ),
                        ),
                        Container(
                            child: Text(
                              "Department",
                              style: TextStyle(color: Colors.grey,fontSize: height*0.03),
                            )),
                        Divider(),

                        Container(
                          child: Text(
                            "${user.email}",
                            style: TextStyle(fontSize: height*0.04),
                          ),
                        ),
                        Container(
                            child: Text(
                              "Contact",
                              style: TextStyle(color: Colors.grey,fontSize: height*0.03),
                            )),
                        Divider(),

                        Container(
                          child: Text(
                            "${user.yearOfPassing}",
                            style: TextStyle(fontSize: height*0.04),
                          ),
                        ),
                        Container(
                            child: Text(
                              "Year of Passing",
                              style: TextStyle(color: Colors.grey,fontSize: height*0.03),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
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
