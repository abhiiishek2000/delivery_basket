///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class CategoryResponseDataCategoryCategoryName {
/*
{
  "id": 1,
  "category_id": 1,
  "name": "Fresh Vegetable In Hindi",
  "status": 1,
  "created_at": "2021-10-06T06:26:40.000000Z",
  "updated_at": "2021-10-06T06:26:40.000000Z",
  "deleted_at": null
}
*/

  int? id;
  int? categoryId;
  String? name;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  CategoryResponseDataCategoryCategoryName({
    this.id,
    this.categoryId,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });
  CategoryResponseDataCategoryCategoryName.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toInt();
    categoryId = json["category_id"]?.toInt();
    name = json["name"]?.toString();
    status = json["status"]?.toInt();
    createdAt = json["created_at"]?.toString();
    updatedAt = json["updated_at"]?.toString();
    deletedAt = json["deleted_at"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["category_id"] = categoryId;
    data["name"] = name;
    data["status"] = status;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["deleted_at"] = deletedAt;
    return data;
  }
}

class CategoryResponseDataCategory {
/*
{
  "id": 1,
  "user_id": 1,
  "name": "Fresh Vegetable",
  "image": "public/admin/home/category/Vegetable-catagery.jpg",
  "status": true,
  "created_at": "2021-08-31T12:39:56.000000Z",
  "updated_at": "2021-09-03T11:16:55.000000Z",
  "deleted_at": null,
  "category_name": {
    "id": 1,
    "category_id": 1,
    "name": "Fresh Vegetable In Hindi",
    "status": 1,
    "created_at": "2021-10-06T06:26:40.000000Z",
    "updated_at": "2021-10-06T06:26:40.000000Z",
    "deleted_at": null
  }
}
*/

  int? id;
  int? userId;
  String? name;
  String? image;
  bool? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  CategoryResponseDataCategoryCategoryName? categoryName;

  CategoryResponseDataCategory({
    this.id,
    this.userId,
    this.name,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.categoryName,
  });
  CategoryResponseDataCategory.fromJson(Map<String, dynamic> json) {
    id = json["id"]?.toInt();
    userId = json["user_id"]?.toInt();
    name = json["name"]?.toString();
    image = json["image"]?.toString();
    status = json["status"];
    createdAt = json["created_at"]?.toString();
    updatedAt = json["updated_at"]?.toString();
    deletedAt = json["deleted_at"]?.toString();
    categoryName = (json["category_name"] != null) ? CategoryResponseDataCategoryCategoryName.fromJson(json["category_name"]) : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["user_id"] = userId;
    data["name"] = name;
    data["image"] = image;
    data["status"] = status;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["deleted_at"] = deletedAt;
    if (categoryName != null) {
      data["category_name"] = categoryName!.toJson();
    }
    return data;
  }
}

class CategoryResponseData {
/*
{
  "category": [
    {
      "id": 1,
      "user_id": 1,
      "name": "Fresh Vegetable",
      "image": "public/admin/home/category/Vegetable-catagery.jpg",
      "status": true,
      "created_at": "2021-08-31T12:39:56.000000Z",
      "updated_at": "2021-09-03T11:16:55.000000Z",
      "deleted_at": null,
      "category_name": {
        "id": 1,
        "category_id": 1,
        "name": "Fresh Vegetable In Hindi",
        "status": 1,
        "created_at": "2021-10-06T06:26:40.000000Z",
        "updated_at": "2021-10-06T06:26:40.000000Z",
        "deleted_at": null
      }
    }
  ]
}
*/

  List<CategoryResponseDataCategory?>? category;

  CategoryResponseData({
    this.category,
  });
  CategoryResponseData.fromJson(Map<String, dynamic> json) {
    if (json["category"] != null) {
      final v = json["category"];
      final arr0 = <CategoryResponseDataCategory>[];
      v.forEach((v) {
        arr0.add(CategoryResponseDataCategory.fromJson(v));
      });
      category = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (category != null) {
      final v = category;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data["category"] = arr0;
    }
    return data;
  }
}

class CategoryResponse {
/*
{
  "success": true,
  "data": {
    "category": [
      {
        "id": 1,
        "user_id": 1,
        "name": "Fresh Vegetable",
        "image": "public/admin/home/category/Vegetable-catagery.jpg",
        "status": true,
        "created_at": "2021-08-31T12:39:56.000000Z",
        "updated_at": "2021-09-03T11:16:55.000000Z",
        "deleted_at": null,
        "category_name": {
          "id": 1,
          "category_id": 1,
          "name": "Fresh Vegetable In Hindi",
          "status": 1,
          "created_at": "2021-10-06T06:26:40.000000Z",
          "updated_at": "2021-10-06T06:26:40.000000Z",
          "deleted_at": null
        }
      }
    ]
  },
  "message": "category list."
}
*/

  bool? success;
  CategoryResponseData? data;
  String? message;

  CategoryResponse({
    this.success,
    this.data,
    this.message,
  });
  CategoryResponse.fromJson(Map<String, dynamic> json) {
    success = json["success"];
    data = (json["data"] != null) ? CategoryResponseData.fromJson(json["data"]) : null;
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
