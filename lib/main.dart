import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainTabPage(),
    );
  }
}

class MainTabPage extends StatefulWidget {
  const MainTabPage({super.key});

  @override
  State<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends State<MainTabPage> {
  int _selectedIndex = 0;

  // รายชื่อหน้าจอทั้ง 3 Tabs
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(), // Tab 1: หน้าแรก/ข่าวสาร
    ITStorePage(), // Tab 2: ดึงข้อมูลจาก Vercel (Assignment 9)
    ContactPage(), // Tab 3: ข้อมูลส่วนตัว ภัทรพล
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'IT Store'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Contact'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

// --- Tab 1: Home Page ---
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IT News Update')),
      body: Center(
        child: Column(
          children: [
            Image.network(
                'https://images.unsplash.com/photo-1518770660439-4636190af475?w=500',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('ยินดีต้อนรับสู่โลกแห่งนวัตกรรม IT ล่าสุดประจำวัน',
                  style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Tab 2: IT Store (ดึงข้อมูลจาก API Vercel) ---
class ITStorePage extends StatefulWidget {
  const ITStorePage({super.key});

  @override
  State<ITStorePage> createState() => _ITStorePageState();
}

class _ITStorePageState extends State<ITStorePage> {
  List _items = [];
  bool _isLoading = true;

  Future<void> fetchAttractions() async {
    try {
      final response = await http
          .get(Uri.parse('https://api01attraction-eta.vercel.app/attractions'));
      if (response.statusCode == 200) {
        setState(() {
          _items = json.decode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAttractions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IT Gadgets Store')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Image.network(_items[index]['coverimage'],
                        width: 60, height: 60, fit: BoxFit.cover),
                    title: Text(_items[index]['name']),
                    subtitle: Text(_items[index]['detail'], maxLines: 1),
                    onTap: () {
                      // คลิกดูรายละเอียดได้
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(_items[index]['name']),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(_items[index]['coverimage']),
                              const SizedBox(height: 10),
                              Text(_items[index]['detail']),
                            ],
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('ปิด'))
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

// --- Tab 3: Contact Us (ข้อมูลภัทรพล) ---
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                  'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'), // รูปโปรไฟล์ตัวอย่าง
            ),
            const SizedBox(height: 20),
            const Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('ชื่อ-นามสกุล'),
                subtitle: Text('ภัทรพล ขจิตสุวรรณ'),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.badge),
                title: Text('รหัสศึกษา'),
                subtitle: Text('6703952'),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.email),
                title: Text('ช่องทางติดต่อ'),
                subtitle: Text('pattharaphon.k67@rsu.ac.th'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
