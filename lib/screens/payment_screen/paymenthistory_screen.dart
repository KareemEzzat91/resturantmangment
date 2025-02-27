import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resturantmangment/helpers/cubit_helper/api_cubit.dart';
import 'package:resturantmangment/models/order_model/order_model.dart';

// Assuming this is defined in payment_screen.dart
const Color kPrimaryColor = Color(0xFF4CAF50);
const Color kSecondaryColor = Color(0xFF2C3E50);
const Color kErrorColor = Color(0xFFE74C3C);
const Color kSuccessColor = Color(0xFF27AE60);
const Color kPendingColor = Color(0xFFF39C12);

/// Payment history screen with a list of past payments
class PaymentHistoryScreen extends StatefulWidget {

   PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
   late Future<List<Order>> _paymentsFuture;

   @override
   void initState() {
     super.initState();
     _paymentsFuture = context.read<ApiCubit>().getAllPayments();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff32B768),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: BlocBuilder<ApiCubit, ApiState>(
        builder: (context, state) {
          return FutureBuilder<List<Order>>(
            future: _paymentsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                );
              }  if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: kErrorColor,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load payment history',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          context.read<ApiCubit>().getAllPayments();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.receipt_long,
                        color: kSecondaryColor,
                        size: 80,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No payment history found',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your completed payments will appear here',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }
              final paymentsList = snapshot.data??[];
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: paymentsList.length,
                itemBuilder: (context, index) {
                  final payment = paymentsList[index];
                  return PaymentHistoryCard(payment: payment);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class PaymentHistoryCard extends StatelessWidget {
  final Order payment;

  const PaymentHistoryCard({
    super.key,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${payment.id}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                _buildStatusBadge(payment.status),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Code',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      payment.paymentCode,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Date',
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      payment.dateOfPayment ?? 'Not Available',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPaymentMethodIcon(payment.paymentMethod),
                TextButton(
                  onPressed: () {
                    // Navigate to payment details
/*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(orderId: payment.id),
                      ),
                    );
*/
                  },
                  child: Text(
                    'View Details',
                    style: GoogleFonts.poppins(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(int status) {
    String statusText;
    Color statusColor;

    switch (status) {
      case 0:
        statusText = 'Pending';
        statusColor = kPendingColor;
        break;
      case 1:
        statusText = 'Completed';
        statusColor = kSuccessColor;
        break;
      case 2:
        statusText = 'Failed';
        statusColor = kErrorColor;
        break;
      default:
        statusText = 'Unknown';
        statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor, width: 1),
      ),
      child: Text(
        statusText,
        style: GoogleFonts.poppins(
          color: statusColor,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodIcon(int? paymentMethod) {
    IconData icon;
    String methodName;

    switch (paymentMethod) {
      case 1:
        icon = Icons.credit_card;
        methodName = 'Credit Card';
        break;
      case 2:
        icon = Icons.account_balance;
        methodName = 'Bank Transfer';
        break;
      case 3:
        icon = Icons.payment;
        methodName = 'Digital Wallet';
        break;
      default:
        icon = Icons.monetization_on;
        methodName = 'Payment';
    }

    return Row(
      children: [
        Icon(icon, color: kSecondaryColor),
        const SizedBox(width: 8),
        Text(
          methodName,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}