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
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      // ===== Body =====
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: SafeArea(
            child: Obx(() {
              final isCartEmpty = controller.cartItems.isEmpty;

              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // 🔍 Search Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            onSubmitted: (_) => controller.endSearch(),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.search, color: Colors.white),
                              hintText: 'Cari nama produk',
                              hintStyle: TextStyle(color: Colors.white54),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ===== Daftar Produk / Kosong =====
                        Expanded(
                          child: SingleChildScrollView(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              child:
                                  isCartEmpty
                                      ? Column(
                                        key: const ValueKey('empty'),
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 80),
                                          Image.asset(
                                            "assets/icons/empty-box.png",
                                            width: 180,
                                          ),
                                          const SizedBox(height: 20),
                                          const Text(
                                            'Keranjang masih kosong',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      )
                                      : Column(
                                        key: const ValueKey('cart'),
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          ...controller.cartItems.map((item) {
                                            return AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              margin: const EdgeInsets.only(
                                                bottom: 18,
                                              ),
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF1E293B),
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Gambar Produk
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    child: Image.network(
                                                      item.product.gambar,
                                                      width: 70,
                                                      height: 70,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),

                                                  // Detail Produk
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          item.product.nama,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                          formatRupiah(
                                                            item.product.harga,
                                                          ),
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.white70,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 12,
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
                                                                        12,
                                                                  ),
                                                              child: Text(
                                                                '${item.jumlah}',
                                                                style: const TextStyle(
                                                                  fontSize: 16,
                                                                  color:
                                                                      Colors
                                                                          .white,
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
                                                              isDisabled:
                                                                  item.jumlah >=
                                                                  item
                                                                      .product
                                                                      .jumlah,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // Tombol Hapus
                                                  IconButton(
                                                    onPressed:
                                                        () => controller
                                                            .removeCart(
                                                              item.product,
                                                            ),
                                                    icon: const Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.redAccent,
                                                      size: 26,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),

                                          // ===== Ringkasan Pembayaran =====
                                          Container(
                                            margin: const EdgeInsets.only(
                                              top: 12,
                                              bottom: 80,
                                            ),
                                            padding: const EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1E293B),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Ringkasan Pembayaran',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                _buildSummaryRow(
                                                  'Harga pokok',
                                                  controller.totalHargaPokok,
                                                ),
                                                _buildSummaryRow(
                                                  'Pajak',
                                                  controller.pajak,
                                                ),
                                                const Divider(
                                                  height: 24,
                                                  color: Colors.white24,
                                                ),
                                                _buildSummaryRow(
                                                  'Total Pembayaran',
                                                  controller.totalPembayaran,
                                                  bold: true,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: ElevatedButton(
                                              onPressed:
                                                  controller.cartItems.isEmpty
                                                      ? null
                                                      : () {
                                                        Get.offAllNamed(
                                                          Routes.WAITING_TAP,
                                                        );
                                                        controller
                                                            .saveDataPayment();
                                                      },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    controller.cartItems.isEmpty
                                                        ? Colors.grey
                                                        : const Color(
                                                          0xFF4F46E5,
                                                        ), // warna ungu seperti di gambar
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Text(
                                                'Checkout',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 50),
                                        ],
                                      ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ===== Overlay Hasil Pencarian =====
                  Obx(() {
                    if (controller.searchKeyword.value.isEmpty ||
                        controller.itemsList.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Positioned(
                      top: 120,
                      left: 20,
                      right: 20,
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 300),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
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
                                  width: 40,
                                  height: 40,
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
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isDisabled = false,
  }) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(25),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isDisabled ? const Color(0xFF121821) : const Color(0xFF4634CC),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildSummaryRow(String label, int value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 15,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          formatRupiah(value),
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
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
