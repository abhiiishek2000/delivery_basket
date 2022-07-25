///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class SubCategoryResponseDataSubCategorySubCategoryName {
/*
{
  "id": 1,
  "sub_category_id": 2,
  "name": "English",
  "status": 1,
  "created_at": null,
  "updated_at": null,
  "deleted_at": null
}
*/

  int? id;
  int? subCategoryId;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  SubCategoryResponseDataSubCategorySubCategoryName({
    this.id,
    this.subCategoryId,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
  SubCategoryResponseDataSubCategorySubCategoryName.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toInt();
    subCategoryId = json["sub_category_id"]?.toInt();
    name = json["name"]?.toString();
    status = json["status"]?.toInt();
    createdAt = json["created_at"]?.toString();
    updatedAt = json["updated_at"]?.toString();
    deletedAt = json["deleted_at"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["sub_category_id"] = subCategoryId;
    data["name"] = name;
    data["status"] = status;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["deleted_at"] = deletedAt;
    return data;
  }
}

class SubCategoryResponseDataSubCategory {
/*
{
  "id": 2,
  "user_id": 1,
  "category_id": 1,
  "name": "Daily Vegetables",
  "image": "public/admin/sub_category/image/Veg_1.png",
  "status": true,
  "created_at": "2021-08-31T12:50:54.000000Z",
  "updated_at": "2021-09-03T11:38:02.000000Z",
  "deleted_at": null,
  "sub_category_name": {
    "id": 1,
    "sub_category_id": 2,
    "name": "English",
    "status": 1,
    "created_at": null,
    "updated_at": null,
    "deleted_at": null
  }
}
*/

  int? id;
  int? userId;
  int? categoryId;
  String? name;
  String? image;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  SubCategoryResponseDataSubCategorySubCategoryName? subCategoryName;

  SubCategoryResponseDataSubCategory({
    this.id,
    this.userId,
    this.categoryId,
    this.name,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.subCategoryName,
  });
  SubCategoryResponseDataSubCategory.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toInt();
    userId = json["user_id"]?.toInt();
    categoryId = json["category_id"]?.toInt();
    name = json["name"]?.toString();
    image = json["image"]?.toString();
    status = json["status"];
    createdAt = json["created_at"]?.toString();
    updatedAt = json["updated_at"]?.toString();
    deletedAt = json["deleted_at"]?.toString();
    subCategoryName = (json["sub_category_name"] != null) ? SubCategoryResponseDataSubCategorySubCategoryName.fromJson(json["sub_category_name"]) : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["user_id"] = userId;
    data["category_id"] = categoryId;
    data["name"] = name;
    data["image"] = image;
    data["status"] = status;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["deleted_at"] = deletedAt;
    if (subCategoryName != null) {
      data["sub_category_name"] = subCategoryName!.toJson();
    }
    return data;
  }
}

class SubCategoryResponseData {
/*
{
  "subCategory": [
    {
      "id": 2,
      "user_id": 1,
      "category_id": 1,
      "name": "Daily Vegetables",
      "image": "public/admin/sub_category/image/Veg_1.png",
      "status": true,
      "created_at": "2021-08-31T12:50:54.000000Z",
      "updated_at": "2021-09-03T11:38:02.000000Z",
      "deleted_at": null,
      "sub_category_name": {
        "id": 1,
        "sub_category_id": 2,
        "name": "English",
        "status": 1,
        "created_at": null,
        "updated_at": null,
        "deleted_at": null
      }
    }
  ]
}
*/

  List<SubCategoryResponseDataSubCategory?>? subCategory;

  SubCategoryResponseData({
    this.subCategory,
  });
  SubCategoryResponseData.fromJson(Map<String, dynamic> json) {
    if (json["subCategory"] != null) {
      final v = json["subCategory"];
      final arr0 = <SubCategoryResponseDataSubCategory>[];
      v.forEach((v) {
        arr0.add(SubCategoryResponseDataSubCategory.fromJson(v));
      });
      subCategory = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (subCategory != null) {
      final v = subCategory;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data["subCategory"] = arr0;
    }
    return data;
  }
}

class SubCategoryResponse {
/*
{
  "success": true,
  "data": {
    "subCategory": [
      {
        "id": 2,
        "user_id": 1,
        "category_id": 1,
        "name": "Daily Vegetables",
        "image": "public/admin/sub_category/image/Veg_1.png",
        "status": true,
        "created_at": "2021-08-31T12:50:54.000000Z",
        "updated_at": "2021-09-03T11:38:02.000000Z",
        "deleted_at": null,
        "sub_category_name": {
          "id": 1,
          "sub_category_id": 2,
          "name": "English",
          "status": 1,
          "created_at": null,
          "updated_at": null,
          "deleted_at": null
        }
      }
    ]
  },
  "message": "category list."
}
*/

  bool? success;
  SubCategoryResponseData? data;
  String? message;

  SubCategoryResponse({
    this.success,
    this.data,
    this.message,
  });
  SubCategoryResponse.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    data = (json["data"] != null) ? SubCategoryResponseData.fromJson(json["data"]) : null;
    message = json["message"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["success"] = success;
    if (data != null) {
      data["data"] = this.data!.toJson();
    }
    data["message"] = message;
    return data;
  }
}