class WardMasterModel {
  int? iWardId;
  String? cWardDesc;

  WardMasterModel({this.iWardId, this.cWardDesc});

  WardMasterModel.fromJson(Map<String, dynamic> json) {
    iWardId = json['iWard_id'];
    cWardDesc = json['cWard_Desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iWard_id'] = this.iWardId;
    data['cWard_Desc'] = this.cWardDesc;
    return data;
  }
}
