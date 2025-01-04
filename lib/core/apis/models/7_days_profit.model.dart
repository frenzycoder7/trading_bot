/**
 * Dummy Data
 * {
 *  "_id": "2024-09-14",
 *  "profit": 0.08909844000000228,
 *  "tc": 2
 * }
 */

class SevenDaysProfit {
  final String id;
  final double profit;
  final int tc;

  SevenDaysProfit({
    required this.id,
    required this.profit,
    required this.tc,
  });

  SevenDaysProfit.fromJson(Map<String, dynamic> json)
      : id = json["_id"],
        profit = json["profit"],
        tc = json["tc"];
}
