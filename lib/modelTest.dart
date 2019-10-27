// models/user.dart
import 'package:andabera/auth.dart';
import 'package:andabera/card_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User {
  static const String PassionCooking = 'cooking';
  static const String PassionHiking = 'hiking';
  static const String PassionTraveling = 'traveling';
  String firstName = '';
  String lastName = '';
  Map passions = {
    PassionCooking: false,
    PassionHiking: false,
    PassionTraveling: false
  };
  bool newsletter = false;

  String _cardTitle = '';
  String _cardSubTitle = '';
  String _cardDescription = '';
  String _createdDate = '';
  String _imgURL = '';
  String _createdUser = '';
  String _relatedChanel ='';
  String _useruid ='';


  String get cardTitle => _cardTitle;

  set cardTitle(String value) {
    _cardTitle = value;
  }

  String get cardSubTitle => _cardSubTitle;

  set cardSubTitle(String value) {
    _cardSubTitle = value;
  }

  String get cardDescription => _cardDescription;

  set cardDescription(String value) {
    _cardDescription = value;
  }

  String get createdDate => DateTime.now().toString();

  set createdDate(String value) {
    _createdDate = value;
  }

  String get imgURL => 'https://placeimg.com/640/480/any';

  set imgURL(String value) {
    _imgURL = value;
  }

  String get createdUser => authService.name;

  set createdUser(String value) {
    _createdUser = value;
  }

  String get relatedChanel => _relatedChanel;

  set relatedChanel(String value) {
    _relatedChanel = value;
  }

  String get useruid => authService.uid;

  set useruid(String value) {
    _useruid = value;
  }

}