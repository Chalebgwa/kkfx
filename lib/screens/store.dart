import 'package:flutter/material.dart';

//item class
class Product{

  final String name;
  final double price;
  final String image;

  const Product({@required this.name,@required this.price,@required this.image});


}

List<Product> products = List.generate(
    10,
        (int i)
    {
      return new Product(
          name: "item $i",
          price: 100.0,
          image: "assets/$i-0.png"
      );
    });



//list item
class Item extends StatefulWidget {

  final Product product;


  const Item({this.product});

  @override
  State createState() {
    return ItemState(
     product: product
    );
  }
}

class ItemState extends State<Item> {

  final Product product;


  ItemState({this.product});


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
                child: Image.asset(
                    this.product.image),
              ),
              ButtonBar(
                alignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.add_shopping_cart), onPressed: (){
                    Store.cart.add(this.product);
                  }),
                  Text(
                    product.price.toString(),
                    style: TextStyle(
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

  static List<Product> cart = new List<Product>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          cart.clear();


        },
        child: Icon(Icons.shopping_basket),
      ),
      appBar: AppBar(
        title: Text("Store"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(

                disabledColor: Colors.red,
                icon: Icon(
                  Icons.shopping_cart
                ),
                color: Colors.white,
                onPressed: (){
                  showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
                    if(cart.length==0){

                      return Center(
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
                                      leading: Icon(Icons.local_florist),
                                      trailing: Icon(Icons.remove_circle_outline),
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