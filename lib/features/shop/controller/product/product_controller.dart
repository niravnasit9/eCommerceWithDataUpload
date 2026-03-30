import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/data/repositories/product/product_repository.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/product_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:yt_ecommerce_admin_panel/utils/popups/loaders.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final isLoading = false.obs;
  final isLoadingRelated = false.obs;
  final productRepository = Get.put(ProductRepository());
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  RxList<ProductModel> relatedProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    fetchFeaturedProducts();
    super.onInit();
  }

  /// Fetch featured products
  void fetchFeaturedProducts() async {
    try {
      isLoading.value = true;
      final products = await productRepository.getFeaturedProducts();
      featuredProducts.assignAll(products);
      print('✅ Featured Products Loaded: ${products.length}');
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print('❌ Error fetching featured products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch related products for a specific product
  Future<void> fetchRelatedProducts({
    required String currentProductId,
    required String categoryId,
    required String brandId,
  }) async {
    try {
      print('🔄 Fetching related products for: $currentProductId');
      print('📂 Category ID: $categoryId');
      print('🏷️ Brand ID: $brandId');
      
      isLoadingRelated.value = true;
      
      List<ProductModel> related = [];
      
      // Fetch all products first
      final allProducts = await productRepository.getAllProducts();
      print('📦 Total products available: ${allProducts.length}');
      
      // Filter related products (same category or brand, exclude current)
      for (var product in allProducts) {
        if (product.id != currentProductId) {
          if (product.categoryId == categoryId || product.brand.id == brandId) {
            related.add(product);
            print('✅ Added product: ${product.title} (Category: ${product.categoryId}, Brand: ${product.brand.id})');
          }
        }
      }
      
      print('🎯 Found ${related.length} related products');
      
      // Limit to 8 products
      if (related.length > 8) {
        related = related.take(8).toList();
      }
      
      // Shuffle to show different products each time
      related.shuffle();
      
      relatedProducts.assignAll(related);
      print('✅ Related products updated: ${relatedProducts.length}');
      
      isLoadingRelated.value = false;
    } catch (e) {
      isLoadingRelated.value = false;
      print('❌ Error fetching related products: $e');
      relatedProducts.clear();
    }
  }

  /// Fetch all featured products
  Future<List<ProductModel>> fetchAllFeaturedProducts() async {
    try {
      final products = await productRepository.getFeaturedProducts();
      return products;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  /// Get the product price or price range for variations.
  String getProductPrice(ProductModel product) {
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;

    if (product.productType == ProductType.single.toString()) {
      return (product.salePrice > 0 ? product.salePrice : product.price)
          .toString();
    } else {
      if (product.productVariations != null) {
        for (var variation in product.productVariations!) {
          double priceToConsider =
              variation.salePrice > 0.0 ? variation.salePrice : variation.price;
          if (priceToConsider < smallestPrice) {
            smallestPrice = priceToConsider;
          }
          if (priceToConsider > largestPrice) {
            largestPrice = priceToConsider;
          }
        }
      }
      if (largestPrice == largestPrice) {
        return "₹${largestPrice.toStringAsFixed(0)}";
      } else {
        return '₹${smallestPrice.toStringAsFixed(0)} - ₹${largestPrice.toStringAsFixed(0)}';
      }
    }
  }

  /// Calculate Discount Percentage
  String? calculateSalePercentage(double originalPrice, double? salePrice) {
    if (salePrice == null || salePrice <= 0.0) return null;
    if (originalPrice <= 0) return null;

    double percentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return percentage.toStringAsFixed(0);
  }

  /// Check Product Stock Status
  String getProductStockStatus(int stock) {
    return stock > 0 ? 'In Stock' : 'Out of Stock';
  }

  /// Get the sale price for a product
  double getSalePrice(ProductModel product) {
    if (product.salePrice > 0) {
      return product.salePrice;
    }
    
    if (product.productVariations != null && product.productVariations!.isNotEmpty) {
      double smallestSalePrice = double.infinity;
      for (var variation in product.productVariations!) {
        if (variation.salePrice > 0 && variation.salePrice < smallestSalePrice) {
          smallestSalePrice = variation.salePrice;
        }
      }
      if (smallestSalePrice != double.infinity) {
        return smallestSalePrice;
      }
    }
    
    return product.price;
  }

  /// Get the regular price for a product
  double getRegularPrice(ProductModel product) {
    if (product.productVariations != null && product.productVariations!.isNotEmpty) {
      double smallestPrice = double.infinity;
      for (var variation in product.productVariations!) {
        if (variation.price < smallestPrice) {
          smallestPrice = variation.price;
        }
      }
      if (smallestPrice != double.infinity) {
        return smallestPrice;
      }
    }
    return product.price;
  }
}