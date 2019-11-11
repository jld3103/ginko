import 'package:ginko/loaders/loader.dart';
import 'package:models/models.dart';

/// SubstitutionPlanLoader class
class SubstitutionPlanLoader extends Loader {
  // ignore: public_member_api_docs
  SubstitutionPlanLoader() : super(Keys.substitutionPlan);

  @override
  // ignore: type_annotate_public_apis, always_declare_return_types
  fromJSON(json) => SubstitutionPlanForGrade.fromJSON(json);

  @override
  SubstitutionPlanForGrade get data => object;
}
