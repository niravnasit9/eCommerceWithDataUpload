import 'package:flutter/material.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/colors.dart';

class AdminDeleteConfirmation {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}