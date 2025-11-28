import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/home/home_header.dart';
import '../../widgets/home/home_empty_state.dart';
import '../../widgets/home/home_add_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: const HomeAddButton(),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Column(
            children: [
              HomeHeader(),
              SizedBox(height: 110),
              HomeEmptyState(),
            ],
          ),
        ),
      ),
    );
  }
}
