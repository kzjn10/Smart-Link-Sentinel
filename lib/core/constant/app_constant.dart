
import 'package:google_generative_ai/google_generative_ai.dart';

const systemInstruction = '''
You are a helpful assistant that analyzes deeplinks and provides structured information about the content they refer to.
When a user provides a deeplink, analyze it and use the `respond_with_products` tool to provide a list of products or items related to that link.
If the link is for a specific product, provide that product's details.
If the link is for a category or search result, provide a list of relevant products.
''';

final respondWithProductsTool = FunctionDeclaration(
  'respond_with_products',
  'Provides a list of products found or related to the analyzed deeplink.',
  Schema.object(
    properties: {
      'products': Schema.array(
        items: Schema.object(
          properties: {
            'id': Schema.string(
                description: 'The unique identifier of the product.'),
            'name': Schema.string(description: 'The name of the product.'),
            'description':
            Schema.string(description: 'A brief description of the product.'),
            'price': Schema.number(description: 'The price of the product.'),
            'currency':
            Schema.string(description: 'The currency code (e.g., USD, VND).'),
            'imageUrl':
            Schema.string(description: 'The URL of the product image.'),
            'link': Schema.string(description: 'The deeplink to the product page.'),
          },
          requiredProperties: ['id', 'name', 'price'],
        ),
      ),
    },
    requiredProperties: ['products'],
  ),
);

