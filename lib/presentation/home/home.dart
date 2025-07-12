import 'package:flutter/material.dart';
import 'package:nile_training/presentation/home/my_requests.dart';
import 'package:nile_training/presentation/profile/profile.dart';

import '../../theme/theme_helper.dart';
import 'CategoriesPage.dart';
import 'courses_page.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {

  int currentIndex = 0;
  List<String> titles = ["Categories","Courses","Requests","Profile"];

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
          MyCoursesPage(),
          MyRequestsPage(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon( Icons.category), label: "Categories",backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.list),label: "My Courses",backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt),label: "My Requests",backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon( Icons.person), label: "Profile",backgroundColor: Colors.white)
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
