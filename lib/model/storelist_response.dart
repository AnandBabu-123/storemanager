class StoreListResponse {
  final String message;
  final bool status;
  final List<StoreItem> stores;
  final int currentPage;
  final int pageSize;
  final int totalElements;
  final int totalPages;

  StoreListResponse({
    required this.message,
    required this.status,
    required this.stores,
    required this.currentPage,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
  });

  factory StoreListResponse.fromJson(Map<String, dynamic> json) {
    return StoreListResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? false,
      stores: (json['stores'] as List<dynamic>)
          .map((e) => StoreItem.fromJson(e))
          .toList(),
      currentPage: json['currentPage'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}

class StoreItem {
  final String id;
  final String name;
  final String userIdStoreId;
  final String pincode;
  final String district;
  final String state;
  final String location;
  final String owner;
  final String ownerContact;
  final String secondaryContact;
  final String ownerEmail;
  final String gstNumber;
  final String? status;              // ACTIVE / INACTIVE / null
  final String storeVerifiedStatus;  // true / false
  final String storeBusinessType;    // RT / DT / PC / PH
  final String type;                 // PH / DC / PC etc

  StoreItem({
    required this.id,
    required this.name,
    required this.userIdStoreId,
    required this.pincode,
    required this.district,
    required this.state,
    required this.location,
    required this.owner,
    required this.ownerContact,
    required this.secondaryContact,
    required this.ownerEmail,
    required this.gstNumber,
    this.status,  // make nullable
    required this.storeVerifiedStatus,
    required this.storeBusinessType,
    required this.type,
  });

  factory StoreItem.fromJson(Map<String, dynamic> json) {
    return StoreItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      userIdStoreId: json['userIdStoreId']?.toString() ?? '',

      pincode: json['pincode']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      location: json['location']?.toString() ?? '',

      owner: json['owner']?.toString() ?? '',
      ownerContact: json['ownerContact']?.toString() ?? '',
      secondaryContact: json['secondaryContact']?.toString() ?? '',
      ownerEmail: json['ownerEmail']?.toString() ?? '',

      gstNumber: json['gstNumber']?.toString() ?? '',

      status: json['status']?.toString(),  // keep null if API returns null

      storeVerifiedStatus: json['storeVerifiedStatus']?.toString() ?? 'false',
      storeBusinessType: json['storeBusinessType']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }
}



class StoreCategoryItem {
  final String storeCategoryId;
  final String storeCategoryName;

  StoreCategoryItem({
    required this.storeCategoryId,
    required this.storeCategoryName,
  });

  factory StoreCategoryItem.fromJson(Map<String, dynamic> json) {
    return StoreCategoryItem(
      storeCategoryId: json['storeCategoryId'] ?? '',
      storeCategoryName: json['storeCategoryName'] ?? '',
    );
  }
}


