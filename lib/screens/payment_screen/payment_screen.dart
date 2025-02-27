import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:resturantmangment/helpers/cubit_helper/api_cubit.dart';
import 'package:resturantmangment/models/order_model/order_model.dart';
import 'package:resturantmangment/screens/payment_screen/paymenthistory_screen.dart';

// Constants
const Color kPrimaryColor = Color(0xff32B768);
const Duration kAnimationDuration = Duration(milliseconds: 200);

// Extension methods for Colors
extension ColorExtension on Color {
  Color withValues({double opacity = 0.1}) {
    return withOpacity(opacity);
  }
}

/// Main PaymentScreen widget
class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create controllers
    final TextEditingController idController = TextEditingController();
    final TextEditingController paymentCodeController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolling) {
          return [
            _buildSliverAppBar(),
          ];
        },
        body: PaymentOptionsSection(
          idController: idController,
          paymentCodeController: paymentCodeController,
          amountController: amountController,
        ),
      ),
    );
  }

  /// Builds the sliver app bar with animations
  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      pinned: true,
      backgroundColor: kPrimaryColor,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: FadeInDown(
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Payment Center',
                textStyle: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            totalRepeatCount: 1,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background image with fallback
            Image.asset(
              "assets/images/payment-methods-1536x1536.jpg",
              fit: BoxFit.cover,
              color: kPrimaryColor.withOpacity(0.7),
              colorBlendMode: BlendMode.darken,
              errorBuilder: (context, error, stackTrace) => Container(
                color: kPrimaryColor,
              ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kPrimaryColor.withOpacity(0.8),
                    kPrimaryColor.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            // Centered icon and text
            Center(
              child: FadeInUp(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    const Icon(
                      Icons.account_balance_wallet,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    AnimatedTextKit(
                      animatedTexts: [
                        FadeAnimatedText(
                          'Manage Your Payments',
                          textStyle: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          duration: const Duration(milliseconds: 2000),
                        ),
                      ],
                      totalRepeatCount: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Payment options section that contains the main payment functionality
class PaymentOptionsSection extends StatelessWidget {
  final TextEditingController idController;
  final TextEditingController paymentCodeController;
  final TextEditingController amountController;

  // Form keys for validation
  final _requestFormKey = GlobalKey<FormState>();
  final _processFormKey = GlobalKey<FormState>();

  PaymentOptionsSection({
    super.key,
    required this.idController,
    required this.paymentCodeController,
    required this.amountController,
  });

  /// Shows dialog to request payment
  void _showRequestPaymentDialog(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'Submit Request',
      cancelBtnText: 'Cancel',
      showCancelBtn: true,
      customAsset: 'assets/images/RequestPayment.gif',
      onConfirmBtnTap: () async {
        // Only proceed if form is valid
        if (_requestFormKey.currentState?.validate() ?? false) {
          try {
            // Show loading indicator
            Navigator.pop(context);
            _showLoadingDialog(context, "Processing your request...");

            // Request payment
            final Order order = await context
                .read<ApiCubit>()
                .requestPayment(idController.text, paymentCodeController.text);

            // Close loading dialog
            Navigator.pop(context);

            // Show result based on response
            if (order.paymentCode == "0") {
              _showErrorDialog(
                  context, "Sorry, something went wrong with your request");
            } else {
              _showSuccessDialog(context, order);
            }
          } catch (e) {
            // Handle any exceptions
            Navigator.pop(context);
            _showErrorDialog(context, "An error occurred: ${e.toString()}");
          }
        }
      },
      widget: Form(
        key: _requestFormKey,
        child: Column(
          children: [
            Text(
              "Request Payment",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'Request ID',
                hintText: 'Enter Your Request ID',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter request ID';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: paymentCodeController,
              decoration: const InputDecoration(
                labelText: 'Request Code',
                hintText: 'Enter Your Request Code',
                prefixIcon: Icon(Icons.numbers_outlined),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter request code';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Shows form to process payment
  void _showProcessPaymentForm(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      confirmBtnText: 'Pay Now',
      title: "Process Payment",
      cancelBtnText: 'Cancel',
      showCancelBtn: true,
      customAsset: "assets/images/Payment_Procssing .gif",
      onConfirmBtnTap: () async {
        if (_processFormKey.currentState?.validate() ?? false) {
          final apiCubit = context.read<ApiCubit>();
          final Order order = await  apiCubit.processPayment(
            id: idController.text,
            amount: amountController.text,
            paymentCode: paymentCodeController.text,
            paymentMethod: (apiCubit.state as ApiSelectedPaymentMethod).selectedMethodIndex,
          );

          apiCubit.stream.listen((apiState) {
            if (apiState is LoadingState) {
              _showLoadingDialog(context, "Wait");
            }  if (apiState is SuccessState) {
              Navigator.pop(context);
              _showSuccessDialog(context, order);

               }  if (apiState is ErrorState) {
              Navigator.pop(context); // Close the loading dialog
              _showErrorDialog(context, apiState.error);
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select a payment method'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      widget: Form(
        key: _processFormKey,
        child: SizedBox(height: 400,
          child: ListView(

            children: [
              Text(
                "Complete your payment",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'Payment ID',
                  prefixIcon: Icon(Icons.qr_code_2),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    value!.isEmpty ? 'Payment ID is required' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Payment Amount',
                  hintText: 'Enter amount',
                  prefixIcon: Icon(Icons.attach_money),
                  suffixText: 'EGP',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  helperText: 'Enter the amount to be paid',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) return 'Amount is required';
                  if (double.tryParse(value) == null)
                    return 'Please enter a valid number';
                  if (double.parse(value) <= 0)
                    return 'Amount must be greater than zero';
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: paymentCodeController,
                decoration: const InputDecoration(
                  labelText: 'Payment Code',
                  hintText: 'XXXX XXXX',
                  prefixIcon: Icon(Icons.credit_card),
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Payment code is required' : null,
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Payment Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
              BlocBuilder<ApiCubit, ApiState>(
                builder: (context, state) {
                  // Default to -1 if no method selected yet
                  int selectedMethod = -1;

                  if (state is ApiSelectedPaymentMethod) {
                    selectedMethod = state.selectedMethodIndex;
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPaymentOption(
                        context,
                        'Vodafone Cash',
                        Icons.phone_android,
                        0,
                        selectedMethod,
                      ),
                      _buildPaymentOption(
                        context,
                        'Visa',
                        Icons.credit_card,
                        1,
                        selectedMethod,
                      ),
                      _buildPaymentOption(
                        context,
                        'Onsite Paid',
                        Icons.store,
                        2,
                        selectedMethod,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 15),
              BlocBuilder<ApiCubit, ApiState>(
                builder: (context, state) {
                  // Show additional fields based on selected payment method
                  if (state is ApiSelectedPaymentMethod) {
                    switch (state.selectedMethodIndex) {
                      case 0: // Vodafone Cash
                        return _buildVodafoneFields();
                      case 1: // Visa
                        return _buildVisaFields();
                      case 2: // Onsite
                        return _buildOnsiteFields();
                      default:
                        return const SizedBox.shrink();
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds payment option button with animation on selection
  Widget _buildPaymentOption(
    BuildContext context,
    String label,
    IconData icon,
    int index,
    int selectedPaymentMethod,
  ) {
    final bool isSelected = selectedPaymentMethod == index;

    return GestureDetector (
      onTap: () {
        context.read<ApiCubit>().selectPaymentMethod(index);
      },
      child: AnimatedContainer(
        duration: kAnimationDuration,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        width: 90,
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? kPrimaryColor : Colors.grey,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black54,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds Vodafone Cash specific fields
  Widget _buildVodafoneFields() {
    final phoneController = TextEditingController();

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.red, size: 18),
              const SizedBox(width: 8),
              Text(
                "Vodafone Cash Payment",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: '01X XXXX XXX',
              prefixIcon: Icon(Icons.phone),
              prefixText: '+20 ',
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone number is required';
              }
              if (value.length != 11 || !value.startsWith('01')) {
                return 'Please enter a valid Egyptian mobile number';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          const Text(
            "A confirmation SMS will be sent to this number.",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          )
        ],
      ),
    );
  }

  /// Builds Visa specific fields
  Widget _buildVisaFields() {
    final cardNumberController = TextEditingController();
    final expiryDateController = TextEditingController();
    final cvvController = TextEditingController();

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.credit_card, color: Colors.blue, size: 18),
              const SizedBox(width: 8),
              Text(
                "Credit Card Payment",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: cardNumberController,
            decoration: const InputDecoration(
              labelText: 'Card Number',
              hintText: 'XXXX XXXX XXXX XXXX',
              prefixIcon: Icon(Icons.credit_card),
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              CardNumberFormatter(),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Card number is required';
              }
              // Remove spaces to check length
              final digitsOnly = value.replaceAll(' ', '');
              if (digitsOnly.length != 16) {
                return 'Card number must be 16 digits';
              }
              // Basic Luhn algorithm check could be added here
              return null;
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: expiryDateController,
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date',
                    hintText: 'MM/YY',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    ExpiryDateFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Expiry date is required';
                    }

                    // Check format
                    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                      return 'Use MM/YY format';
                    }

                    // Validate month/year
                    final parts = value.split('/');
                    final month = int.tryParse(parts[0]);
                    final year = int.tryParse(parts[1]);

                    if (month == null ||
                        year == null ||
                        month < 1 ||
                        month > 12) {
                      return 'Invalid date';
                    }

                    // Check if card is expired
                    final currentYear = DateTime.now().year % 100;
                    final currentMonth = DateTime.now().month;

                    if (year < currentYear ||
                        (year == currentYear && month < currentMonth)) {
                      return 'Card expired';
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: cvvController,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    hintText: 'XXX',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'CVV is required';
                    }
                    if (value.length != 3) {
                      return 'CVV must be 3 digits';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds Onsite payment specific fields
  Widget _buildOnsiteFields() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.green, size: 18),
              const SizedBox(width: 8),
              Text(
                "Onsite Payment",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Please bring your payment ID and code to our location for in-person payment.",
            style: TextStyle(color: Colors.black87, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Available hours: 9:00 AM - 5:00 PM, Sunday to Thursday",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Address: 123 Main Street, Cairo",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a loading dialog
  void _showLoadingDialog(BuildContext context, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Processing',
      text: message,
    );
  }


  /// Shows error dialog
  void _showErrorDialog(BuildContext context, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: message,
    );
  }

  /// Shows success dialog with order details
  void _showSuccessDialog(BuildContext context, Order order) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        autoCloseDuration: Duration(seconds: 10),
        text: 'Request Completed Successfully!',
        widget: Column(
          children: [
            Text("Order ID: ${order.id.toString()}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text("Order Amount: ${order.amount.toString()} EGP"),
            const SizedBox(height: 5),
            Text("Your Payment Code: ${order.paymentCode}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: kPrimaryColor)),
            const SizedBox(height: 5),
            Text("Order Status: ${order.status == 0 ? "Waiting" : "Reversed"}",
                style: TextStyle(
                  color: order.status == 0 ? Colors.orange : Colors.red,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ));
  }



  /// Opens payment history screen
  void _showPaymentHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  PaymentHistoryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define payment options
    final options = [
      PaymentOption(
        title: "Request Payment",
        icon: Icons.request_page,
        color: Colors.blue,
        onTap: () => _showRequestPaymentDialog(context),
      ),
      PaymentOption(
        title: "Process Payment",
        icon: Icons.payment,
        color: Colors.green,
        onTap: () => _showProcessPaymentForm(context),
      ),
      PaymentOption(
        title: "Show All Payments",
        icon: Icons.list_alt,
        color: Colors.orange,
        onTap: () => _showPaymentHistory(context),
      ),
    ];

    return Container(
      color: Colors.grey[100],
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: options.length,
        itemBuilder: (context, index) {
          return FadeInRight(
            delay: Duration(milliseconds: 100 * index),
            child: _buildPaymentOptionCard(options[index], context),
          );
        },
      ),
    );
  }

  /// Builds a payment option card
  Widget _buildPaymentOptionCard(PaymentOption option, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: option.onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: option.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  option.icon,
                  color: option.color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option.title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Payment option model
class PaymentOption {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  PaymentOption({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

/// Custom input formatter for card number
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i % 4 == 0 && i != 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

/// Custom input formatter for expiry date
class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(text[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
