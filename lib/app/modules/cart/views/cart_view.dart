import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sakusantri/app/routes/app_pages.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CartController());

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
      ),

      bottomNavigationBar: Obx(() {
        final isCartEmpty = controller.cartItems.isEmpty;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18),
          color: const Color(0xFF0F172A),
          child: SizedBox(
            width: 100,
            height: 54,
            child: ElevatedButton(
              onPressed: isCartEmpty ? null : () => controller.goToWaitingTap(),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isCartEmpty ? Colors.grey : const Color(0xFF4F46E5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                disabledBackgroundColor: Colors.grey,
                elevation: 0,
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }),

      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Obx(() {
              final isCartEmpty = controller.cartItems.isEmpty;

              return KeyboardListener(
                focusNode: controller.focusNode,
                autofocus: true,
                onKeyEvent: controller.onKeyEvent,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                      ), // 🔼 Lebih luas
                      child: Column(
                        children: [
                          const SizedBox(height: 24),

                          // 🔍 Search Bar
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              height: 46,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextField(
                                controller: controller.searchController,
                                onChanged: (value) {
                                  controller.searchKeyword.value = value;
                                  controller.filterProducts();
                                },
                                onSubmitted: (_) {
                                  controller.endSearch();
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(Icons.search, color: Colors.white),
                                  hintText: 'Masukkan nama produk',
                                  hintStyle: TextStyle(color: Colors.white54),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          Expanded(
                            child: SingleChildScrollView(
                              child:
                                  isCartEmpty
                                      ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 100),
                                          Image.asset(
                                            "assets/icons/empty-box.png",
                                            width:
                                                220, // 🔼 Sedikit lebih besar
                                          ),
                                          const SizedBox(height: 30),
                                          const Text(
                                            'Keranjang masih kosong',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                      : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ...controller.cartItems.map((item) {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 22,
                                              ),
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF1E293B),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    child: Image.network(
                                                      item.product.gambar,
                                                      width: 90,
                                                      height: 90,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),

                                                  // 🧾 Detail produk
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              item.product.nama,
                                                              style: const TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontSize:
                                                                    18, // 🔼 lebih besar
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            IconButton(
                                                              onPressed:
                                                                  () => controller
                                                                      .removeCart(
                                                                        item.product,
                                                                      ),
                                                              icon: const Icon(
                                                                Icons
                                                                    .delete_outline_rounded,
                                                                color:
                                                                    Colors
                                                                        .redAccent,
                                                                size: 24,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                          formatRupiah(
                                                            item.product.harga,
                                                          ),
                                                          style: const TextStyle(
                                                            color:
                                                                Colors.white70,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 14,
                                                        ),
                                                        Row(
                                                          children: [
                                                            _buildQtyButton(
                                                              icon:
                                                                  Icons.remove,
                                                              onTap:
                                                                  () => controller
                                                                      .decjumlah(
                                                                        item,
                                                                      ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        16,
                                                                  ),
                                                              child: Text(
                                                                '${item.jumlah}',
                                                                style: const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  fontSize: 17,
                                                                ),
                                                              ),
                                                            ),
                                                            _buildQtyButton(
                                                              icon: Icons.add,
                                                              onTap:
                                                                  () => controller
                                                                      .incjumlah(
                                                                        item,
                                                                      ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),

                                          // 💰 Ringkasan Pembayaran
                                          Container(
                                            margin: const EdgeInsets.only(
                                              top: 20,
                                            ),
                                            padding: const EdgeInsets.all(24),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1E293B),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Ringkasan Pembayaran',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                _buildSummaryRow(
                                                  'Harga pokok:',
                                                  controller.totalHargaPokok,
                                                ),
                                                _buildSummaryRow(
                                                  'Pajak:',
                                                  controller.pajak,
                                                ),
                                                const Divider(
                                                  color: Colors.white24,
                                                  height: 28,
                                                ),
                                                _buildSummaryRow(
                                                  'Total Harga:',
                                                  controller.totalPembayaran,
                                                  bold: true,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 100),
                                        ],
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🔍 Overlay hasil pencarian
                    Obx(() {
                      if (controller.searchKeyword.value.isEmpty ||
                          controller.itemsList.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Positioned(
                        top: 110,
                        left: 40,
                        right: 40,
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 350),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.itemsList.length,
                            itemBuilder: (context, index) {
                              final item = controller.itemsList[index];
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    item.gambar,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  item.nama,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  formatRupiah(item.harga),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                                onTap: () {
                                  if (item.jumlah == 0) {
                                    Get.snackbar(
                                      "Produk Habis",
                                      "${item.nama} sudah tidak tersedia",
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  controller.addCart(item);
                                  controller.searchController.clear();
                                  controller.endSearch();

                                  Get.snackbar(
                                    "Ditambahkan",
                                    "${item.nama} masuk ke keranjang",
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // 🔘 Tombol tambah/kurang qty
  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          color: Color(0xFF4F46E5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  // 💰 Ringkasan baris
  Widget _buildSummaryRow(String label, int value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          formatRupiah(value),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  String formatRupiah(int amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }
}
