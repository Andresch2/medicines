import 'package:application_medicines/auth_controller.dart';
import 'package:application_medicines/medication.dart';
import 'package:application_medicines/medication_controller.dart';
import 'package:application_medicines/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMedicationScreen extends StatelessWidget {
  AddMedicationScreen({super.key});

  final MedicationController medicationController = Get.find<MedicationController>();
  final NotificationService notificationService = Get.find<NotificationService>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;

  final RxString nameError = ''.obs;
  final RxString dosageError = ''.obs;

  bool validateInputs() {
    bool isValid = true;
    nameError.value = '';
    dosageError.value = '';

    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Por favor ingrese el nombre del medicamento';
      isValid = false;
    }

    if (dosageController.text.trim().isEmpty) {
      dosageError.value = 'Por favor ingrese la dosis';
      isValid = false;
    } else if (!RegExp(r'^\d+$').hasMatch(dosageController.text.trim())) {
      dosageError.value = 'La dosis debe ser un número';
      isValid = false;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Medicamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del Medicamento',
                    border: const OutlineInputBorder(),
                    errorText: nameError.value.isEmpty ? null : nameError.value,
                  ),
                )),
            const SizedBox(height: 16),
            Obx(() => TextField(
                  controller: dosageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Dosis',
                    border: const OutlineInputBorder(),
                    errorText: dosageError.value.isEmpty ? null : dosageError.value,
                  ),
                )),
            const SizedBox(height: 16),
            Obx(() => ListTile(
                  title: const Text('Hora de la Medicación'),
                  subtitle: Text(
                    '${selectedTime.value.hour}:${selectedTime.value.minute.toString().padLeft(2, '0')}',
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime.value,
                    );
                    if (time != null) {
                      selectedTime.value = time;
                    }
                  },
                )),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (!validateInputs()) return;

                final now = DateTime.now();
                final medicationTime = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  selectedTime.value.hour,
                  selectedTime.value.minute,
                );

                try {
                  final user = await Get.find<AuthController>().account.get();
                  final userId = user.$id;
                  print("User ID: $userId");

                  final medication = Medication(
                    id: '',
                    name: nameController.text.trim(),
                    dosage: dosageController.text.trim(),
                    time: medicationTime,
                    userId: userId,
                  );

                  await medicationController.addMedication(medication);

                  await notificationService.scheduleMedicationNotification(
                    'Es hora de tu medicamento',
                    'Toma ${medication.name} - ${medication.dosage}',
                    medicationTime,
                  );

                  Get.back();
                } catch (e) {
                  Get.snackbar('Error', 'No se pudo guardar el medicamento: $e');
                }
              },
              child: const Text('Guardar Medicamento'),
            ),
          ],
        ),
      ),
    );
  }
}
