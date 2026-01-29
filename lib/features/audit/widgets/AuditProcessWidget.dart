import 'package:flutter/material.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/constants/decorations.dart';

Widget buildSectionTitleAuditProcess(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
    child: Text(
      title,
      style: const TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  );
}

Widget buildDataTable({
  required List<String> headers,
  required List<Map<String, String>> rows,
  void Function(Map<String, String> row)? onStartAudit, // Deprecated, use onActionSelected
  void Function(String action, Map<String, String> row)? onActionSelected,
}) {
  return Container(
    width: double.infinity,
    decoration: buildTableDecoration(),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        dataRowHeight: 45,
        headingRowHeight: 45,
        columnSpacing: 20,
        horizontalMargin: 10,
        headingRowColor: MaterialStateProperty.all(tableHeaderBg),
        border: TableBorder(
          horizontalInside: BorderSide(color: borderColor.withOpacity(0.6)),
          borderRadius: BorderRadius.circular(8),
        ),
        columns: headers.map((h) => DataColumn(
            label: Text(h, style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontSize: 13),
            ),
          ),
        )
            .toList(),
        rows: rows.isEmpty
            ? [
          DataRow(
            cells: [
              DataCell(
                Text('No records found',
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic)),
              ),
              ...List.generate(headers.length - 1, (_) => const DataCell(Text(''))),
            ],
          )
        ]
            : rows.map(
              (r) => DataRow(
            cells: headers.map((key) {
              final value = r[key] ?? '';
              if (key == 'Action') {
                return DataCell(
                  SizedBox(
                    width: 120,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('Select Reasons', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                        items: ['Start Audit', 'Reschedule Audit', 'Cancel Audit'].map((String val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val, style: const TextStyle(fontSize: 11)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null && onActionSelected != null) {
                            onActionSelected(val, r);
                          } else if (val == 'Start Audit' && onStartAudit != null) {
                            onStartAudit(r);
                          }
                        },
                      ),
                    ),
                  ),
                );
              } else {
                return DataCell(
                  Text(
                    value,
                    style: const TextStyle(fontSize: 13),
                  ),
                );
              }
            }).toList(),
          ),
        ).toList(),
      ),
    ),
  );
}
