/// Copyright © 2023 Pavel Tretyakov. All rights reserved.
import 'package:argenius/argenius.dart';
import 'package:test/test.dart';

const List<String> fullsetArguments = [
  'param1',
  '--name1', 'valueName1',
  'param2',
  '--name2=valueName2'
];

const List<String> orderedArguments = ['param1', 'param2'];

const List<String> namedArguments = [
  '--name1', 'valueName1',
  '--name2', 'valueName2'
];

const List<String> fullNamedArguments = [
  '--name1=valueName1',
  '--name1=valueName2'
];

void main() {
  group('Argenius', () {
    group('global instance', () {
      test('should be exists', () {
        expect(argenius, isNotNull);
      });

      test('should parse arguments', () {
        argenius.parse(fullsetArguments);

        expect(argenius.arguments, isNotEmpty);
      });

      test('should parse arguments without names (ordered)', () {
        expect(argenius.ordered, isNotEmpty);
      });

      test('should parse arguments without names', () {
        expect(argenius.named, isNotEmpty);
      });
    });

    group('local instance', () {
      late Argenius instance;
      late Argenius instanceWithoutArgs;

      setUpAll(() {
        instance = Argenius(args: fullsetArguments);
        instanceWithoutArgs = Argenius();
      });

      test('should create create instance of Argenius', () {
        expect(instanceWithoutArgs, isNotNull);
        expect(instanceWithoutArgs.arguments, isEmpty);
      });

      test('should parse arguments on construct', () {
        expect(instance.arguments, isNotEmpty);
      });

      test('should parse arguments without names (ordered)', () {
        expect(instance.ordered, isNotEmpty);
      });

      test('should parse arguments without names', () {
        expect(instance.named, isNotEmpty);
      });
    });

    group('parse method', () {
      test('should parse fullset arguments list', () {
        Argenius instance = Argenius(args: fullsetArguments);

        expect(instance, isNotNull);
        expect(instance.arguments, isNotEmpty);

        expect(instance.named, isNotEmpty);
        expect(instance.ordered, isNotEmpty);
      });

      test('should parse only named arguments list', () {
        Argenius instance = Argenius(args: namedArguments);

        expect(instance, isNotNull);
        expect(instance.arguments, isNotEmpty);

        expect(instance.named, isNotEmpty);
        expect(instance.ordered, isEmpty);
      });

      test('should parse only fullnamed (name=value) arguments list', () {
        Argenius instance = Argenius(args: fullNamedArguments);

        expect(instance, isNotNull);
        expect(instance.arguments, isNotEmpty);

        expect(instance.named, isNotEmpty);
        expect(instance.ordered, isEmpty);
      });

      test('should parse arguments list without names (ordered)', () {
        Argenius instance = Argenius(args: orderedArguments);

        expect(instance, isNotNull);
        expect(instance.arguments, isNotEmpty);

        expect(instance.named, isEmpty);
        expect(instance.ordered, isNotEmpty);
      });
    });

    group('stringToList', () {
      test('should return list arguments', () {
        final List<String> result = Argenius.stringToList('dart run hello --world Name');
        final List<String> need = ['dart', 'run', 'hello', '--world', 'Name'];

        expect(result.join(',') == need.join(','), isTrue);
      });
    });
  });
}
