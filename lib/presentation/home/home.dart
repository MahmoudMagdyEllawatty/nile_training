import 'package:flutter/material.dart';
import 'package:nile_training/presentation/profile/profile.dart';

import '../../theme/theme_helper.dart';
import 'CategoriesPage.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {

  int currentIndex = 0;
  List<String> titles = ["Categories","Profile"];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(titles[currentIndex],style: theme.textTheme.titleLarge!.copyWith(height: 1.60),),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: [
          CategoriesPage(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon( Icons.category), label: "Categories"),
          BottomNavigationBarItem(icon: Icon( Icons.person), label: "Profile")
        ],
        onTap: (index){
          setState(() {
            currentIndex = index;
          });
        },
      ),

    );
  }
}
