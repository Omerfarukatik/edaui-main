import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_toggle_tile.dart';
import '../widgets/qr_code_modal.dart';
import 'login_screen.dart';

const platform = MethodChannel('com.ibekazi.edaui/channel');

class ChildScreen extends StatefulWidget {
  @override
  _ChildScreenState createState() => _ChildScreenState();
}

class _ChildScreenState extends State<ChildScreen> {
  // Özellikler için toggle durumları
  bool ekranHareketi = true;
  bool tarayiciGecmisi = false;
  bool konumTakibi = true;
  bool gorselAnaliz = false;
  bool duyguAnaliz = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          QrCodeModal.show(context);
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Başlık
                  Text(
                    'E D A\n(Çocuk)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman',
                      color: Colors.indigo.shade900,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Özellikler',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Özellik kartları
                  CustomToggleTile(
                    title: 'Ekran Hareketi ve Süresi',
                    value: ekranHareketi,
                    onChanged: (val) => setState(() => ekranHareketi = val),
                  ),
                  CustomToggleTile(
                    title: 'Tarayıcı Geçmişi',
                    value: tarayiciGecmisi,
                    onChanged: (val) => setState(() => tarayiciGecmisi = val),
                  ),
                  CustomToggleTile(
                    title: 'Konum Takibi',
                    value: konumTakibi,
                    onChanged: (val) => setState(() => konumTakibi = val),
                  ),
                  CustomToggleTile(
                    title: 'Görsel Analiz',
                    value: gorselAnaliz,
                    onChanged: (val) async {
                      setState(() => gorselAnaliz = val);
                      if (val) {
                        try {
                          await platform.invokeMethod('startProjection');
                        } catch (e) {
                          print("Servis başlatılamadı: $e");
                        }
                      } else {
                        try {
                          await platform.invokeMethod('stopService');
                        } catch (e) {
                          print("Servis durdurulamadı: $e");
                        }
                      }
                    },
                  ),
                  CustomToggleTile(
                    title: 'Duygu Analizi',
                    value: duyguAnaliz,
                    onChanged: (val) => setState(() => duyguAnaliz = val),
                  ),

                  Spacer(),

                  // Gizle & Durdur butonları
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await platform.invokeMethod('hideApp');
                          } catch (e) {
                            print("Uygulama gizlenemedi: $e");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        ),
                        child: Text(
                          'Gizle',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await platform.invokeMethod('stopService');
                          } catch (e) {
                            print("Servis durdurulamadı: $e");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        ),
                        child: Text(
                          'Durdur',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Çıkış Butonu (sağ üst köşe)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.logout, color: Colors.grey.shade800),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
