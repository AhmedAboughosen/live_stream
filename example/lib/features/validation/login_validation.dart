import 'package:fluent_validation/abstract/abstract_validator.dart';
import 'package:fluent_validation/extensions/default_validator_extensions.dart';
import 'package:fluent_validation/model/stream_validator.dart';
import 'package:injectable/injectable.dart';

@Injectable()
class LoginValidation extends AbstractValidator<LoginValidation> {
  StreamValidator email = StreamValidator();
  StreamValidator password = StreamValidator();

  LoginValidation() {
    ruleFor((e) => (e as LoginValidation).email)
        .emailAddress()
        .withMessage("email should be valid V2.");

    ruleFor((e) => (e as LoginValidation).password).between(3, 4);
  }
}
