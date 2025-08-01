import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../services/email_service.dart';

final emailServiceProvider = Provider<EmailService>((ref) => EmailService());

class EmailController extends StateNotifier<AsyncValue<void>> {
  final EmailService _emailService;

  EmailController(this._emailService) : super(const AsyncValue.data(null));

  Future<void> sendProductDetails({
    required String recipientEmail,
    required List<Product> products,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _emailService.sendProductDetails(
        recipientEmail: recipientEmail,
        products: products,
      );
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final emailControllerProvider = StateNotifierProvider<EmailController, AsyncValue<void>>((ref) {
  final emailService = ref.read(emailServiceProvider);
  return EmailController(emailService);
});
