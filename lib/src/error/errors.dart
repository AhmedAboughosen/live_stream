/// PropertyException
abstract class PropertyException implements Exception {
  ///
  final Object propertyKey;
  final String _message;

  ///
  PropertyException(this.propertyKey, this._message);

  @override
  String toString() {
    return _message;
  }

}

/// NotfoundPropertyException
class NotfoundPropertyException extends PropertyException {
  /// NotfoundPropertyException
  NotfoundPropertyException(Object propertyKey) : super(propertyKey, '''


  Property not found. 
    - propertyKey: $propertyKey  
''');
}

