import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/note_provider.dart';
import '../../widgets/home/home_header.dart';
import '../../widgets/home/home_empty_state.dart';
import '../../widgets/home/home_add_button.dart';
import '../../widgets/common/app_background.dart';
import '../../widgets/home/home_note_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    final pinnedNotes = notes.where((e) => e.isPinned).toList();
    final normalNotes = notes.where((e) => !e.isPinned).toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: const HomeAddButton(),
        body: Stack(
          children: [
            const AppBackground(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;


                    int crossAxisCount() {
                      if (width >= 1500) return 6;
                      if (width >= 1100) return 5;
                      if (width >= 900) return 4;
                      if (width >= 650) return 3;
                      return 2;
                    }

                    double aspectRatio() {
                      if (width >= 1500) return 1.05;
                      if (width >= 1100) return 0.97;
                      if (width >= 900) return 0.93;
                      if (width >= 650) return 0.88;
                      return 0.80;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HomeHeader(),
                        const SizedBox(height: 20),

                        if (notes.isEmpty)
                          const Expanded(child: HomeEmptyState())
                        else
                          Expanded(
                            child: SingleChildScrollView(
                              keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (pinnedNotes.isNotEmpty) ...[
                                    Row(
                                      children: const [
                                        Icon(Icons.push_pin_rounded,
                                            color: Colors.white, size: 22),
                                        SizedBox(width: 8),
                                        Text(
                                          "Pinned",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: pinnedNotes.length,
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount(),
                                        crossAxisSpacing: 14,
                                        mainAxisSpacing: 14,
                                        childAspectRatio: aspectRatio(),
                                      ),
                                      itemBuilder: (_, i) =>
                                          HomeNoteCard(note: pinnedNotes[i]),
                                    ),
                                    const SizedBox(height: 30),
                                  ],


                                  Row(
                                    children: const [
                                      Icon(Icons.notes_rounded,
                                          color: Colors.white, size: 22),
                                      SizedBox(width: 8),
                                      Text(
                                        "Notes",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: normalNotes.length,
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount(),
                                      crossAxisSpacing: 14,
                                      mainAxisSpacing: 14,
                                      childAspectRatio: aspectRatio(),
                                    ),
                                    itemBuilder: (_, i) =>
                                        HomeNoteCard(note: normalNotes[i]),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        const SizedBox(height: 8),

                        Center(
                          child: Text(
                            "Dedicated to my sister, Nibina ❤️",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
