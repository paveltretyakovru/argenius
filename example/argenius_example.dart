import 'package:argenius/argenius.dart';

import 'global_example.dart';

/// To run example use command:
/// dart argenius_example.dart param1 --name1 value1 param2 --name2=value2

void main(List<String> args) {
  // Example 1.
  // Parse cmd arguments with using global argenus variable
  argenius.parse(args);
  // Try to use global argenius instance from child objects
  GlobalExample();

  print('Named arguments: ${argenius.named}');
  print('Ordered arguments: ${argenius.ordered}');

  // Example 2.
  // Create private instance of argenius and parse args on init
  Argenius privateArgenius = Argenius(args: args);

  // Example 3.
  // Parse arguments values some times later with parse method
  privateArgenius.parse(args);
}
