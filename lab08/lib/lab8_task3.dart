import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange,
        hintColor: Colors.orangeAccent,
      ),
      home: ProductListScreen(),
      debugShowCheckedModeBanner: false, // Turn off the debug banner
    );
  }
}

class Product {
  final int id;
  final String name;
  final double price;
  final String imagePath;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.imagePath});
}

class CartController extends GetxController {
  var products = <Product>[].obs;
  var cartItems = <Product>[].obs;

  void addToCart(Product product) {
    cartItems.add(product);
  }

  void removeFromCart(Product product) {
    cartItems.remove(product);
  }
}

class ProductListScreen extends StatelessWidget {
  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    // Sample list of products with local images
    final products = [
      Product(
          id: 1,
          name: 'Product 1',
          price: 10.0,
          imagePath: 'assets/image1.jpeg'),
      Product(
          id: 2,
          name: 'Product 2',
          price: 20.0,
          imagePath: 'assets/image2.jpeg'),
      Product(
          id: 3,
          name: 'Product 3',
          price: 30.0,
          imagePath: 'assets/image3.jpeg'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          Obx(() => Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Get.to(() => CartScreen());
                    },
                  ),
                  if (controller.cartItems.isNotEmpty)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${controller.cartItems.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ))
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 3 / 2,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[200],
                    child: Image.asset(
                      product.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('\$${product.price.toStringAsFixed(2)}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.addToCart(product);
                    },
                    child: Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final CartController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Obx(
        () => controller.cartItems.isEmpty
            ? Center(child: Text('No items in the cart'))
            : ListView.builder(
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final product = controller.cartItems[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(product.imagePath),
                      backgroundColor: Colors.grey[200],
                    ),
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_shopping_cart),
                      onPressed: () {
                        controller.removeFromCart(product);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
