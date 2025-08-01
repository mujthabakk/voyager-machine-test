import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../models/product_model.dart';

class EmailService {
  static const String _smtpServer = 'smtp.gmail.com';
  static const int _smtpPort = 587;
  static const String _username = 'mujthabakk9@gmail.com';
  static const String _password = 'rlsg exuo oszq vqlg';

  Future<void> sendProductDetails({
    required String recipientEmail,
    required List<Product> products,
  }) async {
    try {
      final smtpServer = SmtpServer(
        _smtpServer,
        port: _smtpPort,
        username: _username,
        password: _password,
      );

      final message = Message()
        ..from = Address(_username, 'Voyager App')
        ..recipients.add(recipientEmail)
        ..subject = 'Product Details - Voyager App'
        ..html = _buildProductEmailHtml(products);

      await send(message, smtpServer);
    } catch (e) {
      throw Exception('Failed to send email: $e');
    }
  }

  String _buildProductEmailHtml(List<Product> products) {
    final StringBuffer html = StringBuffer();

    html.write('''
      <!DOCTYPE html>
      <html>
      <head>
        <style>
          body { font-family: Arial, sans-serif; margin: 20px; }
          .header { color: #2196F3; border-bottom: 2px solid #2196F3; padding-bottom: 10px; }
          .product { border: 1px solid #ddd; margin: 10px 0; padding: 15px; border-radius: 5px; }
          .product-name { font-size: 18px; font-weight: bold; color: #333; }
          .product-code { color: #666; font-size: 14px; }
          .product-price { color: #2196F3; font-weight: bold; font-size: 16px; }
          .product-description { margin: 10px 0; color: #555; }
          .footer { margin-top: 30px; padding-top: 20px; border-top: 1px solid #ddd; color: #888; }
        </style>
      </head>
      <body>
        <div class="header">
          <h2>Product Details from Voyager App</h2>
        </div>
    ''');

    for (final product in products) {
      html.write('''
        <div class="product">
          <div class="product-name">${product.productName}</div>
          <div class="product-code">Code: ${product.productCode}</div>
          <div class="product-price">\$${product.price.toStringAsFixed(2)}</div>
          <div class="product-description">${product.description}</div>
          <div><strong>Category:</strong> ${product.category}</div>
          <div><strong>Available Quantity:</strong> ${product.quantity}</div>
        </div>
      ''');
    }

    html.write('''
        <div class="footer">
          <p>Thank you for using Voyager App!</p>
          <p>This email was sent automatically. Please do not reply.</p>
        </div>
      </body>
      </html>
    ''');

    return html.toString();
  }
}
