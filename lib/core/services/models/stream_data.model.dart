class StreamTicker {
  String? _e;
  int? _E;
  String? _s;
  double? _c;
  double? _o;
  double? _h;
  double? _l;
  double? _v;
  double? _q;

  String get e => _e ?? '';
  int get E => _E ?? 0;
  String get s => _s ?? '';
  double get c => _c ?? 0.0;
  double get o => _o ?? 0.0;
  double get h => _h ?? 0.0;
  double get l => _l ?? 0.0;
  double get v => _v ?? 0.0;
  double get q => _q ?? 0.0;

  StreamTicker.fromJson(Map<String, dynamic> json) {
    _e = json['e'] ?? '';
    _E = json['E'] ?? 0;
    _s = json['s'] ?? '';
    _c = parseDouble(json['c']);
    _o = parseDouble(json['o']);
    _h = parseDouble(json['h']);
    _l = parseDouble(json['l']);
    _v = parseDouble(json['v']);
    _q = parseDouble(json['q']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['e'] = _e;
    data['E'] = _E;
    data['s'] = _s;
    data['c'] = _c;
    data['o'] = _o;
    data['h'] = _h;
    data['l'] = _l;
    data['v'] = _v;
    data['q'] = _q;
    return data;
  }

  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    return value is String
        ? double.parse(value)
        : value is int
            ? value.toDouble()
            : value;
  }
}
