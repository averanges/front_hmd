import 'package:haimdall/src/domain/model/farmland/farmland.dart';

class FarmlandListResponse {
  final List<Farmland> farmlandList;

  FarmlandListResponse({
    required this.farmlandList,
  });

  factory FarmlandListResponse.fromJson(Map<String, dynamic> json) {
    return FarmlandListResponse(
      farmlandList: List<Farmland>.from(
        json['farmland_list'].map(
          (e) => Farmland.fromJson(e),
        ),
      ),
    );
  }
}
