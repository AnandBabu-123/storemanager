

class StoreDetailsModel {
  String? message;
  bool? status;
  List<Stores> stores;
  int? currentPage;
  int? pageSize;
  int? totalElements;
  int? totalPages;

  StoreDetailsModel({
    this.message,
    this.status,
    required this.stores,
    this.currentPage,
    this.pageSize,
    this.totalElements,
    this.totalPages,
  });

  factory StoreDetailsModel.fromJson(Map<String, dynamic> json) {
    return StoreDetailsModel(
      message: json['message'],
      status: json['status'],
      stores: (json['stores'] as List? ?? [])
          .map((e) => Stores.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: json['currentPage'],
      pageSize: json['pageSize'],
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'stores': stores.map((e) => e.toJson()).toList(),
      'currentPage': currentPage,
      'pageSize': pageSize,
      'totalElements': totalElements,
      'totalPages': totalPages,
    };
  }
}


class Stores {
  String? type;
  String? userIdStoreId;
  String? id;
  String? name;
  String? pincode;
  String? district;
  String? state;
  String? location;
  String? owner;
  String? ownerContact;
  String? secondaryContact;
  String? ownerEmail;
  String? registrationDate;
  String? creationTimeStamp;
  String? role;
  String? addedBy;
  String? modifiedBy;
  String? modifiedDate;
  String? modifiedTimeStamp;
  String? status;
  bool? storeVerifiedStatus;
  String? expiryDate;
  String? currentPlan;
  String? storeBusinessType;
  String? userId;
  String? gstNumber;

  Stores({
    this.type,
    this.userIdStoreId,
    this.id,
    this.name,
    this.pincode,
    this.district,
    this.state,
    this.location,
    this.owner,
    this.ownerContact,
    this.secondaryContact,
    this.ownerEmail,
    this.registrationDate,
    this.creationTimeStamp,
    this.role,
    this.addedBy,
    this.modifiedBy,
    this.modifiedDate,
    this.modifiedTimeStamp,
    this.status,
    this.storeVerifiedStatus,
    this.expiryDate,
    this.currentPlan,
    this.storeBusinessType,
    this.userId,
    this.gstNumber,
  });

  factory Stores.fromJson(Map<String, dynamic> json) {
    return Stores(
      type: json['type'],
      userIdStoreId: json['userIdStoreId'],
      id: json['id'],
      name: json['name'],
      pincode: json['pincode'],
      district: json['district'],
      state: json['state'],
      location: json['location'],
      owner: json['owner'],
      ownerContact: json['ownerContact'],
      secondaryContact: json['secondaryContact'],
      ownerEmail: json['ownerEmail'],
      registrationDate: json['registrationDate'],
      creationTimeStamp: json['creationTimeStamp'],
      role: json['role'],
      addedBy: json['addedBy'],
      modifiedBy: json['modifiedBy'],
      modifiedDate: json['modifiedDate'],
      modifiedTimeStamp: json['modifiedTimeStamp'],
      status: json['status'],
      storeVerifiedStatus: _parseBool(json['storeVerifiedStatus']),
      expiryDate: json['expiryDate'], // stays null if null
      currentPlan: json['currentPlan'],
      storeBusinessType: json['storeBusinessType'],
      userId: json['userId'],
      gstNumber: json['gstNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'userIdStoreId': userIdStoreId,
      'id': id,
      'name': name,
      'pincode': pincode,
      'district': district,
      'state': state,
      'location': location,
      'owner': owner,
      'ownerContact': ownerContact,
      'secondaryContact': secondaryContact,
      'ownerEmail': ownerEmail,
      'registrationDate': registrationDate,
      'creationTimeStamp': creationTimeStamp,
      'role': role,
      'addedBy': addedBy,
      'modifiedBy': modifiedBy,
      'modifiedDate': modifiedDate,
      'modifiedTimeStamp': modifiedTimeStamp,
      'status': status,
      'storeVerifiedStatus': storeVerifiedStatus,
      'expiryDate': expiryDate,
      'currentPlan': currentPlan,
      'storeBusinessType': storeBusinessType,
      'userId': userId,
      'gstNumber': gstNumber,
    };
  }

  /// Handles "true" / "false" / true / false / null
  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return null;
  }
}

