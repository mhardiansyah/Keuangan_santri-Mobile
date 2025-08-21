import 'package:get/get.dart';

import '../modules/Product/bindings/product_binding.dart';
import '../modules/Product/views/product_view.dart';
import '../modules/Top-up/bindings/top_up_binding.dart';
import '../modules/Top-up/views/top_up_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/detail_notif/bindings/detail_notif_binding.dart';
import '../modules/detail_notif/views/detail_notif_view.dart';
import '../modules/detail_riwayat_transaksi/bindings/detail_riwayat_transaksi_binding.dart';
import '../modules/detail_riwayat_transaksi/views/detail_riwayat_transaksi_view.dart';
import '../modules/forgotpassword/bindings/forgotpassword_binding.dart';
import '../modules/forgotpassword/views/forgotpassword_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/isi_data/bindings/isi_data_binding.dart';
import '../modules/isi_data/views/isi_data_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main-navigation/bindings/main_navigation_binding.dart';
import '../modules/main-navigation/views/main_navigation_view.dart';
import '../modules/nominal/bindings/nominal_binding.dart';
import '../modules/nominal/views/nominal_view.dart';
import '../modules/notif_pembayaran/bindings/notif_pembayaran_binding.dart';
import '../modules/notif_pembayaran/views/notif_pembayaran_view.dart';
import '../modules/notifikasi/bindings/notifikasi_binding.dart';
import '../modules/notifikasi/views/notifikasi_view.dart';
import '../modules/payment/bindings/payment_binding.dart';
import '../modules/payment/views/payment_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/riwayat_hutang/bindings/riwayat_hutang_binding.dart';
import '../modules/riwayat_hutang/views/riwayat_hutang_view.dart';
import '../modules/riwayat_transaksi/bindings/riwayat_transaksi_binding.dart';
import '../modules/riwayat_transaksi/views/riwayat_transaksi_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/controllers/splash_controller.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/waiting_tap/bindings/waiting_tap_binding.dart';
import '../modules/waiting_tap/views/waiting_tap_view.dart';

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
    GetPage(name: _Paths.CART, page: () => CartView(), binding: CartBinding()),
    GetPage(
      name: _Paths.MAIN_NAVIGATION,
      page: () => MainNavigationView(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: _Paths.ISI_DATA,
      page: () => IsiDataView(),
      binding: IsiDataBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT_TRANSAKSI,
      page: () => RiwayatTransaksiView(),
      binding: RiwayatTransaksiBinding(),
    ),
    GetPage(
      name: _Paths.TOP_UP,
      page: () => const TopUpView(),
      binding: TopUpBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.WAITING_TAP,
      page: () => const WaitingTapView(),
      binding: WaitingTapBinding(),
    ),
    GetPage(
      name: _Paths.NOTIF_PEMBAYARAN,
      page: () => const NotifPembayaranView(),
      binding: NotifPembayaranBinding(),
    ),
    GetPage(
      name: _Paths.NOMINAL,
      page: () => NominalView(),
      binding: NominalBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => PaymentView(),
      binding: PaymentBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFIKASI,
      page: () => const NotifikasiView(),
      binding: NotifikasiBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_NOTIF,
      page: () => const DetailNotifView(),
      binding: DetailNotifBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_RIWAYAT_TRANSAKSI,
      page: () => const DetailRiwayatTransaksiView(),
      binding: DetailRiwayatTransaksiBinding(),
    ),
    GetPage(
      name: _Paths.RIWAYAT_HUTANG,
      page: () => const RiwayatHutangView(),
      binding: RiwayatHutangBinding(),
    ),
  ];
}
