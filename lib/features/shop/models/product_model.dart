import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/brand_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/product_attribute_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/product_variation_model.dart';

class ProductModel {
  String id;
  String title;
  int stock;
  double price;
  double salePrice;

  String thumbnail;
  List<String>? images;

  String productType;
  String categoryId;

  /// NEW AMAZON TYPE DATA
  String shortDescription;
  String fullDescription;
  List<String> highlights;
  Map<String, String> specifications;

  bool isFeatured;

  /// DATE
  DateTime? createdAt;
  DateTime? updatedAt;

  BrandModel brand;

  List<ProductAttributeModel>? productAttributes;
  List<ProductVariationModel>? productVariations;

  ProductModel({
    required this.id,
    required this.title,
    required this.stock,
    required this.price,
    required this.salePrice,
    required this.thumbnail,
    this.images,
    required this.productType,
    required this.categoryId,
    this.shortDescription = '',
    this.fullDescription = '',
    this.highlights = const [],
    this.specifications = const {},
    required this.brand,
    this.productAttributes,
    this.productVariations,
    this.isFeatured = false,
    this.createdAt,
    this.updatedAt,
  });

  /// EMPTY
  static ProductModel empty() => ProductModel(
        id: '',
        title: '',
        stock: 0,
        price: 0,
        salePrice: 0,
        thumbnail: '',
        images: [],
        productType: '',
        categoryId: '',
        brand: BrandModel.empty(),
        shortDescription: '',
        fullDescription: '',
        highlights: [],
        specifications: {},
        productAttributes: [],
        productVariations: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Title': title,
      'Stock': stock,
      'Price': price,
      'SalePrice': salePrice,
      'Thumbnail': thumbnail,
      'Images': images,
      'ProductType': productType,
      'CategoryId': categoryId,

      'ShortDescription': shortDescription,
      'FullDescription': fullDescription,
      'Highlights': highlights,
      'Specifications': specifications,

      'IsFeatured': isFeatured,

      /// ✅ FIXED DATE
      'CreatedAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),

      'UpdatedAt': FieldValue.serverTimestamp(),

      'Brand': brand.toJson(),
      'ProductAttributes': productAttributes?.map((e) => e.toJson()).toList(),
      'ProductVariations': productVariations?.map((e) => e.toJson()).toList(),
    };
  }

  /// FROM FIREBASE
  factory ProductModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ProductModel(
      id: data['Id'] ?? '',
      title: data['Title'] ?? '',
      stock: data['Stock'] ?? 0,
      price: double.parse((data['Price'] ?? 0).toString()),
      salePrice: double.parse((data['SalePrice'] ?? 0).toString()),
      thumbnail: data['Thumbnail'] ?? '',
      images: List<String>.from(data['Images'] ?? []),
      productType: data['ProductType'] ?? '',
      categoryId: data['CategoryId'] ?? '',
      shortDescription: data['ShortDescription'] ?? '',
      fullDescription: data['FullDescription'] ?? '',
      highlights: List<String>.from(data['Highlights'] ?? []),
      specifications: Map<String, String>.from(data['Specifications'] ?? {}),
      isFeatured: data['IsFeatured'] ?? false,
      createdAt: data['CreatedAt'] != null
          ? (data['CreatedAt'] as Timestamp).toDate()
          : null,
      updatedAt: data['UpdatedAt'] != null
          ? (data['UpdatedAt'] as Timestamp).toDate()
          : null,
      brand: BrandModel.fromJson(data['Brand']),
      productAttributes: data['ProductAttributes'] != null
          ? (data['ProductAttributes'] as List)
              .map((e) => ProductAttributeModel.fromJson(e))
              .toList()
          : [],
      productVariations: data['ProductVariations'] != null
          ? (data['ProductVariations'] as List)
              .map((e) => ProductVariationModel.fromJson(e))
              .toList()
          : [],
    );
  }
}
