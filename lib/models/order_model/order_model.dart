class Order {
  final int id;
  final double amount;
  String? dateOfPayment;
  final String paymentCode;
  final int status;
  int? paymentMethod;

  Order({
    required this.id,
    required this.amount,
    this.dateOfPayment,
    required this.paymentCode,
    required this.status,
    this.paymentMethod,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      amount: json['amount'],
      dateOfPayment: json['dateOfPayment'],
      paymentCode: json['paymentCode'],
      status: json['status'],
      paymentMethod: json['paymentMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['amount'] = this.amount;
    data['dateOfPayment'] = this.dateOfPayment;
    data['paymentCode'] = this.paymentCode;
    data['status'] = this.status;
    data['paymentMethod'] = this.paymentMethod;
    return data;
  }
}