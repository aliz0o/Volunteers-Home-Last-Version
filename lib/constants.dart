import 'package:flutter/material.dart';

const TextStyle kAppBarTextStyle = TextStyle(
  fontFamily: 'Aclonica',
  fontSize: 25,
);

const TextStyle kTapControllerTextStyle =
    TextStyle(fontSize: 16, fontFamily: 'Aclonica');
const TextStyle proto = TextStyle(fontSize: 14, fontFamily: 'Aclonica');

const TextStyle kEventInfoTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Product Sans',
);

Decoration kEventCardBorderDecoration = BoxDecoration(
  border: Border.all(
    color: Colors.white.withOpacity(0.15),
  ),
);

const TextStyle kNumberTextStyle =
    TextStyle(fontFamily: 'Aclonica', fontSize: 14.5, color: Colors.white);

//

InputDecoration kTextFieldDecoration = InputDecoration(
  hintText: '',
  hintStyle: TextStyle(color: Colors.white.withOpacity(0.30), fontSize: 12),
  contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: Color(0xff0962ff),
    ),
  ),
  filled: true,
  fillColor: Colors.white.withOpacity(0.06),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.white.withOpacity(0.20)),
  ),
);

InputDecoration kNumberFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: Color(0xff0962ff),
    ),
  ),
  filled: true,
  fillColor: Colors.white.withOpacity(0.06),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.white.withOpacity(0.20)),
  ),
);

const TextStyle kTextFieldStyle = TextStyle(
  fontFamily: 'Product Sans',
  fontSize: 13,
  color: Colors.white,
);

const TextStyle kNumberFieldLabel = TextStyle(
  fontFamily: 'Product Sans',
  fontSize: 13,
  color: Colors.white,
);

EdgeInsets textFieldPadding = EdgeInsets.fromLTRB(30, 0, 30, 0);

const kCityList = [
  'Amman',
  'AL-zarqa',
  'irbid',
  'Aqaba',
  'AL-Salt',
  'Jerash',
  'Ajloun',
  'AL-Karak',
  'AL-Tafilah',
  'Ma\'an',
  'Al-Mafraq',
  'al balqa'
];

const kEventTypeList = [
  'Medical',
  'Educational',
  'Cultural',
  'Religious ',
  'Entertaining',
  'Environmental',
  'Other',
];

const TextStyle kDateTimeTextStyle = TextStyle(
  fontFamily: 'Product Sans',
  fontSize: 15,
  color: Colors.white,
);

InputDecoration kDateTimeDecoration = InputDecoration(
  hintText: 'Event Date',
  hintStyle: TextStyle(
      color: Colors.white.withOpacity(0.30),
      fontSize: 12,
      fontFamily: 'Aclonica'),
  contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: Color(0xff0962ff),
    ),
  ),
  filled: true,
  fillColor: Colors.white.withOpacity(0.06),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.white.withOpacity(0.20)),
  ),
);

const TextStyle kArabicTextStyle = TextStyle(
  fontFamily: 'Amiri',
  fontSize: 15,
  color: Colors.white,
);

InputDecoration kArabicTextDecoration = InputDecoration(
  hintText: 'باقي التفاصيل',
  hintStyle: TextStyle(color: Colors.white.withOpacity(0.47), fontSize: 13),
  contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: Color(0xff0962ff),
    ),
  ),
  filled: true,
  fillColor: Colors.white.withOpacity(0.06),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.white.withOpacity(0.20)),
  ),
);

const TextStyle kDropDownTextStyle = TextStyle(
  fontFamily: 'Aclonica',
  fontSize: 15.5,
  color: Colors.white,
);

InputDecoration kDropDownInputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white.withOpacity(0.06),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.white.withOpacity(0.25)),
  ),
);

const TextStyle kEventCardButtonTextStyle =
    TextStyle(color: Colors.white, fontFamily: 'Aclonica', fontSize: 15);
