import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:paintroid/app.dart';
import 'package:paintroid/core/utils/widget_identifier.dart';
import '../../utils/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Widget sut;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sut = ProviderScope(
      child: App(
        showOnboardingPage: false,
      ),
    );
  });

  group('[ADVANCED_OPTIONS]', () {
    testWidgets(
        'Opens dialog from overflow menu with both toggles OFF by default, '
        'toggles Antialiasing, and taps OK', (WidgetTester tester) async {
      UIInteraction.initialize(tester);
      await tester.pumpWidget(sut);
      await UIInteraction.createNewImage();

      final overflowButton = find.byIcon(Icons.more_vert);
      expect(overflowButton, findsOneWidget);
      await tester.tap(overflowButton);
      await tester.pumpAndSettle();

      final advancedOptionsEntry =
          find.byKey(const ValueKey(WidgetIdentifier.advancedOptionsMenuEntry));
      expect(advancedOptionsEntry, findsOneWidget);
      await tester.tap(advancedOptionsEntry);
      await tester.pumpAndSettle();

      final dialog =
          find.byKey(const ValueKey(WidgetIdentifier.advancedOptionsDialog));
      expect(dialog, findsOneWidget);

      expect(find.text('Antialiasing'), findsOneWidget);
      expect(find.text('Smoothing'), findsOneWidget);

      final antialiasingSwitch = tester.widget<SwitchListTile>(find.byKey(
          const ValueKey(WidgetIdentifier.advancedOptionsAntialiasingSwitch)));
      final smoothingSwitch = tester.widget<SwitchListTile>(find.byKey(
          const ValueKey(WidgetIdentifier.advancedOptionsSmoothingSwitch)));
      expect(antialiasingSwitch.value, false);
      expect(smoothingSwitch.value, false);

      await tester.tap(find.byKey(
          const ValueKey(WidgetIdentifier.advancedOptionsAntialiasingSwitch)));
      await tester.pumpAndSettle();

      final updatedAntialiasingSwitch = tester.widget<SwitchListTile>(
          find.byKey(const ValueKey(
              WidgetIdentifier.advancedOptionsAntialiasingSwitch)));
      expect(updatedAntialiasingSwitch.value, true);

      final okButton =
          find.byKey(const ValueKey(WidgetIdentifier.advancedOptionsOkButton));
      expect(okButton, findsOneWidget);
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      expect(dialog, findsNothing);
    });
  });
}
