import 'package:flutter/material.dart';

class AppBottomSheetSelector<T> extends StatelessWidget {
  final String title;
  final List<SelectorOption<T>> options;
  final T? selectedValue;

  const AppBottomSheetSelector({
    super.key,
    required this.title,
    required this.options,
    this.selectedValue,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<SelectorOption<T>> options,
    T? selectedValue,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => AppBottomSheetSelector<T>(
        title: title,
        options: options,
        selectedValue: selectedValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...options.map(
              (option) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(option.label),
                trailing: option.value == selectedValue
                    ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                    : null,
                onTap: () => Navigator.of(context).pop(option.value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectorOption<T> {
  final String label;
  final T value;

  const SelectorOption({required this.label, required this.value});
}
