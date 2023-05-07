import 'package:argenius/argenius.dart';

void main(List<String> args) {
  argenius.parse(args);

  print('Named arguments: ${argenius.named}');
  print('Ordered arguments: ${argenius.ordered}');
}
