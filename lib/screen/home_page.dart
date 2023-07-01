import 'package:flutter/material.dart';
import 'package:identity_preserving_dapp/screen/check_accounts.dart';
import 'package:identity_preserving_dapp/screen/save_identity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey actionKey = GlobalKey();
  int selectedIndex = 0;
  List<Widget> screens = <Widget>[
    const SaveUserIdentity(),
    const CheckUserAccounts(),
  ];

  void _onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Save ID',
            icon: Icon(Icons.save_alt_outlined),
          ),
          BottomNavigationBarItem(
            label: 'View Account',
            icon: Icon(Icons.grid_view),
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.green,
        selectedLabelStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        elevation: 12,
        showUnselectedLabels: true,
        onTap: _onTapped,
      ),
    );
  }

  Rect getWidgetBounds(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    return offset & renderBox.size;
  }
}
