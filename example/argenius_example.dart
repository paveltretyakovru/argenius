import 'package:argenius/argenius.dart';

import 'global_example.dart';

void main(List<String> args) {
  // Example 1.
  // Parse cmd arguments with using global argenus variable
  argenius.parse(args);
  // Try to use global argenius instance from child objects
  GlobalExample();

  print('Named: ${argenius.named}');
  print('Ordered: ${argenius.ordered}');

  // Example 2.
  // Create private instance of argenius and parse args on init
  Argenius privateArgenius = Argenius(args: args);

  // Example 3.
  // Parse arguments values some times later with parse method
  privateArgenius.parse(args);
}
