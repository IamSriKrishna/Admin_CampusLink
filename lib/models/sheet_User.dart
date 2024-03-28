class Sheetuser {
  static final String id = 'id';
  static final String name = 'name';
  static final String Studentclass = 'Studentclass';
  static final String from = 'from';
  static final String to = 'to';
  static final String formtype = 'formtype';
  static final String reason = 'reason';
  static final String response = 'response';

  static List<String> getField() =>
      [id, name, Studentclass, from, to, formtype, reason, response];
}

class SheetStudent {
  static int _nextId = 1; // Initialize the starting value for the auto-incrementing id

  final int id; // Change id to non-nullable since it will always have a value now
  final String name;
  final String Studentclass; // Changed to camelCase for convention
  final String from;
  final String to;
  final String formtype; // Changed to camelCase for convention
  final String reason;
  final String response;

  SheetStudent({
    required this.name,
    required this.Studentclass,
    required this.from,
    required this.to,
    required this.formtype,
    required this.reason,
    required this.response,
  }) : id = _nextId++; // Assign the next available id and increment for the next instance

  Map<String, dynamic> toJson() => {
        Sheetuser.id: id,
        Sheetuser.name: name,
        Sheetuser.Studentclass: Studentclass,
        Sheetuser.from: from,
        Sheetuser.to: to,
        Sheetuser.formtype: formtype,
        Sheetuser.reason: reason,
        Sheetuser.response: response,
      };
}
