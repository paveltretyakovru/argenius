/// Copyright © 2023 Pavel Tretyakov. All rights reserved.

RegExp argumentWithName = RegExp(r'^--\s*(.*)');
RegExp nameWithValueArgument = RegExp(r'^--\s*(.*)=\s*(.*)$');

/// Base class [Argenius]
class Argenius {
  /// List of arguments without names
  /// 
  /// For example, afte parsing next command:
  /// dart_app param1 --param2 value2 --param3=value3
  /// 
  /// [ordered] will be ['param1']
  final List<String> ordered = [];

  /// List of all arguments
  /// 
  /// For example, afte parsing next command:
  /// dart_app param1 --param2 value2 --param3=value3
  /// 
  /// [arguments] will be ['param1', '--param2', 'value2', '--param3=value3']
  final List<String> arguments = [];

  /// Map of arguments with values
  /// 
  /// For example, afte parsing next command:
  /// dart_app param1 --param2 value2 --param3=value3
  /// 
  /// [named] will be {'param2': 'value2', 'param3'='value3'}
  final Map<String, String> named = {};

  Argenius({ List<String> args = const [] }) {
    parse(args);
  }

  /// If [arg] string is a **name of variable with value and start with '--'**
  /// then return true
  /// 
  /// For example, command with next args:
  /// dart_app param1 --param2 value2 --param3=value3
  /// 
  /// Will parse arguments with the method:
  /// 
  /// hasNameAndValue('param1') - return false
  /// hasNameAndValue('--param2') - return false
  /// hasNameAndValue('value2') - return false
  /// hasNameAndValue('--param3=value3') - return true
  /// 
  /// Only '--param3=value3' returns true, bacause:
  /// - param1 is argument without value, and don't start with '--'
  /// - --param2 is only name variable without value
  /// - value2 is only argument value without name and don't start with '--'
  bool hasNameAndValue(String arg) => nameWithValueArgument.hasMatch(arg);

  /// If [arg] string is a name of variable and start with '--' then return true
  /// 
  /// For example, command with next args:
  /// dart_app param1 --param2 value2 --param3=value3
  /// 
  /// Will parse arguments with the method:
  /// 
  /// isNameOfVariable('param1') - return false
  /// isNameOfVariable('--param2') - return true
  /// isNameOfVariable('value2') - return false
  /// isNameOfVariable('--param3=value3') - return false
  /// 
  /// Only '--param2' returns true, bacause:
  /// - param1 is argument without value, and not started with '--'
  /// - value2 is a param2 value (is not name), and not started with '--'
  /// - --param3=value3 is varaible name with value, but we waiting only name
  bool isNameOfVariable(String arg) {
    return hasNameAndValue(arg) ? false : argumentWithName.hasMatch(arg);
  }

  /// [parse] is a basic method to parse command line arguments
  /// [args] is list of arguments from app main function.
  /// Currently it's parsing next argument types:
  /// 
  /// - default parameters without flags and names
  /// 
  /// For example:
  /// 
  /// ```bash
  /// some_dart_app param1 param2 param3 paramEtc
  /// ```
  /// 
  /// And now instance of argenius have a property [ordered] with values:
  /// 
  /// ```
  /// List<String> argenius.ordered=['param1', 'param2', 'param3', 'paramEtc']
  /// ```
  /// --------------------------------------------
  /// 
  /// - named argument with names wich started with double minus and name with
  /// value is spliting with space symbol ' '
  /// 
  /// For example:
  /// 
  /// ```bash
  /// some_dart_app --name1 value1 name2 value
  /// ```
  /// 
  /// And now instance of argenius have a property [named] with values:
  /// 
  /// ```
  /// Map<String, String> argenius.named={'name1': 'value1', 'name2': 'value2'}
  /// ```
  /// --------------------------------------------
  /// 
  /// - named argument with names wich started with double minus and name with
  /// value is spliting with equals symbol '='
  /// 
  /// For example:
  /// 
  /// ```bash
  /// some_dart_app --name1=value1 name2=value
  /// ```
  /// 
  /// And now instance of argenius have a property [named] with values:
  /// 
  /// ```
  /// Map<String, String> argenius.named={'name1': 'value1', 'name2': 'value2'}
  /// ```
  /// 
  parse(List<String> args) {
    arguments.addAll(args);

    for (var i = 0; i < arguments.length; i++) {
      String arg = arguments[i];

      if (hasNameAndValue(arg)) {
        final List<String> nameWithValue = getNameWithValue(arg);
        
        if (nameWithValue.isNotEmpty) {
          named[nameWithValue[0]] = nameWithValue[1];
        }
      } else if (isNameOfVariable(arg)) {
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

  /// If [argument] is name of variable, then return **clear name** without
  /// specific head symbols (f.e. '--', '-').
  /// If it's not imposible to parse string then return **null**
  /// 
  /// For example:
  /// getName('--argument') // return 'argument'
  /// getName('argument') // return null, becouse it's value or deafult arg
  /// getName('--argument=value') // return null, becouse it's not only name
  String? getName(String argument) {
    final match = argumentWithName.firstMatch(argument);

    if (match != null) {
      try {
        return match[1];
      } catch (e) {
        print('Unparsed $match');
      }
    }

    return null;
  }

  /// If [argument] is variable name with value, then return next array:
  /// [variableName, variableValue] else return empty array ([]).
  /// 
  /// For example:
  /// getNameWithValue('--argument') // return [], because it's only var name
  /// getNameWithValue('argument') // return [], because it's only value or dflt
  /// getNameWithValue('--argument=value') // return ['argument', 'value']
  List<String> getNameWithValue(String argument) {
    final match = nameWithValueArgument.firstMatch(argument);

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