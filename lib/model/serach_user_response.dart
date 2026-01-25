class SearchUserResponse {
  final String message;
  final bool status;
  final List<StoreAndStoreUser> storeAndStoreUser;
  final List<StoreInfo> storeInfo;

  SearchUserResponse({
    required this.message,
    required this.status,
    required this.storeAndStoreUser,
    required this.storeInfo,
  });

  factory SearchUserResponse.fromJson(Map<String, dynamic> json) {
    return SearchUserResponse(
      message: json['message'] ?? '',
      status: json['status'] ?? false,
      storeAndStoreUser: (json['storeAndStoreUser'] as List? ?? [])
          .map((e) => StoreAndStoreUser.fromJson(e))
          .toList(),
      storeInfo: (json['storeInfo'] as List? ?? [])
          .map((e) => StoreInfo.fromJson(e))
          .toList(),
    );
  }
}
class StoreAndStoreUser {
  final String suUserId;
  final String userIdStoreId;
  final String storeId;
  final String updatedBy;
  final DateTime updatedDate;

  StoreAndStoreUser({
    required this.suUserId,
    required this.userIdStoreId,
    required this.storeId,
    required this.updatedBy,
    required this.updatedDate,
  });

  factory StoreAndStoreUser.fromJson(Map<String, dynamic> json) {
    return StoreAndStoreUser(
      suUserId: json['suUserId'] ?? '',
      userIdStoreId: json['userIdstoreId'] ?? '', // API key is lowercase 's'
      storeId: json['storeId'] ?? '',
      updatedBy: json['updatedBy'] ?? '',
      updatedDate: DateTime.parse(json['updatedDate']),
    );
  }
}


class StoreInfo {
  final String id;
  final String name;
  final String owner;
  final String ownerContact;
  final String ownerEmail;
  final String registrationDate;
  final String status;

  StoreInfo({
    required this.id,
    required this.name,
    required this.owner,
    required this.ownerContact,
    required this.ownerEmail,
    required this.registrationDate,
    required this.status,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    return StoreInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      owner: json['owner'] ?? '',
      ownerContact: json['ownerContact'] ?? '',
      ownerEmail: json['ownerEmail'] ?? '',
      registrationDate: json['registrationDate'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class StoreUserUIModel {
  final String suUserId;
  final String name;
  final String ownerEmail;
  final String ownerContact;
  final String status;
  final String registrationDate;

  StoreUserUIModel({
    required this.suUserId,
    required this.name,
    required this.ownerEmail,
    required this.ownerContact,
    required this.status,
    required this.registrationDate,
  });
}



