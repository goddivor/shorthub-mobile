// lib/widgets/common/search_filter_bar.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../config/theme/theme_extensions.dart';

class SearchFilterBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onSearchChanged;
  final String? filterValue;
  final List<Map<String, String>>? filterOptions;
  final ValueChanged<String?>? onFilterChanged;

  const SearchFilterBar({
    super.key,
    this.hintText = 'Rechercher...',
    required this.onSearchChanged,
    this.filterValue,
    this.filterOptions,
    this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.cardBg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: filterOptions != null ? 3 : 1,
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 13, color: context.iconSubtle),
                prefixIcon: Icon(Iconsax.search_normal, size: 18, color: context.iconSubtle),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: context.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: context.borderColor),
                ),
                filled: true,
                fillColor: context.subtleBg,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 13),
              onChanged: onSearchChanged,
            ),
          ),
          if (filterOptions != null && onFilterChanged != null) ...[
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: context.borderColor),
                  borderRadius: BorderRadius.circular(8),
                  color: context.subtleBg,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: filterValue,
                    isExpanded: true,
                    isDense: true,
                    style: TextStyle(fontSize: 12, color: context.textSecondary),
                    icon: Icon(Iconsax.arrow_down_1, size: 16, color: context.iconSubtle),
                    items: filterOptions!.map((opt) => DropdownMenuItem(
                      value: opt['value'],
                      child: Text(opt['label']!, style: const TextStyle(fontSize: 12)),
                    )).toList(),
                    onChanged: onFilterChanged,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
