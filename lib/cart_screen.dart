import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_with_sql/cart_model.dart';
import 'package:shopping_cart_with_sql/db_helper.dart';
import 'cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DbHelper dbHelper=DbHelper();
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('My Products'),
        centerTitle: true,
        actions: [
          badges.Badge(
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
          SizedBox(width: 25),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FutureBuilder(future: cart.getData(),
                builder: (context,AsyncSnapshot<List<Cart>> snapshot){
              if(snapshot.hasData){
                if(snapshot.data!.isEmpty){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 90),
                        child: Image(
                          height: 300,
                            width: 300,
                            image: AssetImage('images/cart1.jpg')),
                      ),
                      Center(child: Text('Your Cart Is Empty.Load It',style: TextStyle(color: Colors.red,fontSize: 30,fontWeight: FontWeight.w900))),
                    ],
                  );
                }
                else{
                  return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
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
                                            image: NetworkImage(snapshot.data![index].image.toString())),
                                        SizedBox(width: 10,),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(snapshot.data![index].productName.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                                  InkWell(
                                                      onTap: (){
                                                        dbHelper.delete(snapshot.data![index].id!);
                                                        cart.removeCounter();
                                                        cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));

                                                      },
                                                      child: Icon(Icons.delete)),

                                                ],
                                              ),

                                              SizedBox(height: 5,),
                                              Text(snapshot.data![index].unitTag.toString()+" "+r"$"+snapshot.data![index].productPrice.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                              Align(
                                                alignment: Alignment.centerRight,
                                                child: InkWell(
                                                  onTap: (){

                                                  },
                                                  child: Container(
                                                    height: 35,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius.circular(5),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(4),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          InkWell(
                                                              onTap: (){
                                                                int quantity=snapshot.data![index].quantity!;
                                                                int price=snapshot.data![index].initialPrice!;
                                                                quantity--;
                                                                int? newPrice= quantity*price;
                                                                if(quantity>0){
                                                                  dbHelper.updateQuantity(Cart(id: snapshot.data![index].id!,
                                                                    productId:snapshot.data![index].id.toString(),
                                                                    productName: snapshot.data![index].productName.toString(),
                                                                    initialPrice: snapshot.data![index].initialPrice!,
                                                                    productPrice:  newPrice,
                                                                    quantity: quantity,
                                                                    unitTag: snapshot.data![index].unitTag.toString(),
                                                                    image: snapshot.data![index].image.toString(),
                                                                  )).then((value){
                                                                    quantity=0;
                                                                    newPrice=0;
                                                                    cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                                  }).onError((error,stackTrace){
                                                                    print(error.toString());
                                                                  });
                                                                }

                                                              },

                                                              child: Icon(Icons.remove,color: Colors.white,)),
                                                          Text(snapshot.data![index].quantity.toString(),style: TextStyle(color:Colors.white),),
                                                          InkWell(
                                                              onTap: (){
                                                                int quantity=snapshot.data![index].quantity!;
                                                                int price=snapshot.data![index].initialPrice!;
                                                                quantity++;
                                                                int? newPrice= quantity*price;
                                                                dbHelper.updateQuantity(Cart(id: snapshot.data![index].id!,
                                                                  productId:snapshot.data![index].id.toString(),
                                                                  productName: snapshot.data![index].productName.toString(),
                                                                  initialPrice: snapshot.data![index].initialPrice!,
                                                                  productPrice:  newPrice,
                                                                  quantity: quantity,
                                                                  unitTag: snapshot.data![index].unitTag.toString(),
                                                                  image: snapshot.data![index].image.toString(),
                                                                )).then((value){
                                                                  quantity=0;
                                                                  newPrice=0;
                                                                  cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice.toString()));
                                                                }).onError((error,stackTrace){
                                                                  print(error.toString());
                                                                });
                                                              },

                                                              child: Icon(Icons.add,color: Colors.white,)),
                                                        ],
                                                      ),
                                                    ),
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
                      ));
                }

              }else{
                return Text('data');
              }
                }),
           Consumer<CartProvider>(builder: (context,value,child){
             return Visibility(
               visible: value.getTotalPrice().toStringAsFixed(2)=="0.00"?false:true,
               child: Column(
                 children: [
                   ReusableWidget(title: 'Sub Total: ', value: r'$'+value.getTotalPrice().toStringAsFixed(2)),
                   ReusableWidget(title: 'Discount 5%: ', value: r'$'+(value.getTotalPrice()*0.05).toStringAsFixed(2)),
                   ReusableWidget(title: 'Total: ', value: r'$'+(value.getTotalPrice()*0.95).toStringAsFixed(2)),
                 ],
               ),
             );
           })
          ],
        ),
      ),
    );
  }
}
class ReusableWidget extends StatelessWidget {
  String title,value;
  ReusableWidget({super.key,required this.title,required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,style: Theme.of(context).textTheme.titleMedium),
          Text(value.toString(),style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}