import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CategoryItem extends Equatable {
  final String id;
  final String label;
  final String emoji;
  final Color color;
  final bool isSelected;

  const CategoryItem({
    required this.id,
    required this.label,
    required this.emoji,
    required this.color,
    this.isSelected = false,
  });

  CategoryItem copyWith({bool? isSelected}) => CategoryItem(
        id: id,
        label: label,
        emoji: emoji,
        color: color,
        isSelected: isSelected ?? this.isSelected,
      );

  @override
  List<Object?> get props => [id, isSelected];
}
