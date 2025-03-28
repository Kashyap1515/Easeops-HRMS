import 'package:easeops_web_hrms/app_export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:universal_html/html.dart';

Future<void> generateExcel({
  required String fileName,
  required List<ExcelDataRow> dataRows,
}) async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];
  final Style style = workbook.styles.add('Style1');
  style.hAlign = HAlignType.center;
  style.vAlign = VAlignType.center;
  style.wrapText = true;
  style.bold = true;
  final Style style1 = workbook.styles.add('Style2');
  style1.hAlign = HAlignType.center;
  style1.vAlign = VAlignType.center;
  style1.wrapText = true;

  sheet.getRangeByName('A1:Z1').cellStyle = style;
  sheet.getRangeByName('A1:Z1').columnWidth = 25;
  sheet.importData(dataRows, 1, 1);
  sheet.getRangeByName('A2:Z110').cellStyle = style1;
  sheet.getRangeByName('A2:Z110').columnWidth = 25;
  List<int> bytes = workbook.saveAsStream();
  storeToFileStorage(fileName: fileName, bytes: bytes);
  workbook.dispose();
}

Future<void> generateDashboardExcel({
  required String fileName,
  required List<ExcelDataRow> headerDataRows,
  required List<ExcelDataRow> dataRows,
}) async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];
  final Style style = workbook.styles.add('Style1');
  style.hAlign = HAlignType.center;
  style.vAlign = VAlignType.center;
  style.wrapText = true;
  style.bold = true;
  final Style style1 = workbook.styles.add('Style2');
  style1.hAlign = HAlignType.center;
  style1.vAlign = VAlignType.center;
  style1.wrapText = true;
  sheet.importData(headerDataRows, 1, 1);
  sheet.getRangeByName('A4:D4').merge();
  sheet.getRangeByName('F4:H4').merge();
  sheet.getRangeByName('J4:K4').merge();
  sheet.getRangeByName('M4:O4').merge();
  sheet.getRangeByName('A3:Z4').cellStyle = style;
  sheet.getRangeByName('A5:Z8').cellStyle = style1;
  sheet.importData(dataRows, 7, 1);
  sheet.getRangeByName('A9:Z110').cellStyle = style1;
  List<int> bytes = workbook.saveAsStream();
  storeToFileStorage(fileName: fileName, bytes: bytes);
  workbook.dispose();
}

void storeToFileStorage({required String fileName, required List<int> bytes}) {
  final blob = Blob([bytes], 'application/octet-stream');
  final anchor = AnchorElement(
    href: Url.createObjectUrlFromBlob(blob),
  )
    ..setAttribute("download", fileName)
    ..click();
  Url.revokeObjectUrl(anchor.href!);
}
