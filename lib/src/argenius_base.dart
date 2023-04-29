RegExp argumentWithName = RegExp(r'^--\s*(.*)');
RegExp nameWithValueArgument = RegExp(r'^--\s*(.*)=\s*(.*)$');

class Argenius {
  final List<String> ordered = [];
  final List<String> arguments = [];
  final Map<String, String> named = {};

  Argenius({ List<String> args = const [] }) {
    parse(args);
  }

  bool isNamedArg(String arg) => argumentWithName.hasMatch(arg);
  bool isNameWithValue(String arg) => nameWithValueArgument.hasMatch(arg);

  parse(List<String> args) {
    arguments.addAll(args);

    for (var i = 0; i < arguments.length; i++) {
      String arg = arguments[i];

      if (isNameWithValue(arg)) {
        final List<String> nameWithValue = getNameWithValue(arg);
        
        if (nameWithValue.isNotEmpty) {
          named[nameWithValue[0]] = nameWithValue[1];
        }
      } else if (isNamedArg(arg)) {
        String? name = getName(arg);

        if (name != null) {
          String? value = arguments[i + 1];
          named[name] = value;
          i++;
        }
      } else {
        ordered.add(arg);
      }
    }
  }

  String? getName(String arg) {
    final match = argumentWithName.firstMatch(arg);

    if (match != null) {
      try {
        return match[1];
      } catch (e) {
        print('Unparsed $match');
      }
    }

    return null;
  }

  List<String> getNameWithValue(String arg) {
    final match = nameWithValueArgument.firstMatch(arg);

    if (match != null) {
      try {
        final name = match[1];
        final value = match[2];

        if (name != null && value != null) {
          return [name, value];
        }
      } catch (e) {
        print('Unparsed $match');
      }
    }

    return [];
  }
} 