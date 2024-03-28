import 'package:admin/models/sheet_User.dart';
import 'package:admin/uri.dart';
import 'package:gsheets/gsheets.dart';

class GatePassUserSheetApi {
  static const _credentialsJson = credentialsJson;

  static final _spreadsheetId = spreedSheetApi;
  static final _gsheet = GSheets(_credentialsJson);
  static Worksheet? _userSheet;
  static Future gatepassinit() async {
    try {
      final spreadsheet = await _gsheet.spreadsheet(_spreadsheetId);
      _userSheet = await _getWorkSheet(spreadsheet, title: "Gatepass");

      final firsRow = Sheetuser.getField();
      _userSheet!.values.insertRow(1, firsRow);
    } catch (e) {
      print('init Error $e');
    }
  }

  static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet,
      {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (_userSheet == null) return;

    _userSheet!.values.map.appendRows(rowList);
  }
}
