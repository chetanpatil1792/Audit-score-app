import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'controller/AuditProcessController.dart';
import 'controller/GoToAuditController.dart';


class GotoAuditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoToAuditController>(() => GoToAuditController());
  }
}



class AuditProcessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuditProcessController>(() => AuditProcessController());
  }
}


