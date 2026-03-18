import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.about)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.appTitle, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text(AppStrings.aboutBody, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.auto_stories_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text(AppStrings.appTitle),
                subtitle: const Text('Flutter • Firebase • Riverpod • Material 3'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
