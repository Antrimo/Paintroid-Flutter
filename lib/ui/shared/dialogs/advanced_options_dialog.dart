import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paintroid/core/providers/state/advanced_settings_state.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import 'package:paintroid/ui/theme/theme.dart';

Future<void> showAdvancedOptionsDialog(BuildContext context) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Advanced Options',
    pageBuilder: (_, __, ___) => const _AdvancedOptionsDialog(),
  );
}

class _AdvancedOptionsDialog extends ConsumerStatefulWidget {
  const _AdvancedOptionsDialog();

  @override
  ConsumerState<_AdvancedOptionsDialog> createState() =>
      _AdvancedOptionsDialogState();
}

class _AdvancedOptionsDialogState
    extends ConsumerState<_AdvancedOptionsDialog> {
  late bool _antialiasing;
  late bool _smoothing;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(advancedSettingsProvider);
    _antialiasing = settings.antialiasing;
    _smoothing = settings.smoothing;
  }

  @override
  Widget build(BuildContext context) {
    final theme = PaintroidTheme.of(context);
    return AlertDialog(
      key: const ValueKey(WidgetIdentifier.advancedOptionsDialog),
      backgroundColor: theme.onSurfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      title: Text(
        'Advanced Options',
        style: TextStyle(color: theme.shadowColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            key: const ValueKey(
                WidgetIdentifier.advancedOptionsAntialiasingSwitch),
            title: Text(
              'Antialiasing',
              style: TextStyle(color: theme.shadowColor),
            ),
            value: _antialiasing,
            onChanged: (value) => setState(() => _antialiasing = value),
          ),
          SwitchListTile(
            key: const ValueKey(
                WidgetIdentifier.advancedOptionsSmoothingSwitch),
            title: Text(
              'Smoothing',
              style: TextStyle(color: theme.shadowColor),
            ),
            value: _smoothing,
            onChanged: (value) => setState(() => _smoothing = value),
          ),
        ],
      ),
      actions: [
        TextButton(
          key: const ValueKey(WidgetIdentifier.advancedOptionsCancelButton),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'CANCEL',
            style: TextStyle(color: theme.primaryColor),
          ),
        ),
        TextButton(
          key: const ValueKey(WidgetIdentifier.advancedOptionsOkButton),
          onPressed: () {
            ref.read(advancedSettingsProvider.notifier).updateSettings(
                  antialiasing: _antialiasing,
                  smoothing: _smoothing,
                );
            Navigator.of(context).pop();
          },
          child: Text(
            'OK',
            style: TextStyle(color: theme.primaryColor),
          ),
        ),
      ],
    );
  }
}
