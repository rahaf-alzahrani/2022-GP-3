import 'dart:math';

String generatePassword({
  bool letter = true,
  bool isNumber = true,
  bool isSpecial = true,
}) {
  final length = 10;
  final letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
  final letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  final number = '0123456789';

  String chars = "";
  if (letter) chars += '$letterLowerCase$letterUpperCase';
  if (isNumber) chars += '$number';


  return List.generate(length, (index) {
    final indexRandom = Random.secure().nextInt(chars.length);
    return chars [indexRandom];
  }).join('');
}