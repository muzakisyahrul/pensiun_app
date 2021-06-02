import 'package:html/parser.dart';

// const String BASE_URL_API = "http://192.168.87.174:81/pensiun_app/";
const String BASE_URL_API = "http://192.168.43.68:81/pensiun_app/";

//here goes the function
String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}
