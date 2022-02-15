import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contact/contact.dart';
import 'package:flutter_contact/contacts.dart';
import 'package:peace/dataBaseProviders/councellorContactProvider.dart';
import 'package:peace/helpers/snackBar.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:url_launcher/url_launcher.dart';

class CouncellorContactsScreen extends StatelessWidget {
  const CouncellorContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
                      size: height * 0.045,
                    )),
                Text(
                  'Councellor Contacts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            height: height - 150,
            child: ListView.builder(
                itemCount: councellor.length,
                itemBuilder: (BuildContext context,int index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Card(
                      color: Colors.blue.shade100,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: Container(
                        height: height * 0.3,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: height * 0.17,
                                    width: (width - 80) * 0.4,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: NetworkImage(councellor[index].pictureUrl),fit: BoxFit.fill),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: height * 0.17,
                                    width: (width - 80) * 0.6,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "${councellor[index].professorName}",
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              height: 0.7,
                                              color: Colors.orange.shade500,
                                              fontSize: height * 0.05),
                                        ),
                                        Text(
                                          "${councellor[index].department}",
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              height: 0.7,
                                              fontSize: height * 0.05),
                                        ),
                                        Spacer(),
                                        TouchableOpacity(
                                          onTap:()=> _launchMailClient("${councellor[index].professorName}"),
                                          child: Text(
                                            "${councellor[index].email}",
                                            style: TextStyle(
                                                fontSize: height*0.04,
                                                fontWeight: FontWeight.normal,
                                                height: 0.9,
                                                color: Colors.blue[700]),
                                          ),
                                        ),
                                        TouchableOpacity(
                                          onLongPress:()async{
                                            await Clipboard.setData(ClipboardData(text: "${councellor[index].phoneNumber}"));
                                          },
                                          child: Text(
                                            "${councellor[index].phoneNumber}",
                                            style: TextStyle(
                                                fontSize: height*0.04,
                                                fontWeight: FontWeight.normal,
                                                height: 0.9,
                                                color: Colors.blue[700]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                TouchableOpacity(
                                  onTap: (){
                                    bookAppointment(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                    width: (width - 80) * 0.45,
                                    child: Container(
                                      height: height * 0.05,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.blue.shade900,
                                          borderRadius: BorderRadius.all(Radius.circular(15))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                        child: Text(
                                          "Wanna Talk?",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: (MediaQuery.of(context).size.height) * 0.035,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: (width - 80) * 0.55,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(onPressed: (){
                                        showSnackBar("Verified authority", context);
                                      }, icon: Icon(Icons.verified_user_rounded, size: height*0.04,)),
                                      IconButton(onPressed: (){
                                        _launchURL(councellor[index].profileUrl);
                                      }, icon: Icon(Icons.link_rounded, size: height*0.04,)),
                                      IconButton(onPressed: (){
                                        saveContact(councellor[index], context);
                                      }, icon: Icon(Icons.contact_phone_rounded, size: height*0.04,)),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Puducherry Technological University',
              style: TextStyle(
                color: Colors.grey,
                fontSize: height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchMailClient(String mail) async {
    final mailUrl = 'mailto:$mail';
    try {
      await launch(mailUrl);
    } catch (e) {
      await Clipboard.setData(ClipboardData(text: "$mail"));
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void saveContact(CouncellorContact user, BuildContext context)async{
    Contact contact = Contact();
    PostalAddress address = PostalAddress(label: 'Home');
    contact.givenName = user.professorName;
    contact.middleName =  "";
    contact.familyName =  "";
    contact.prefix =  "";
    contact.suffix =  "";
    contact.company =  "";
    contact.jobTitle =  "";
    address.street =  "";
    address.city =  "";
    address.region =  "";
    address.postcode =  "";
    address.country = "";
    contact.phones = [ Item(label: 'mobile', value: user.phoneNumber)];
    contact.emails = [Item(label: 'work', value: user.email)];
    contact.postalAddresses = [address];
    await Contacts.addContact(contact);
    showSnackBar("Contact saved successfully", context);
  }
}
