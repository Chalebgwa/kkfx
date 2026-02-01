import 'package:flutter/material.dart';

//item class
class Product{

  final String name;
  final double price;
  final String image;

  const Product({required this.name, required this.price, required this.image});


}

List<Product> products = List.generate(
    10,
        (int i)
    {
      return Product(
          name: "item $i",
          price: 100.0,
          image: "assets/$i-0.png"
      );
    });



//list item
class Item extends StatefulWidget {

  final Product product;


  const Item({Key? key, required this.product}) : super(key: key);

  @override
  State createState() {
    return ItemState(
     product: product
    );
  }
}

class ItemState extends State<Item> {

  final Product product;


  ItemState({required this.product});


  Widget _buildFullScreenPage(){
    return Scaffold(
      appBar: AppBar(
        toolbarOpacity: 1.0,
      ),
      body: Container(child: Image.asset(product.image)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0)
      ),
      child: Container(

        child: InkWell(
          splashColor: Colors.amber,
          onTap: (){

            Navigator.push(context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => _buildFullScreenPage()
            )
            );

          },
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(product.image),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(icon: const Icon(Icons.add_shopping_cart), onPressed: (){
                    Store.cart.add(product);
                  }),
                  Text(
                    product.price.toString(),
                    style: const TextStyle(
                     color: Colors.amber
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}

//class list
class Store extends StatelessWidget {

  static List<Product> cart = <Product>[];

  const Store({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          cart.clear();


        },
        child: const Icon(Icons.shopping_basket),
      ),
      appBar: AppBar(
        title: const Text("Store"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(

                disabledColor: Colors.red,
                icon: const Icon(
                  Icons.shopping_cart
                ),
                color: Colors.white,
                onPressed: (){
                  showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
                    if(cart.isEmpty){

                      return const Center(
                        child: Text("Empty Cart"),
                      );

                    }
                    else{
                    return Container(
                        child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: ListView.builder(
                                itemCount: cart.length,
                                itemBuilder: (BuildContext c,int i){
                                  return Card(
                                    child: ListTile(
                                      title: Text(cart[i].name),
                                      leading: const Icon(Icons.local_florist),
                                      trailing: const Icon(Icons.remove_circle_outline),
                                    ),
                                  );
                                }
                            )
                        )
                    );}
                  });
                }
            ),
          )
        ],
      ),  
      body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (BuildContext context,int i)=> Item(
              product: products[i]
            )
      ),

    );
  }

}