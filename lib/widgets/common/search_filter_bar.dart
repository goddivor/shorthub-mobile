// lib/widgets/common/search_filter_bar.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/theme_extensions.dart';

class SearchFilterBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onSearchChanged;
  final String? filterValue;
  final List<Map<String, String>>? filterOptions;
  final ValueChanged<String?>? onFilterChanged;

  const SearchFilterBar({
    super.key,
    this.hintText = 'Search...',
    required this.onSearchChanged,
    this.filterValue,
    this.filterOptions,
    this.onFilterChanged,
  });

  @override
  State<SearchFilterBar> createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  bool _searchExpanded = false;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _collapseSearch() {
    setState(() {
      _searchExpanded = false;
      _searchController.clear();
      _searchFocusNode.unfocus();
    });
    widget.onSearchChanged('');
  }

  void _expandSearch() {
    setState(() => _searchExpanded = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      _searchFocusNode.requestFocus();
    });
  }

  void _showFilterBottomSheet() {
    if (widget.filterOptions == null || widget.onFilterChanged == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                ...widget.filterOptions!.map((opt) {
                  final isSelected = widget.filterValue == opt['value'];
                  return ListTile(
                    leading: Icon(
                      isSelected ? Iconsax.tick_circle : Iconsax.record,
                      color: isSelected ? AppColors.primary : context.iconSubtle,
                      size: 20,
                    ),
                    title: Text(
                      opt['label']!,
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : context.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      widget.onFilterChanged!(opt['value']);
                      Navigator.pop(context);
                    },
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasFilter = widget.filterOptions != null;
    final hasActiveFilter = hasFilter && widget.filterValue != null && widget.filterValue != 'ALL';
    // Find the label of current filter
    String? filterLabel;
    if (hasFilter && widget.filterValue != null) {
      final match = widget.filterOptions!.where((o) => o['value'] == widget.filterValue);
      if (match.isNotEmpty) filterLabel = match.first['label'];
    }

    return Container(
      color: context.cardBg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Search button / expanded search
          if (_searchExpanded)
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: context.subtleBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: context.borderColor),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(Iconsax.search_normal, size: 18, color: context.textTertiary),
                    const SizedBox(width: 8),
                    Container(width: 1, height: 20, color: context.borderColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        style: TextStyle(fontSize: 14, color: context.textPrimary),
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: TextStyle(fontSize: 13, color: context.textHint),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: widget.onSearchChanged,
                      ),
                    ),
                    GestureDetector(
                      onTap: _collapseSearch,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(Icons.close, size: 18, color: context.textTertiary),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Collapsed search pill
            Container(
              width: 56,
              height: 44,
              decoration: BoxDecoration(
                color: context.subtleBg,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: _expandSearch,
                  child: Center(
                    child: Icon(Iconsax.search_normal, size: 20, color: context.textSecondary),
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],

          if (hasFilter) ...[
            const SizedBox(width: 12),
            // Filter pill
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                onTap: _showFilterBottomSheet,
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: context.subtleBg,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            PhosphorIcons.funnel(PhosphorIconsStyle.bold),
                            size: 18,
                            color: hasActiveFilter ? AppColors.primary : context.textSecondary,
                          ),
                          if (hasActiveFilter)
                            Positioned(
                              top: -2,
                              right: -4,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (filterLabel != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          filterLabel,
                          style: TextStyle(
                            fontSize: 13,
                            color: hasActiveFilter ? AppColors.primary : context.textSecondary,
                            fontWeight: hasActiveFilter ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                      const SizedBox(width: 4),
                      Icon(
                        Iconsax.arrow_down_1,
                        size: 14,
                        color: hasActiveFilter ? AppColors.primary : context.textTertiary,
                      ),
                    ],
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
