import 'package:application_medicines/auth_controller.dart';
import 'package:application_medicines/medication.dart';
import 'package:application_medicines/medication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicationListScreen extends StatelessWidget {
  final MedicationController medicationController = Get.find<MedicationController>();

  MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Medicamentos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.find<AuthController>().logout(),
          ),
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: 'Resumen Diario',
            onPressed: () => Get.toNamed('/daily-summary'),
          ),
        ],
      ),
      body: Obx(() => ListView.builder(
            itemCount: medicationController.medications.length,
            itemBuilder: (context, index) {
              final medication = medicationController.medications[index];
              return MedicationCard(medication: medication);
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-medication'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final MedicationController medicationController = Get.find<MedicationController>();

  MedicationCard({super.key, required this.medication});

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar Medicamento'),
        content: Text('¿Estás seguro de que deseas eliminar "${medication.name}"?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              await medicationController.deleteMedication(medication.id);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(medication.name),
        subtitle: Text('Dosis: ${medication.dosage}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${medication.time.hour.toString().padLeft(2, '0')}:${medication.time.minute.toString().padLeft(2, '0')}',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
