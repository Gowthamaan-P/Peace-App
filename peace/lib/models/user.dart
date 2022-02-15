import 'package:peace/dataBaseProviders/registrationController.dart';

class User{
  String _name;
  String _registerNumber;
  String _department;

  String _yearOfPassing;
  String _email;

  User(this._name, this._registerNumber, this._department, this._yearOfPassing, this._email);

  String get name => this._name;
  String get registerNumber => this._registerNumber;
  String get department => this._department;
  String get yearOfPassing => this._yearOfPassing;
  String get email => this._email;

  set email(newEmail) => this._email = newEmail;
  set name(newName) => this._name = newName;
  set department(newDepartment) => this._department = newDepartment;
  set yearOfPassing(newYearOfPassing) => this._yearOfPassing = newYearOfPassing;
  set registerNumber(newRegisterNumber) => this._registerNumber = newRegisterNumber;
}

void setUpUser(RegisterStudent student){
  user.name = student.name;
  user.registerNumber = student.registerNumber;
  user.email = student.email;
  user.department = student.registerNumber.substring(2,4);
  int temp = (2000+int.parse(student.registerNumber.substring(0,2)));
  user.yearOfPassing = "$temp-${temp+4}";
}


User user = User("", "", "", "","");