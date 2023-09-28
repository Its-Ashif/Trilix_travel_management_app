import 'package:get/get.dart';
import 'package:trilix/controllers/popular_product_controller.dart';
import 'package:trilix/data/api/api_client.dart';
import 'package:trilix/data/repository/popular_product_repo.dart';

Future<void> init() async {
  //Api clients
  Get.lazyPut(() => ApiClient(appBaseUrl: "https://www.dbeshtech.com"));
  //repos
  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find()));
  //Controllers
  Get.lazyPut(() => PopularProductController(popularProductRepo: Get.find()));
}
