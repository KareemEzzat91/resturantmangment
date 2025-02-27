import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import 'package:resturantmangment/helpers/cubit_helper/api_cubit.dart';
import '../../models/Reservation_model/Reservation_model.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String getMealType(int ?mealType) {
    switch (mealType) {
      case 1:
        return "Breakfast";
      case 2:
        return "Lunch";
      case 3:
        return "Dinner";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Reservations",
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

      body: FutureBuilder<List<Reservation>>(
        future: context.read<ApiCubit>().getReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No reservations found."));
          }

          final reservations = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Reservation #${reservation.id}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          InkWell(
                            onTap:(){
                              reservation.status == 0 ?QuickAlert.show(
                                context: context,
                                type: QuickAlertType.confirm,
                                text: 'Do you want to Cancel This Reservation ',
                                confirmBtnText: 'Yes',
                                cancelBtnText: 'No',
                                confirmBtnColor: Colors.green,
                                onConfirmBtnTap: () async{
                                  await context.read<ApiCubit>().cancelReservation(reservation.id!);

                                  setState(() {

                                  });
                                  Navigator.pop(context);
                                }
                              ):null;
                            } ,
                            child: Icon(
                              reservation.status == 1 ? Icons.check_circle : Icons.cancel,
                              color: reservation.status == 1 ? Colors.green : Colors.red,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.date_range, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text("Date: ${reservation.dayOfReservation}",
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text("Time: ${reservation.startTime} - ${reservation.finishTime}",
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.restaurant, color: Colors.purple),
                          const SizedBox(width: 8),
                          Text("Meal Type: ${getMealType(reservation.mealType)}",
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.table_chart, color: Colors.teal),
                          const SizedBox(width: 8),
                          Text("Table ID: ${reservation.tableId}",
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.payment, color: Colors.brown),
                          const SizedBox(width: 8),
                          Text("Payment Code: ${reservation.paymentCode}",
                              style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                      if (reservation.specialRequests != null &&
                          reservation.specialRequests!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              const Icon(Icons.note, color: Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text("Special Requests: ${reservation.specialRequests}",
                                    style: const TextStyle(fontSize: 16)),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
