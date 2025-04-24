import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchOptionChip extends StatelessWidget {
  final String label;
  final String selectedLabel;
  final void Function(String) onSelected;

  const SearchOptionChip({
    super.key,
    required this.label,
    required this.selectedLabel,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedLabel == label;
    return GestureDetector(
      onTap: () => onSelected(label),
      child: Container(
        margin: EdgeInsets.only(right: 4.w),
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xffb4914b) : Colors.white,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xffb4914b) : Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
