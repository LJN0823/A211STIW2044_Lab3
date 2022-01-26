class Order {
  String? orid;
  String? rerecid;
  String? orcusid;
  String? orpaid;
  String? ordate;

  Order(
      {required this.orid,
      required this.rerecid,
      required this.orcusid,
      required this.orpaid,
      required this.ordate});

  Order.fromJson(Map<String, dynamic> json) {
    orid = json['orid'];
    rerecid = json['rerecid'];
    orcusid = json['orcusid'];
    orpaid = json['orpaid'];
    ordate = json['ordate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orid'] = orid;
    data['prname'] = rerecid;
    data['orcusid'] = orcusid;
    data['orpaid'] = orpaid;
    data['ordate'] = ordate;
    return data;
  }
}