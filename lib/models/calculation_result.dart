class ApplicationItem {
  const ApplicationItem({
    required this.date,
    required this.stageName,
    required this.productName,
    required this.dosagePerHa,
    required this.totalAmount,
  });

  final DateTime date;
  final String stageName;
  final String productName;
  final double dosagePerHa;
  final double totalAmount;
}

class CalculationResult {
  const CalculationResult({
    required this.items,
    required this.totalAmount,
  });

  final List<ApplicationItem> items;
  final double totalAmount;
}
