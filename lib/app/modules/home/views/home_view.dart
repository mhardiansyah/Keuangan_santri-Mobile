import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<HomeController>(HomeController());
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/icons/kardus.png'),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            if (controller.dataLogin.value == null) {
                              return Text(
                                'Loading...',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else {
                              return Text(
                                controller.dataLogin.value!.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }),
                          const SizedBox(height: 2),
                          Text(
                            'Welcome Back',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Color(0xFFD9D9D9),
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.notifications),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.only(
                      top: 20,
                      left: 25,
                      right: 25,
                      bottom: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Penjualan',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'RP. 10.000.000',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(
                          () => Text(
                            controller.cardId.value.isEmpty
                                ? 'Scan NFC untuk melihat ID Kartu'
                                : 'ID Kartu: ${controller.cardId.value}',
                          ),
                        ),
                        const SizedBox(height: 33),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 142,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  controller.nfcScan();
                                },
                                icon: Icon(Icons.details, color: Colors.white),
                                label: Text(
                                  'Scan NFC',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 142,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  controller.connectToUsbReader();
                                },
                                icon: Icon(
                                  Icons.qr_code_scanner,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Connect to USB Reader',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildInfoCard(
                          'Total Transaksi',
                          '20',
                          'assets/icons/dolars.png',
                          'Diupdate: 20 Juni 2025',
                          '+10',
                          Colors.green,
                          Color(0xffffe3c2), // Warna lingkaran oranye muda
                        ),
                        _buildInfoCard(
                          'Total Produk',
                          '12',
                          'assets/icons/kardus.png',
                          'Diupdate: 20 Juni 2025',
                          '+3',
                          Colors.green,
                          Color(0xffcdf6f4), // Warna biru muda
                        ),
                        _buildInfoCard(
                          'Total Santri',
                          '35',
                          'assets/icons/person.png',
                          'Diupdate: 20 Juni 2025',
                          '+2',
                          Colors.green,
                          Color(0xffd0f2cf), // Warna hijau muda
                        ),
                        _buildInfoCard(
                          'Total Kasbon',
                          '300K',
                          'assets/icons/kasbon.png',
                          'Diupdate: 20 Juni 2025',
                          '+10',
                          Colors.red,
                          Color(0xfffff5c3), // Warna kuning pucat
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    String iconPath,
    String updateText,
    String changeText,
    Color changeColor,
    Color circleColor,
  ) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 18, top: 18, bottom: 7),
      width: 120,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(iconPath, fit: BoxFit.contain),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: changeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  changeText,
                  style: TextStyle(
                    fontSize: 12,
                    color: changeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Divider(color: Colors.grey.shade300, thickness: 1),
          SizedBox(height: 7),
          Text(
            updateText,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
