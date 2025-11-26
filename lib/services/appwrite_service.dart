import 'package:appwrite/appwrite.dart';
import '../constants/appwrite_constants.dart';

class AppwriteService {
  late Client client;
  late Account account;
  late Databases databases;

  AppwriteService() {
    client = Client()
        .setEndpoint(AppwriteConstants.endpoint)
        .setProject(AppwriteConstants.projectId);
    
    account = Account(client);
    databases = Databases(client);
  }
}
