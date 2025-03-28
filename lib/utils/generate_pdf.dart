import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart';

import 'package:easeops_web_hrms/app_export.dart';

Future<void> generatePDF({
  required String fileName,
  required List<List<String>> data,
  String? heading,
  String? heading1,
}) async {
  final pdf = pw.Document();

  // Load Noto Serif Old Uyghur font
  final customFont = pw.Font.ttf(await rootBundle
      .load('assets/fonts/NotoSansDevanagari-VariableFont_wdth,wght.ttf'));

  bool useLandscape = false;

  // Determine if the table needs to be in landscape based on the content size
  for (List<String> row in data) {
    for (String cell in row) {
      if (cell.length > 20) {
        useLandscape = true;
        break;
      }
    }
    if (useLandscape) break;
  }

  // Adjust the number of rows per page based on orientation
  const int portraitItemsPerPage = 20;
  const int landscapeItemsPerPage = 10;
  int itemsPerPage =
      useLandscape ? landscapeItemsPerPage : portraitItemsPerPage;

  int totalPages = (data.length / itemsPerPage).ceil();

  for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
    int startIndex = pageIndex * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    if (endIndex > data.length) endIndex = data.length;

    pdf.addPage(
      pw.Page(
        pageFormat:
            useLandscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              if (pageIndex == 0) ...[
                pw.Align(
                  alignment: pw.Alignment.center,
                  child: pw.Text(heading ?? '',
                      style: pw.TextStyle(fontSize: 15, font: customFont)),
                ),
                if (heading1 != null) ...[
                  pw.SizedBox(height: 5),
                  pw.Text(heading1,
                      style: pw.TextStyle(fontSize: 15, font: customFont)),
                ],
                pw.SizedBox(height: 20),
              ],
              // Creating the table manually to specify font for each cell
              pw.Table(
                border: pw.TableBorder.all(),
                children: data.sublist(startIndex, endIndex).map((row) {
                  return pw.TableRow(
                    children: row.map((cell) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(cell,
                            style: pw.TextStyle(font: customFont)),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Footer(title: pw.Text('Page ${pageIndex + 1} of $totalPages')),
            ],
          );
        },
      ),
    );
  }

  List<int> bytes = await pdf.save();
  storeToPDFFileStorage(fileName: fileName, bytes: bytes);
}

void storeToPDFFileStorage({
  required String fileName,
  required List<int> bytes,
}) {
  final blob = Blob([bytes], 'application/pdf');
  final anchor = AnchorElement(
    href: Url.createObjectUrlFromBlob(blob),
  )
    ..setAttribute("download", fileName)
    ..click();
  Url.revokeObjectUrl(anchor.href!);
}
