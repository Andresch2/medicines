import 'package:application_medicines/appwrite_config.dart';
import 'package:application_medicines/medication.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';

class MedicationController extends GetxController {
  final Databases databases = Databases(AppwriteConfig.getClient());
  final RxList<Medication> medications = <Medication>[].obs;

  final String databaseId = AppwriteConfig.databaseId;
  final String collectionId = AppwriteConfig.collectionId;

  @override
  void onInit() {
    super.onInit();
    getMedications();
  }

  Future<void> addMedication(Medication medication) async {
    try {
      print('[addMedication] Datos enviados: ${medication.toJson()}');

      await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: ID.unique(),
        data: medication.toJson(),
        permissions: [
          Permission.read(Role.user(medication.userId)),
          Permission.update(Role.user(medication.userId)),
          Permission.delete(Role.user(medication.userId)),
        ],
      );
      await getMedications();
      Get.snackbar('Éxito', 'Medicamento agregado correctamente');
    } on AppwriteException catch (err) {
      Get.log('AppwriteException: code=${err.code}, message=${err.message}');
      Get.snackbar('Error Appwrite', err.message ?? err.toString());
    } catch (e) {
      Get.log('Error al agregar medicamento: $e');
      Get.snackbar('Error al agregar medicamento', e.toString());
    }
  }

  Future<void> getMedications() async {
    try {
      final DocumentList response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      );

      medications.value = response.documents.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['\$id'] = doc.$id;
        return Medication.fromJson(data);
      }).toList();
    } catch (e) {
      Get.log('Error al obtener medicamentos: $e');
      Get.snackbar('Error al obtener medicamentos', e.toString());
    }
  }

  Future<void> updateMedication(Medication medication) async {
    try {
      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: medication.id,
        data: medication.toJson(),
      );
      await getMedications();
      Get.snackbar('Éxito', 'Medicamento actualizado correctamente');
    } catch (e) {
      Get.log('Error al actualizar medicamento: $e');
      Get.snackbar('Error al actualizar medicamento', e.toString());
    }
  }

  Future<void> updateMedicationStatus(String medicationId, String newStatus) async {
    try {
      final index = medications.indexWhere((med) => med.id == medicationId);
      if (index == -1) {
        Get.snackbar('Error', 'Medicamento no encontrado');
        return;
      }

      Medication med = medications[index];
      med.status = newStatus;

      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: med.id,
        data: med.toJson(),
      );

      medications[index] = med;
      medications.refresh();

      Get.snackbar('Éxito', 'Estado del medicamento actualizado');
    } catch (e) {
      Get.log('Error al actualizar estado de medicamento: $e');
      Get.snackbar('Error', 'No se pudo actualizar el estado');
    }
  }

  Future<void> deleteMedication(String medicationId) async {
    try {
      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        documentId: medicationId,
      );
      await getMedications();
      Get.snackbar('Éxito', 'Medicamento eliminado correctamente');
    } catch (e) {
      Get.log('Error al eliminar medicamento: $e');
      Get.snackbar('Error al eliminar medicamento', e.toString());
    }
  }
}
