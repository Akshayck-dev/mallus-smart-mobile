import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:mallu_smart/utils/design_system.dart';

class ConnectivityDialog extends StatelessWidget {
  const ConnectivityDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      icon: const Icon(
        Icons.signal_wifi_off_rounded,
        size: 32,
        color: CuratorDesign.primaryOrange,
      ),
      title: Text(
        'No Internet Connection',
        textAlign: TextAlign.center,
        style: CuratorDesign.display(20, color: CuratorDesign.textDark),
      ),
      content: Text(
        'Mallu\'s Mart requires an active internet connection to browse our curated collections. Please check your settings.',
        textAlign: TextAlign.center,
        style: CuratorDesign.body(14, color: CuratorDesign.textLight),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'DISMISS',
            style: CuratorDesign.label(12, color: CuratorDesign.textLight),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            AppSettings.openAppSettings(type: AppSettingsType.wireless);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: CuratorDesign.textDark,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            'GO TO SETTINGS',
            style: CuratorDesign.label(12, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

/// Helper method to show the dialog
void showConnectivityDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const ConnectivityDialog(),
  );
}
