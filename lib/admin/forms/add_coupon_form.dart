import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:yt_ecommerce_admin_panel/admin/controllers/admin_coupon_controller.dart';
import 'package:yt_ecommerce_admin_panel/features/shop/models/coupon_model.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/sizes.dart';

class AddCouponForm extends StatefulWidget {
  const AddCouponForm({super.key, this.coupon});
  final CouponModel? coupon;

  @override
  State<AddCouponForm> createState() => _AddCouponFormState();
}

class _AddCouponFormState extends State<AddCouponForm> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _discountValueController = TextEditingController();
  final _minOrderController = TextEditingController();
  final _maxDiscountController = TextEditingController();
  final _usageLimitController = TextEditingController();
  
  String _discountType = 'percentage';
  DateTime _validFrom = DateTime.now();
  DateTime _validTo = DateTime.now().add(const Duration(days: 30));
  bool _isActive = true;
  
  final controller = Get.find<AdminCouponController>();

  @override
  void initState() {
    super.initState();
    if (widget.coupon != null) {
      _codeController.text = widget.coupon!.code;
      _descriptionController.text = widget.coupon!.description;
      _discountType = widget.coupon!.discountType;
      _discountValueController.text = widget.coupon!.discountValue.toString();
      _minOrderController.text = widget.coupon!.minimumOrderAmount?.toString() ?? '';
      _maxDiscountController.text = widget.coupon!.maximumDiscount?.toString() ?? '';
      _usageLimitController.text = widget.coupon!.usageLimit.toString();
      _validFrom = widget.coupon!.validFrom;
      _validTo = widget.coupon!.validTo;
      _isActive = widget.coupon!.isActive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coupon == null ? 'Add Coupon' : 'Edit Coupon'),
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.arrow_left)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Coupon Code', prefixIcon: Icon(Iconsax.tag), hintText: 'e.g., SAVE10'),
                validator: (v) => v?.isEmpty == true ? 'Enter coupon code' : null,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description', prefixIcon: Icon(Iconsax.text), hintText: 'e.g., 10% OFF on orders above ₹20,000'),
                maxLines: 2,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Text('Discount Type'),
              const SizedBox(height: TSizes.xs),
              Row(
                children: [
                  Expanded(child: RadioListTile(
                    title: const Text('Percentage (%)'),
                    value: 'percentage',
                    groupValue: _discountType,
                    onChanged: (v) => setState(() => _discountType = v.toString()),
                    contentPadding: EdgeInsets.zero,
                  )),
                  Expanded(child: RadioListTile(
                    title: const Text('Fixed Amount (₹)'),
                    value: 'fixed',
                    groupValue: _discountType,
                    onChanged: (v) => setState(() => _discountType = v.toString()),
                    contentPadding: EdgeInsets.zero,
                  )),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                controller: _discountValueController,
                decoration: InputDecoration(
                  labelText: _discountType == 'percentage' ? 'Discount (%)' : 'Discount Amount (₹)',
                  prefixIcon: Icon(_discountType == 'percentage' ? Iconsax.percentage_circle : Iconsax.money),
                  hintText: _discountType == 'percentage' ? 'e.g., 10' : 'e.g., 2000',
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v?.isEmpty == true ? 'Enter discount value' : null,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                controller: _minOrderController,
                decoration: const InputDecoration(labelText: 'Minimum Order Amount (₹)', prefixIcon: Icon(Iconsax.money), hintText: 'Optional'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              if (_discountType == 'percentage')
                TextFormField(
                  controller: _maxDiscountController,
                  decoration: const InputDecoration(labelText: 'Maximum Discount Amount (₹)', prefixIcon: Icon(Iconsax.discount_circle), hintText: 'Optional'),
                  keyboardType: TextInputType.number,
                ),
              if (_discountType == 'percentage') const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                controller: _usageLimitController,
                decoration: const InputDecoration(labelText: 'Usage Limit', prefixIcon: Icon(Iconsax.receipt), hintText: '0 = Unlimited'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Row(
                children: [
                  Expanded(child: _buildDatePicker(label: 'Valid From', date: _validFrom, onChanged: (d) => setState(() => _validFrom = d))),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  Expanded(child: _buildDatePicker(label: 'Valid To', date: _validTo, onChanged: (d) => setState(() => _validTo = d))),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              SwitchListTile(title: const Text('Active'), subtitle: const Text('Enable/disable this coupon'),
                value: _isActive, onChanged: (v) => setState(() => _isActive = v), activeColor: TColors.success),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: _saveCoupon,
                  style: ElevatedButton.styleFrom(backgroundColor: TColors.primary),
                  child: Text(widget.coupon == null ? 'Add Coupon' : 'Update Coupon', style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker({required String label, required DateTime date, required Function(DateTime) onChanged}) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 730)),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Iconsax.calendar)),
        child: Text('${date.day}/${date.month}/${date.year}'),
      ),
    );
  }

  void _saveCoupon() {
    if (_formKey.currentState!.validate()) {
      final coupon = CouponModel(
        id: widget.coupon?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        code: _codeController.text.trim().toUpperCase(),
        description: _descriptionController.text.trim(),
        discountType: _discountType,
        discountValue: double.parse(_discountValueController.text),
        minimumOrderAmount: _minOrderController.text.isNotEmpty ? double.parse(_minOrderController.text) : null,
        maximumDiscount: _maxDiscountController.text.isNotEmpty ? double.parse(_maxDiscountController.text) : null,
        validFrom: _validFrom,
        validTo: _validTo,
        usageLimit: _usageLimitController.text.isNotEmpty ? int.parse(_usageLimitController.text) : 0,
        usedCount: widget.coupon?.usedCount ?? 0,
        isActive: _isActive,
        applicableProducts: [],
        applicableCategories: [],
        createdAt: widget.coupon?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      if (widget.coupon == null) controller.addCoupon(coupon);
      else controller.updateCoupon(coupon);
      Get.back();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    _discountValueController.dispose();
    _minOrderController.dispose();
    _maxDiscountController.dispose();
    _usageLimitController.dispose();
    super.dispose();
  }
}