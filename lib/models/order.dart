class Order {
  final String id;
  final double total;
  final List<dynamic> products;
  final DateTime date;

  Order(
    {
      required this.id,
      required this.total,
      required this.products,
      required this.date
    }
  );
}
