import 'package:flutter/material.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1E2875),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 10),
          ),
        ),
        child: CalendarDatePicker(
          initialDate: initialDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
          onDateChanged: (date) {
            // Use microtask to avoid MouseTracker conflict during event handling
            Future.microtask(() {
              onDateSelected(date);
              if (!context.mounted) return;
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            });
          },
        ),
      ),
    );
  }
}

void showCustomDatePicker({
  required BuildContext context,
  required GlobalKey anchorKey,
  required DateTime initialDate,
  required Function(DateTime) onDateSelected,
}) {
  final RenderBox? renderBox = anchorKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return;
  
  final offset = renderBox.localToGlobal(Offset.zero);
  final screenSize = MediaQuery.of(context).size;
  
  double topPos = offset.dy + renderBox.size.height + 5;
  if (topPos + 300 > screenSize.height) {
    topPos = offset.dy - 305; 
  }

  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) {
      return Stack(
        children: [
          // Invisible detector to close when clicking outside
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            left: offset.dx,
            top: topPos,
            child: Material(
              color: Colors.transparent,
              child: CustomDatePicker(
                initialDate: initialDate,
                onDateSelected: onDateSelected,
              ),
            ),
          ),
        ],
      );
    },
  );
}
