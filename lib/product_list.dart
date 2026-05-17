import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shopping_cart_with_sql/cart_model.dart';
import 'package:shopping_cart_with_sql/cart_provider.dart';
import 'package:shopping_cart_with_sql/cart_screen.dart';
import 'package:shopping_cart_with_sql/db_helper.dart';
class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  DbHelper? dbHelper=DbHelper();
  List<String> productName=['Cherry','Mango','Banana','Peach','Grapes','orange','Strawberry'];
  List<String> productUnit=['kg','Dozen','kg','Dozen','kg','kg','kg'];
  List<int> productPrice=[10,20,30,40,50,60,70];
  List<String> productImages=[
    'https://www.shutterstock.com/shutterstock/photos/1392023051/display_1500/stock-photo-cherry-isolated-cherry-on-white-cherries-with-clipping-path-1392023051.jpg',
    'https://www.shutterstock.com/shutterstock/photos/1987479101/display_1500/stock-vector-fresh-mango-with-mango-slice-and-leaves-vector-illustration-1987479101.jpg',
    'https://www.shutterstock.com/shutterstock/photos/1722111529/display_1500/stock-photo-bunch-of-bananas-isolated-on-white-background-with-clipping-path-and-full-depth-of-field-1722111529.jpg',
    'https://www.shutterstock.com/shutterstock/photos/2485109819/display_1500/stock-photo-ripe-red-peaches-with-green-leaf-isolated-on-white-background-file-contains-clipping-path-2485109819.jpg',
    'https://www.shutterstock.com/shutterstock/photos/2287063575/display_1500/stock-photo-purple-witch-finger-grapes-isolated-on-background-moon-drops-grape-or-sapphire-grapes-with-leaves-2287063575.jpg',
    'https://www.shutterstock.com/shutterstock/photos/2493232041/display_1500/stock-photo-fresh-oranges-with-cut-in-half-isolated-on-white-background-2493232041.jpg',
    'https://www.shutterstock.com/shutterstock/photos/2426201425/display_1500/stock-photo-strawberries-isolated-strawberry-slice-and-whole-on-white-background-perfect-retouch-full-depth-2426201425.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<CartProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Products List'),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>CartScreen()));
              },
              child: Center(
                child: badges.Badge(
                  badgeContent: Consumer<CartProvider>(
                    builder: (context,value,child){
                      return  Text(value.getCounter().toString(),style: TextStyle(color: Colors.white));
                    },
                     ),
                  badgeAnimation:badges.BadgeAnimation.fade(
                    animationDuration: Duration(milliseconds: 300),
                  ),
                  child:  Icon(Icons.shopping_bag_outlined,color: Colors.white,),
                ),
              ),
            ),
            SizedBox(width: 25),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: productPrice.length,
                  itemBuilder: (context,index){
                    return Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image(
                                  height: 100,
                                    width: 100,
                                    image: NetworkImage(productImages[index].toString())),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(productName[index].toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                      SizedBox(height: 5,),
                                      Text(productUnit[index].toString()+" "+r"$"+productPrice[index].toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: (){
                                            dbHelper!.insert(
                                              Cart(
                                                id: index,
                                                  productId: index.toString(),
                                                  productName: productName[index].toString(),
                                                  initialPrice: productPrice[index],
                                                  productPrice: productPrice[index],
                                                  quantity: 1,
                                                  unitTag: productUnit[index].toString(),
                                                  image: productImages[index].toString(),
                                              ),
                                            ).then((value){
                                              print('Product is added to cart');
                                              cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                              cart.addCounter();

                                            }).onError((error,StackTrace){
                                              print('Error'+error.toString());

                                            });
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Center(child: Text('Add to cart',style: TextStyle(color:Colors.white),)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }
              ),
            ),

          ],
        ),
      ),
    );
  }
}

