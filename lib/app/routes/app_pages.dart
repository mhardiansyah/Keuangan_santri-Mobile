import 'package:get/get.dart';

import '../modules/Product/bindings/product_binding.dart';
import '../modules/Product/views/product_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/forgotpassword/bindings/forgotpassword_binding.dart';
import '../modules/forgotpassword/views/forgotpassword_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/isi_data/bindings/isi_data_binding.dart';
import '../modules/isi_data/views/isi_data_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/riwayat_transaksi/bindings/riwayat_transaksi_binding.dart';
import '../modules/riwayat_transaksi/views/riwayat_transaksi_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/controllers/splash_controller.dart';
import '../modules/splash/views/splash_view.dart';

// ignore_for_file: unused_import

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: _Paths.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.FORGOTPASSWORD,
      page: () => ForgotpasswordView(),
      binding: ForgotpasswordBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SplashController>(() => SplashController());
      }),
    ),
    GetPage(
      name: _Paths.PRODUCT,
      page: () => ProductView(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () =>  CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.ISI_DATA,
      page: () =>  IsiDataView(),
      binding: IsiDataBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT_TRANSAKSI,
      page: () =>  RiwayatTransaksiView(),
      binding: RiwayatTransaksiBinding(),
    ),
  ];
}
