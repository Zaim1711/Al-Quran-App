import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_cli/app/constants/color.dart';

class BottomNavBar extends StatelessWidget {
  final RxInt currentIndex;
  final void Function(int) onTap;

  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      height: 100,
      child: Stack(
        children: [
          Positioned(
            left: -20,
            right: -25,
            top: 30,
            child: Container(
              width: 390,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 0.50,
                  color: Colors.black.withOpacity(0.28999999165534973),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, -4),
                    spreadRadius: 0,
                  ),
                ],
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          Positioned(
            left: 159,
            top: 5,
            child: Container(
              width: 88,
              height: 57,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, -4),
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
          _buildNavItem(Icons.menu_book, 'SURAH', 185, 13, 0),
          _buildNavItem(Icons.home, 'HOME', 70, 40, 2),
          _buildNavItem(Icons.person, 'PROFIL', 300, 40, 1),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      IconData iconData, String label, double left, double top, int index) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () => onTap(index),
        onTapDown: (_) {
          currentIndex.value = index;
        },
        child: Container(
          width: 35,
          height: 31,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Obx(() => Icon(
                iconData,
                color: currentIndex.value == index
                    ? appOrange
                    : const Color(0xFFA4A4A4),
                size: 30,
              )),
        ),
      ),
    );
  }
}
