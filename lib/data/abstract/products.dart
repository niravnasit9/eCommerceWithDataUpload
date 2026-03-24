import 'package:yt_ecommerce_admin_panel/features/shop/models/brand_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/product_attribute_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/product_model.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/product_variation_model.dart';

final List<ProductModel> dummyProducts = [
  /// ------------------ OnePlus 11R 5G ------------------
  ProductModel(
    id: 'prod_oneplus_11r',
    title: 'OnePlus 11R 5G',
    stock: 50,
    price: 699.99,
    salePrice: 649.99,
    thumbnail: 'assets/images/products/Oneplus-11R-5g-2.png',
    productType: 'Mobile',
    images: [
      'assets/images/products/Oneplus-11R-5g-2.png',
      'assets/images/products/Oneplus-11R-5g-1.png',
    ],
    brand: BrandModel(
      id: 'brand_oneplus',
      name: 'OnePlus',
      image: '',
      isFeatured: true,
      productsCount: 50,
    ),
    categoryId: 'cat_mobile',
    description:
        'OnePlus 11R 5G: High-performance phone with AMOLED display and fast charging.',
    isFeatured: true,
    productAttributes: [
      ProductAttributeModel(name: 'Color', values: ['Black', 'Green']),
      ProductAttributeModel(name: 'Storage', values: ['128GB', '256GB']),
    ],
    productVariations: [
      ProductVariationModel(
        id: 'var_oneplus_11r_black_128',
        sku: 'OP11R-B-128',
        image: 'assets/images/products/Oneplus-11R-5g-2.png',
        price: 699.99,
        salePrice: 649.99,
        stock: 25,
        attributeValues: {'Color': 'Black', 'Storage': '128GB'},
      ),
      ProductVariationModel(
        id: 'var_oneplus_11r_green_256',
        sku: 'OP11R-G-256',
        image: 'assets/images/products/Oneplus-11R-5g-1.png',
        price: 749.99,
        salePrice: 699.99,
        stock: 25,
        attributeValues: {'Color': 'Green', 'Storage': '256GB'},
      ),
    ],
  ),

  /// ------------------ Realme 11 5G ------------------
  ProductModel(
    id: 'prod_realme_11',
    title: 'Realme 11 5G',
    stock: 45,
    price: 499.99,
    salePrice: 449.99,
    thumbnail: 'assets/images/products/Realme-11-5g.png',
    productType: 'Mobile',
    images: [
      'assets/images/products/Realme-11-5g.png',
      'assets/images/products/Realme-11-5g-1.png',
      'assets/images/products/Realme-11-5g-2.png',
    ],
    brand: BrandModel(
      id: 'brand_realme',
      name: 'Realme',
      image: '',
      isFeatured: true,
      productsCount: 45,
    ),
    categoryId: 'cat_mobile',
    description:
        'Realme 11 5G: Affordable phone with sleek design and powerful performance.',
    isFeatured: true,
    productAttributes: [
      ProductAttributeModel(name: 'Color', values: ['Black', 'Silver', 'Blue']),
      ProductAttributeModel(name: 'Storage', values: ['64GB', '128GB']),
    ],
  ),

  /// ------------------ Samsung S23 Ultra ------------------
  ProductModel(
    id: 'prod_samsung_s23ultra',
    title: 'Samsung S23 Ultra',
    stock: 60,
    price: 1199.99,
    salePrice: 1149.99,
    thumbnail: 'assets/images/products/samsung s23 ultra.png',
    productType: 'Mobile',
    images: [
      'assets/images/products/samsung s23 ultra.png',
      'assets/images/products/samsung s23 ultra1.png',
      'assets/images/products/samsung s23 ultra3.png',
    ],
    brand: BrandModel(
      id: 'brand_samsung',
      name: 'Samsung',
      image: '',
      isFeatured: true,
      productsCount: 60,
    ),
    categoryId: 'cat_mobile',
    description:
        'Samsung S23 Ultra: Flagship smartphone with top camera and performance.',
    isFeatured: true,
    productAttributes: [
      ProductAttributeModel(name: 'Color', values: ['Black', 'Silver']),
      ProductAttributeModel(name: 'Storage', values: ['256GB', '512GB']),
    ],
    productVariations: [
      ProductVariationModel(
        id: 'var_s23ultra_black_256',
        sku: 'S23U-B-256',
        image: 'assets/images/products/samsung s23 ultra.png',
        price: 1199.99,
        salePrice: 1149.99,
        stock: 30,
        attributeValues: {'Color': 'Black', 'Storage': '256GB'},
      ),
      ProductVariationModel(
        id: 'var_s23ultra_silver_512',
        sku: 'S23U-S-512',
        image: 'assets/images/products/samsung s23 ultra1.png',
        price: 1299.99,
        salePrice: 1249.99,
        stock: 30,
        attributeValues: {'Color': 'Silver', 'Storage': '512GB'},
      ),
    ],
  ),

  /// ------------------ Samsung Galaxy S9 ------------------
  ProductModel(
    id: 'prod_samsung_s9',
    title: 'Samsung Galaxy S9',
    stock: 35,
    price: 499.99,
    salePrice: 449.99,
    thumbnail: 'assets/images/products/samsung_s9_mobile.png',
    productType: 'Mobile',
    images: [
      'assets/images/products/samsung_s9_mobile.png',
      'assets/images/products/samsung_s9_mobile_back.png',
      'assets/images/products/samsung_s9_mobile_withback.png',
    ],
    brand: BrandModel(
      id: 'brand_samsung',
      name: 'Samsung',
      image: '',
      isFeatured: true,
      productsCount: 35,
    ),
    categoryId: 'cat_mobile',
    description:
        'Samsung Galaxy S9: Sleek design, powerful performance, high-quality display.',
    isFeatured: true,
    productAttributes: [
      ProductAttributeModel(name: 'Color', values: ['Black', 'Blue']),
      ProductAttributeModel(name: 'Storage', values: ['64GB', '128GB']),
    ],
    productVariations: [
      ProductVariationModel(
        id: 'var_samsung_s9_black_64',
        sku: 'S9-B-64',
        image: 'assets/images/products/samsung_s9_mobile.png',
        price: 499.99,
        salePrice: 449.99,
        stock: 20,
        attributeValues: {'Color': 'Black', 'Storage': '64GB'},
      ),
      ProductVariationModel(
        id: 'var_samsung_s9_black_128',
        sku: 'S9-B-128',
        image: 'assets/images/products/samsung_s9_mobile_back.png',
        price: 549.99,
        salePrice: 499.99,
        stock: 15,
        attributeValues: {'Color': 'Black', 'Storage': '128GB'},
      ),
    ],
  ),

  /// ------------------ Vivo V29 5G ------------------
  ProductModel(
    id: 'prod_vivo_v29',
    title: 'Vivo V29 5G',
    stock: 50,
    price: 599.99,
    salePrice: 549.99,
    thumbnail: 'assets/images/products/v29-5g.png',
    productType: 'Mobile',
    images: [
      'assets/images/products/v29-5g.png',
      'assets/images/products/v29-5g-1.png',
      'assets/images/products/v29-5g-2.png',
    ],
    brand: BrandModel(
      id: 'brand_vivo',
      name: 'Vivo',
      image: '',
      isFeatured: true,
      productsCount: 50,
    ),
    categoryId: 'cat_mobile',
    description:
        'Vivo V29 5G: Slim design with high refresh rate AMOLED display.',
    isFeatured: true,
    productAttributes: [
      ProductAttributeModel(name: 'Color', values: ['Black', 'Silver', 'Gold']),
      ProductAttributeModel(name: 'Storage', values: ['128GB', '256GB']),
    ],
    productVariations: [
      ProductVariationModel(
        id: 'var_v29_black_128',
        sku: 'V29-B-128',
        image: 'assets/images/products/v29-5g.png',
        price: 599.99,
        salePrice: 549.99,
        stock: 25,
        attributeValues: {'Color': 'Black', 'Storage': '128GB'},
      ),
      ProductVariationModel(
        id: 'var_v29_silver_256',
        sku: 'V29-S-256',
        image: 'assets/images/products/v29-5g-1.png',
        price: 649.99,
        salePrice: 599.99,
        stock: 25,
        attributeValues: {'Color': 'Silver', 'Storage': '256GB'},
      ),
    ],
  ),

  /// ------------------ Vivo V27 ------------------
  ProductModel(
    id: 'prod_vivo_v27',
    title: 'Vivo V27',
    stock: 40,
    price: 499.99,
    salePrice: 449.99,
    thumbnail: 'assets/images/products/vivo-V27.png',
    productType: 'Mobile',
    images: [
      'assets/images/products/vivo-V27.png',
      'assets/images/products/vivo-V27-2.png',
      'assets/images/products/vivo-V27-3.png',
    ],
    brand: BrandModel(
      id: 'brand_vivo',
      name: 'Vivo',
      image: '',
      isFeatured: true,
      productsCount: 40,
    ),
    categoryId: 'cat_mobile',
    description:
        'Vivo V27: Premium mid-range smartphone with excellent camera.',
    isFeatured: true,
    productAttributes: [
      ProductAttributeModel(name: 'Color', values: ['Black', 'Gold']),
      ProductAttributeModel(name: 'Storage', values: ['128GB', '256GB']),
    ],
  ),

  /// ------------------ Xiaomi 11x 5G ------------------
  ProductModel(
    id: 'prod_xiaomi_11x',
    title: 'Xiaomi 11x 5G',
    stock: 35,
    price: 399.99,
    salePrice: 349.99,
    thumbnail: 'assets/images/products/11x-5g.png',
    productType: 'Mobile',
    images: [
      'assets/images/products/11x-5g.png',
      'assets/images/products/11x-5g1.png',
      'assets/images/products/11x-5g2.png',
    ],
    brand: BrandModel(
      id: 'brand_xiaomi',
      name: 'Xiaomi',
      image: '',
      isFeatured: true,
      productsCount: 35,
    ),
    categoryId: 'cat_mobile',
    description: 'Xiaomi 11x 5G: Compact design with strong performance.',
    isFeatured: true,
    productAttributes: [
      ProductAttributeModel(name: 'Color', values: ['Black', 'Silver']),
      ProductAttributeModel(name: 'Storage', values: ['64GB', '128GB']),
    ],
  ),

  /// ------------------ Xiaomi 12 Pro ------------------
  ProductModel(
    id: 'prod_xiaomi_12pro',
    title: 'Xiaomi 12 Pro',
    stock: 30,
    price: 599.99,
    salePrice: 549.99,
    thumbnail: 'assets/images/products/12pro.jpeg',
    productType: 'Mobile',
    images: [
      'assets/images/products/12pro.jpeg',
      'assets/images/products/12pro-2.jpeg',
      'assets/images/products/12pro(!).jpeg',
    ],
    brand: BrandModel(
      id: 'brand_xiaomi',
      name: 'Xiaomi',
      image: '',
      isFeatured: true,
      productsCount: 30,
    ),
    categoryId: 'cat_mobile',
    description:
        'Xiaomi 12 Pro: Flagship-grade smartphone with high-end performance.',
    isFeatured: true,
    productAttributes: [
      ProductAttributeModel(name: 'Color', values: ['Blue', 'Silver']),
      ProductAttributeModel(name: 'Storage', values: ['128GB', '256GB']),
    ],
  ),

  /// ------------------ Galaxy Z Flip 3 5G ------------------
  ProductModel(
    id: 'prod_galaxy_z_flip3',
    title: 'Galaxy Z Flip 3 5G',
    stock: 25,
    price: 899.99,
    salePrice: 849.99,
    thumbnail: 'assets/images/products/galaxy-z-flip3-5g.png',
    productType: 'Mobile',
    images: [
      'assets/images/products/galaxy-z-flip3-5g.png',
      'assets/images/products/galaxy-z-flip3-5g1.png',
      'assets/images/products/galaxy-z-flip32.png',
    ],
    brand: BrandModel(
      id: 'brand_samsung',
      name: 'Samsung',
      image: '',
      isFeatured: true,
      productsCount: 25,
    ),
    categoryId: 'cat_mobile',
    description:
        'Galaxy Z Flip 3 5G: Innovative foldable smartphone with premium design.',
    isFeatured: true,
  ),

  /// ------------------ iPhone 15 ------------------
  ProductModel(
    id: 'prod_iphone15',
    title: 'iPhone 15',
    stock: 50,
    price: 1099.99,
    salePrice: 1049.99,
    thumbnail: 'assets/images/products/Iphone.15.png',
    productType: 'Mobile',
    images: [
      'assets/images/products/Iphone.15.png',
      'assets/images/products/Iphone.15_1_.png',
      'assets/images/products/Iphone_2_.png',
    ],
    brand: BrandModel(
      id: 'brand_apple',
      name: 'Apple',
      image: '',
      isFeatured: true,
      productsCount: 50,
    ),
    categoryId: 'cat_mobile',
    description:
        'iPhone 15: Latest Apple phone with advanced camera and iOS features.',
    isFeatured: true,
  ),

  /// ------------------ iPhone 12 ------------------
  ProductModel(
    id: 'prod_iphone12',
    title: 'iPhone 12',
    stock: 50,
    price: 699.99,
    salePrice: 649.99,
    thumbnail: 'assets/images/products/iphone_12_black.png',
    productType: 'Mobile',
    images: [
      'assets/images/products/iphone_12_black.png',
      'assets/images/products/iphone_12_blue.png',
      'assets/images/products/iphone_12_green.png',
      'assets/images/products/iphone_12_red.png',
    ],
    brand: BrandModel(
      id: 'brand_apple',
      name: 'Apple',
      image: '',
      isFeatured: true,
      productsCount: 50,
    ),
    categoryId: 'cat_mobile',
    description:
        'iPhone 12: Advanced smartphone with powerful camera and performance.',
    isFeatured: true,
    productAttributes: [
      ProductAttributeModel(
          name: 'Color', values: ['Black', 'Blue', 'Green', 'Red']),
      ProductAttributeModel(
          name: 'Storage', values: ['64GB', '128GB', '256GB']),
    ],
    productVariations: [
      ProductVariationModel(
        id: 'var_iphone12_black_64',
        sku: 'I12-B-64',
        image: 'assets/images/products/iphone_12_black.png',
        price: 699.99,
        salePrice: 649.99,
        stock: 20,
        attributeValues: {'Color': 'Black', 'Storage': '64GB'},
      ),
    ],
  ),

  /// ------------------ iPhone 13 Pro ------------------
  ProductModel(
    id: 'prod_iphone13',
    title: 'iPhone 13 Pro',
    stock: 45,
    price: 999.99,
    salePrice: 949.99,
    thumbnail: 'assets/images/products/iphone_13_pro.png',
    productType: 'Mobile',
    images: [
      'assets/images/products/iphone_13_pro.png',
    ],
    brand: BrandModel(
      id: 'brand_apple',
      name: 'Apple',
      image: '',
      isFeatured: true,
      productsCount: 45,
    ),
    categoryId: 'cat_mobile',
    description:
        'iPhone 13 Pro: High-end smartphone with professional-grade camera.',
    isFeatured: true,
  ),

  /// ------------------ iPhone 14 Pro ------------------
  ProductModel(
    id: 'prod_iphone14',
    title: 'iPhone 14 Pro',
    stock: 55,
    price: 1099.99,
    salePrice: 1049.99,
    thumbnail: 'assets/images/products/iphone_14_pro.png',
    productType: 'Mobile',
    images: [
      'assets/images/products/iphone_14_pro.png',
      'assets/images/products/iphone_14_white.png',
    ],
    brand: BrandModel(
      id: 'brand_apple',
      name: 'Apple',
      image: '',
      isFeatured: true,
      productsCount: 55,
    ),
    categoryId: 'cat_mobile',
    description:
        'iPhone 14 Pro: Flagship Apple phone with superior performance.',
    isFeatured: true,
  ),

  /// ------------------ iPhone 15 Pro Max ------------------
  ProductModel(
    id: 'prod_iphone15_pro_max',
    title: 'iPhone 15 Pro Max',
    stock: 30,
    price: 1299.99,
    salePrice: 1249.99,
    thumbnail: 'assets/images/products/Iphone-15-pro-max.png',
    productType: 'Mobile',
    images: [
      'assets/images/products/Iphone-15-pro-max.png',
      'assets/images/products/Iphone-15-pro-max1.png',
      'assets/images/products/Iphone-15-pro-max2.png',
    ],
    brand: BrandModel(
      id: 'brand_apple',
      name: 'Apple',
      image: '',
      isFeatured: true,
      productsCount: 30,
    ),
    categoryId: 'cat_mobile',
    description:
        'iPhone 15 Pro Max: Apple’s ultimate phone with top camera and performance.',
    isFeatured: true,
  ),

  /// ------------------ Nord CE 3 Lite 5G ------------------
  ProductModel(
    id: 'prod_nord_ce3_lite',
    title: 'Nord CE 3 Lite 5G',
    stock: 40,
    price: 299.99,
    salePrice: 249.99,
    thumbnail: 'assets/images/products/nord-ce-3-lite-5g.png',
    productType: 'Mobile',
    images: [
      'assets/images/products/nord-ce-3-lite-5g.png',
      'assets/images/products/nord-ce-3-lite-5g1.png',
      'assets/images/products/nord-ce-3-lite-5g2.png',
    ],
    brand: BrandModel(
      id: 'brand_oneplus',
      name: 'OnePlus',
      image: '',
      isFeatured: true,
      productsCount: 40,
    ),
    categoryId: 'cat_mobile',
    description:
        'Nord CE 3 Lite 5G: Budget-friendly 5G phone with long battery life.',
    isFeatured: true,
  ),
];
