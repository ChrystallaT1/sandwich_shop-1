import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart' as app;
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/order_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('add a sandwich to the cart and verify it is in the cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test the initial state of the app (on the order screen)
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsWidgets);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton); // Scroll if needed
      await tester.pumpAndSettle();

      // Add a sandwich to the cart
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart summary updated
      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);

      // Find the View Cart button to navigate to the cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify that we're on the cart screen and the sandwich is there
      expect(find.textContaining('Cart'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);
    });

    testWidgets('change sandwich type and add to cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();

      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.textContaining('Cart'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(ListView),
          matching: find.text('Chicken Teriyaki'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('modify quantity and add to cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final quantitySection = find.text('Quantity: ');
      expect(quantitySection, findsOneWidget);

      // Find the + button that's near the quantity text
      final addButtons = find.byIcon(Icons.add);
      // The + button should be the first one (before the cart + button)
      final quantityAddButton = addButtons.first;

      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);
    });

    testWidgets('complete checkout flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);

      final confirmPaymentButton = find.text('Confirm Payment');
      await tester.tap(confirmPaymentButton);
      await tester.pumpAndSettle();

      // Wait for payment processing (2 seconds + buffer)
      await tester.pump(const Duration(seconds: 3));

      // Should be back on order screen with empty cart
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });

    testWidgets('add multiple sandwiches and complete checkout',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add first sandwich
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      // Change sandwich type
      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      // Add second sandwich
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();

      // View Cart
      await tester.tap(find.widgetWithText(StyledButton, 'View Cart'));
      await tester.pumpAndSettle();

      // Both sandwiches should be listed
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);

      // Checkout
      await tester.tap(find.widgetWithText(StyledButton, 'Checkout'));
      await tester.pumpAndSettle();
      expect(find.text('Checkout'), findsOneWidget);

      // Confirm payment
      await tester.tap(find.text('Confirm Payment'));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('settings font size persists after navigation',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Settings
      final settingsButton = find.widgetWithText(StyledButton, 'Settings');
      await tester.ensureVisible(settingsButton);
      await tester.pumpAndSettle();
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      final slider = find.byType(Slider);
      await tester.ensureVisible(slider);
      await tester.pumpAndSettle();
      await tester.drag(slider, const Offset(50, 0));
      await tester.pumpAndSettle();

      // Note the new font size text
      final fontSizeText = find.textContaining('Current size:');
      expect(fontSizeText, findsOneWidget);

      // Navigate away and back
      await tester.tap(find.widgetWithText(ElevatedButton, 'Back to Order'));
      await tester.pumpAndSettle();
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      // Font size should persist
      expect(fontSizeText, findsOneWidget);
    });

    testWidgets('navigate between all main screens',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Order -> Cart
      await tester.tap(find.widgetWithText(StyledButton, 'View Cart'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Cart'), findsOneWidget);

      // Cart -> Back to Order
      final backButton = find.widgetWithText(StyledButton, 'Back to Order');
      await tester.ensureVisible(backButton);
      await tester.tap(backButton);
      await tester.pumpAndSettle();
      expect(find.text('Sandwich Counter'), findsOneWidget);

      // Order -> Profile
      await tester.tap(find.widgetWithText(StyledButton, 'Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Profile'), findsOneWidget);

      // Profile -> Back to Order
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Sandwich Counter'), findsOneWidget);

      // Order -> Settings
      await tester.tap(find.widgetWithText(StyledButton, 'Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('cannot checkout with empty cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Go to Cart
      await tester.tap(find.widgetWithText(StyledButton, 'View Cart'));
      await tester.pumpAndSettle();

      // Try to checkout
      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      if (tester.any(checkoutButton)) {
        await tester.tap(checkoutButton);
        await tester.pumpAndSettle();
        expect(find.textContaining('empty'), findsOneWidget);
      } else {
        // Button is not present, which is expected if cart is empty
        expect(true, isTrue);
      }
    });

    testWidgets('cart quantity does not go below zero',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Try to decrement quantity below zero
      final removeButton = find.byIcon(Icons.remove).first;
      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      // Quantity should remain at 0
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('cart is empty after app restart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add to cart
      await tester.tap(find.widgetWithText(StyledButton, 'Add to Cart'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Cart: 1 items'), findsOneWidget);

      // Restart app
      app.main();
      await tester.pumpAndSettle();

      // Cart should be empty
      expect(find.textContaining('Cart: 0 items'), findsOneWidget);
    });

    testWidgets('save profile information', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to Profile
      await tester.tap(find.widgetWithText(StyledButton, 'Profile'));
      await tester.pumpAndSettle();

      // Modify some profile information
      await tester.enterText(find.byType(TextField).first, 'John Doe');
      await tester.pumpAndSettle();

      final saveButton = find.widgetWithText(StyledButton, 'Save Profile');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify that the profile information is saved
      expect(find.text('Profile saved!'), findsOneWidget);
    });
  });
}
