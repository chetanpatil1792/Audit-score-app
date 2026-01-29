

// class RegionResponse {
//   final List<Region> result;

//   RegionResponse({required this.result});

//   factory RegionResponse.fromJson(Map<String, dynamic> json) {
//     return RegionResponse(
//       result: (json['result'] as List)
//           .map((item) => Region.fromJson(item))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'result': result.map((region) => region.toJson()).toList(),
//     };
//   }
// }

// class Region {
//   final int id;
//   final String regionId;
//   final String regionName;
//   final String regionManagerName;
//   final String zoneId;
//   final String clusterId;
//   final String address;
//   final String countryId;
//   final String stateId;
//   final String districtId;
//   final String talukaId;
//   final String villageId;
//   final String pincode;

//   Region({
//     required this.id,
//     required this.regionId,
//     required this.regionName,
//     required this.regionManagerName,
//     required this.zoneId,
//     required this.clusterId,
//     required this.address,
//     required this.countryId,
//     required this.stateId,
//     required this.districtId,
//     required this.talukaId,
//     required this.villageId,
//     required this.pincode,
//   });

//   factory Region.fromJson(Map<String, dynamic> json) {
//     return Region(
//       id: json['id'],
//       regionId: json['regionId'],
//       regionName: json['regionName'],
//       regionManagerName: json['regionManagerName'],
//       zoneId: json['zoneId'],
//       clusterId: json['clusterId'],
//       address: json['address'],
//       countryId: json['countryId'],
//       stateId: json['stateId'],
//       districtId: json['districtId'],
//       talukaId: json['talukaId'],
//       villageId: json['villageId'],
//       pincode: json['pincode'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'regionId': regionId,
//       'regionName': regionName,
//       'regionManagerName': regionManagerName,
//       'zoneId': zoneId,
//       'clusterId': clusterId,
//       'address': address,
//       'countryId': countryId,
//       'stateId': stateId,
//       'districtId': districtId,
//       'talukaId': talukaId,
//       'villageId': villageId,
//       'pincode': pincode,
//     };
//   }
// }


class RegionResponse {
  final List<Region> result;

  RegionResponse({required this.result});

  factory RegionResponse.fromJson(Map<String, dynamic> json) {
    return RegionResponse(
      result: (json['result'] as List)
          .map((item) => Region.fromJson(item))
          .toList(),
    );
  }
}

class Region {
  final int id;
  final String regionId;
  final String regionName;

  Region({
    required this.id,
    required this.regionId,
    required this.regionName,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'],
      regionId: json['regionId'],
      regionName: json['regionName'],
    );
  }
}
