import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../medication_controller.dart';

class DailySummaryScreen extends StatelessWidget {
  const DailySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MedicationController medicationController = Get.find<MedicationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen Diario'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        final today = DateTime.now();
        final medicationsToday = medicationController.medications.where((med) {
          return med.time.year == today.year &&
              med.time.month == today.month &&
              med.time.day == today.day;
        }).toList();

        if (medicationsToday.isEmpty) {
          return const Center(child: Text('No hay medicamentos para hoy'));
        }

        return ListView.builder(
          itemCount: medicationsToday.length,
          itemBuilder: (context, index) {
            final medication = medicationsToday[index];

            final now = DateTime.now();
            String estado = medication.status;

            if (estado != 'tomado') {
              if (now.isBefore(medication.time)) {
                estado = 'pendiente';
              } else if (now.isAfter(medication.time.add(const Duration(minutes: 30)))) {
                estado = 'retrasado';
              } else {
                estado = 'pendiente';
              }
            } else {
              estado = 'tomado';
            }

            Color color;
            switch (estado) {
              case 'tomado':
                color = Colors.green;
                break;
              case 'pendiente':
                color = Colors.orange;
                break;
              case 'retrasado':
                color = Colors.red;
                break;
              default:
                color = Colors.grey;
            }

            return ListTile(
              title: Text(medication.name),
              trailing: Text(
                estado.toUpperCase(),
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                if (estado != 'tomado') {
                  medication.status = 'tomado';
                  medicationController.updateMedicationStatus(medication.id, 'tomado');
                  Get.snackbar('¡Listo!', 'Medicamento marcado como tomado');
                }
              },
            );
          },
        );
      }),
    );
  }
}
