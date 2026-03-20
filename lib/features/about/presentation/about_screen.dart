import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/brand_app_bar_title.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const BrandAppBarTitle(
          compact: true,
          subtitle: AppStrings.about,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppLogo(
                  size: 34,
                  padding: const EdgeInsets.all(8),
                  backgroundColor: scheme.primaryContainer.withValues(alpha: 0.34),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    AppStrings.appTitle,
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.aboutBody,
              style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                leading: AppLogo(
                  size: 20,
                  padding: const EdgeInsets.all(5),
                  backgroundColor: scheme.secondaryContainer.withValues(alpha: 0.34),
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
