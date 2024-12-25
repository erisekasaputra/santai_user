import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';

class CustomPagination extends StatelessWidget {
  final int pageNumber;
  final int pageSize;
  final int pageCount;
  final Function(int) onPageChanged;

  const CustomPagination({
    super.key,
    required this.pageNumber,
    required this.pageSize,
    required this.pageCount,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: NumberPaginator(
        numberPages: pageCount,
        onPageChange: (page) {
          onPageChanged(page + 1);
        },
        initialPage: pageNumber -
            1, // Because `pageNumber` starts from 1, but NumberPaginator uses 0-based index
        config: NumberPaginatorUIConfig(
          buttonSelectedForegroundColor:
              Colors.blue, // Color for the selected page number
          buttonUnselectedForegroundColor:
              Colors.grey, // Color for unselected page numbers
          buttonUnselectedBackgroundColor: Colors.transparent,
          buttonSelectedBackgroundColor: Colors.blue.withOpacity(0.3),
        ),
      ),
    );
  }
}
