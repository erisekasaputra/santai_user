import 'package:santai/app/domain/enumerations/percentage_or_value_type.dart';

class Fee {
  final PercentageOrValueType parameter;
  final String feeDescription;
  final String currency;
  final double valuePercentage;
  final double valueAmount;
  final double feeAmount;

  Fee({
    required this.parameter,
    required this.feeDescription,
    required this.currency,
    required this.valuePercentage,
    required this.valueAmount,
    required this.feeAmount,
  });
}
