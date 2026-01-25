class RetailerStoreDropdown {
  String? id;
  String? name;
  bool? storeVerifiedStatus;

  RetailerStoreDropdown({
    this.id,
    this.name,
    this.storeVerifiedStatus,
  });

  RetailerStoreDropdown.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    storeVerifiedStatus =
        json['storeVerifiedStatus']?.toString() == "true";
  }

  String get displayName => "$id - $name";
}
