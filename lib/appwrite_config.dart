import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteConfig {
  static final String endpoint     = dotenv.env['APPWRITE_ENDPOINT']!;
  static final String projectId    = dotenv.env['APPWRITE_PROJECT_ID']!;
  static final String databaseId   = dotenv.env['APPWRITE_DATABASE_ID']!;
  static final String collectionId = dotenv.env['APPWRITE_COLLECTION_ID']!;

  static Client getClient() {
    print('Appwrite Endpoint: $endpoint');
    print('Appwrite Project ID: $projectId');
    return Client()
      .setEndpoint(endpoint)
      .setProject(projectId)
      .setSelfSigned(status: true);
  }
}