import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/image_text_widgets/vertical_image_text.dart';
import 'package:yt_ecommerce_admin_panel/common/widgets/shimmers/category_shimmer.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/controller/brand_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/screens/brands/brand_products.dart';

class THomeBrands extends StatelessWidget {
  const THomeBrands({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final brandController = Get.put(BrandController());
    return Obx(() {
      if (brandController.isLoading.value) return const TCategoryShimmer();
      if (brandController.allBrands.isEmpty) {
        return Center(
            child: Text('No Brands Found!',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(color: Colors.white)));
      }
      return SizedBox(
        height: 85,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: brandController.allBrands.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            final brand = brandController.allBrands[index];
            return TVerticalImageText(
                image: brand.image,
                title: brand.name,
                onTap: () => Get.to(() => BrandProducts(brand: brand)));
          },
        ),
      );
    });
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:yt_ecommerce_admin_panel/common/widgets/image_text_widgets/vertical_image_text.dart';
// import 'package:yt_ecommerce_admin_panel/common/widgets/shimmers/category_shimmer.dart';
// import 'package:yt_ecommerce_admin_panel/features/shop/controller/category_controller.dart';
// import 'package:yt_ecommerce_admin_panel/features/shop/screens/sub_category/sub_category.dart';

// class THomeCategories extends StatelessWidget {
//   const THomeCategories({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final categoryController = Get.put(CategoryController());
//     return Obx(() {
//       if (categoryController.isLoading.value) return const TCategoryShimmer();
//       if (categoryController.featuredCategories.isEmpty) {
//         return Center(
//             child: Text('No Data Found!',
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyMedium!
//                     .apply(color: Colors.white)));
//       }
//       return SizedBox(
//         height: 85,
//         child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: categoryController.featuredCategories.length,
//           scrollDirection: Axis.horizontal,
//           itemBuilder: (_, index) {
//             final category = categoryController.featuredCategories[index];
//             return TVerticalImageText(
//                 image: category.image,
//                 title: category.name,
//                 onTap: () => Get.to(() => SubCategoriesScreen(category:category)));
//           },
//         ),
//       );
//     });
//   }
// }
