import 'package:fluent_validation/abstract/abstract_validator.dart';
import 'package:fluent_validation/extensions/default_validator_extensions.dart';
import 'package:fluent_validation/model/stream_validator.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class CreateAppPinValidation extends AbstractValidator<CreateAppPinValidation> {
  StreamValidator password = StreamValidator();
  StreamValidator confirmPassword = StreamValidator();

  CreateAppPinValidation() {
    ruleFor((e) => (e as CreateAppPinValidation).password).between(3, 4);

    ruleFor((e) => (e as CreateAppPinValidation).confirmPassword)
        .equal((e) => (e as CreateAppPinValidation).password)
        .withMessage("confrim password not equal to password.");
  }

  void dispose() {}
}
