import 'package:contact_app/contact_app/model/contact_model.dart';
import 'package:contact_app/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

class ObjectBox{
  late final Store store;
  late final Box<ContactModel> contactBox;

  static late final ObjectBox _instance;

  static ObjectBox get  instance{
    return _instance;
  }

  ObjectBox._create(this.store){
  contactBox=Box<ContactModel>(store);
  }

  static Future<ObjectBox> create()async{
   final docsDir = await getApplicationDocumentsDirectory();
    final store = Store(getObjectBoxModel(), directory: docsDir.path);
    _instance = ObjectBox._create(store);
    return _instance;
  }
}