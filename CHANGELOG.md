## 1.0.0

- Initial version.

## 1.1.0
- Added github action to publish tags
- Added method stringToList(). The method parsing string to arguments list

```dart
Argenius.stringToList('dart run hello --world Name')
// returns: ['dart', 'run', 'hello', '--world', 'Name']
```