import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tribe/providers/auth_provider.dart';
import 'package:tribe/screens/feed_screen.dart';
import 'package:tribe/screens/match_suggestions_screen.dart';
import 'package:tribe/screens/chat_list_screen.dart';
import 'package:tribe/screens/notifications_screen.dart';
import 'package:tribe/screens/profile_view_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> get _screens {
    final authProvider = Provider.of<AuthProvider>(context);
    return [
      const FeedScreen(),
      const MatchSuggestionsScreen(),
      const ChatListScreen(),
      const NotificationsScreen(),
      ProfileViewScreen(userId: authProvider.user?.id ?? ''),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}