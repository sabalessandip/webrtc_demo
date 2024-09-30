import 'dart:math';

mixin CallerIdGenerator {
  String generateCallerId() {
    return Random().nextInt(999999).toString().padLeft(6, '0');
  }
}
