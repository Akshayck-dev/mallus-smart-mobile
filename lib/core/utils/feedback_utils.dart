import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:quickalert/quickalert.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:mallu_smart/core/utils/design_system.dart';

class FeedbackUtils {
  // Floating Toast/Snackbar Replacement
  static void showToast(BuildContext context, String message, {IconData icon = Icons.info_outline_rounded}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Flushbar(
      message: message,
      icon: Icon(icon, color: CuratorDesign.primaryIndigo, size: 24),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(CuratorDesign.s16),
      borderRadius: BorderRadius.circular(CuratorDesign.radius + 4),
      backgroundColor: (isDark ? CuratorDesign.darkSurfaceLow : Colors.white).withValues(alpha: 0.9),
      flushbarPosition: FlushbarPosition.TOP,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          offset: const Offset(0, 4),
          blurRadius: 12,
        )
      ],
      mainButton: TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text('DISMISS', style: CuratorDesign.label(12, color: CuratorDesign.primaryIndigo)),
      ),
    ).show(context);
  }

  // Success Confirmation with Lottie
  static void showSuccess(BuildContext context, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text: message,
      title: 'Success',
      confirmBtnColor: CuratorDesign.primaryIndigo,
      borderRadius: 24,
    );
  }

  // Error Alert
  static void showError(BuildContext context, String error) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      text: error,
      title: 'Opps...',
      confirmBtnColor: Colors.redAccent,
      borderRadius: 24,
    );
  }

  // Advanced Confirmation Dialog
  static void showConfirmation(
    BuildContext context, {
    required String title,
    required String desc,
    required VoidCallback onConfirm,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: title,
      desc: desc,
      btnCancelOnPress: () {},
      btnOkOnPress: onConfirm,
      btnOkColor: CuratorDesign.primaryIndigo,
      buttonsBorderRadius: BorderRadius.circular(12),
      dialogBorderRadius: BorderRadius.circular(24),
    ).show();
  }
}
