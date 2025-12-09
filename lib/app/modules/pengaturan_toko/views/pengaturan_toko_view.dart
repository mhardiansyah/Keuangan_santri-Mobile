import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/pengaturan_toko_controller.dart';

class PengaturanTokoView extends GetView<PengaturanTokoController> {
  const PengaturanTokoView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PengaturanTokoController());
    return Scaffold(
      backgroundColor: const Color(0xFF0E1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1220),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Pengaturan Toko',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4634CC)),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.amber, size: 30),
            onPressed: controller.openAddDialog,
          ),
        ],
      ),
      body: Obx(() {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.fetchKategori();
                await controller.fetchProduct();
              },
              backgroundColor: Colors.white,
              color: Colors.amber,
              child: Column(
                children: [
                  // 🔍 Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 46,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        onChanged: (val) {
                          controller.searchKeyword.value = val;
                          controller.filterProducts();
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey),
                          hintText: 'Masukkan nama produk',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),

                  // 🛒 Grid Produk
                  Expanded(
                    child:
                        controller.isLoading.value
                            ? GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 250,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    childAspectRatio: 0.7,
                                  ),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade800,
                                  highlightColor: Colors.grey.shade600,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade800,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              },
                            )
                            : controller.itemsList.isEmpty
                            ? const Center(
                              child: Text(
                                "Tidak ada hasil",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                            : GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 250,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                    childAspectRatio: 0.7,
                                  ),
                              itemCount: controller.itemsList.length,
                              itemBuilder: (context, index) {
                                final product = controller.itemsList[index];
                                final restockData = controller
                                    .getRestockHistory(product.id);
                                final plusBadge =
                                    restockData != null
                                        ? restockData['jumlah']
                                        : 0;

                                return Stack(
                                  children: [
                                    Opacity(
                                      opacity: product.jumlah == 0 ? 0.5 : 1.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1E293B),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Foto
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.vertical(
                                                        top: Radius.circular(
                                                          12,
                                                        ),
                                                      ),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      product.gambar ??
                                                          "https://via.placeholder.com/150",
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            // Nama, stok, harga
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product.nama,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),

                                                  // stok + badge
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Stok: ${product.jumlah}",
                                                        style: TextStyle(
                                                          color:
                                                              product.jumlah ==
                                                                      0
                                                                  ? Colors.grey
                                                                  : product
                                                                          .jumlah <=
                                                                      10
                                                                  ? Colors.red
                                                                  : product
                                                                          .jumlah <=
                                                                      20
                                                                  ? Colors
                                                                      .orange
                                                                  : Colors
                                                                      .green,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      if (plusBadge > 0) ...[
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 6,
                                                                vertical: 2,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Colors
                                                                .greenAccent
                                                                .withOpacity(
                                                                  0.2,
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          child: Text(
                                                            "+$plusBadge",
                                                            style: const TextStyle(
                                                              color:
                                                                  Colors
                                                                      .greenAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 11,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),

                                                  const SizedBox(height: 4),
                                                  Text(
                                                    formatRupiah(product.harga),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    if (product.jumlah == 0)
                                      const Positioned.fill(
                                        child: Center(
                                          child: Text(
                                            "Stock Habis",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                            ),
                                          ),
                                        ),
                                      ),

                                    // tombol edit
                                    Positioned(
                                      right: 8,
                                      bottom: 8,
                                      child: GestureDetector(
                                        onTap:
                                            () => controller.openEditDialog(
                                              product,
                                            ),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Colors.amber,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // 💰 Format Rupiah
  String formatRupiah(int amount) => NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  ).format(amount);

  // 🦴 Shimmer Loading
  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: 6,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade800,
          highlightColor: Colors.grey.shade600,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: 80,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 10,
                        width: 50,
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 12,
                        width: 60,
                        color: Colors.grey.shade700,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
