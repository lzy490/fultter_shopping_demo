import 'package:flutter/material.dart';

//定义一个item对象
class Product {
  String name;
  Product({this.name});
}

//dart中函数也是个对象
//typedef给函数创建个别名， 后续直接可以通过CartChangedCallback cartChangedCallback声明一个函数
//其实只是定义了一个void类型的函数，只有符合void，并且参数是Product product, bool inCart，都是同一个类型
//类型是void Function(Product, bool)
typedef void CartChangedCallback(Product product, bool inCart);


//展示每一个item
class ShoppingListItem extends StatelessWidget {
  //类的变量，callback是个函数
  Product product;
  bool inCart;
  CartChangedCallback callback;

  ShoppingListItem({this.product, this.inCart, this.callback}) : super(key: new ObjectKey(product));

  Color _getColor(BuildContext context) {
    //根据inCart获取color，inCart为true返回black54，否则使用当前环境的颜色
    return inCart ? Colors.black54 : Theme.of(context).primaryColor;
  }
  
  TextStyle _getTextStyle(BuildContext context) {
    //根据inCart获取color，inCart为true返回black54，中划线，否则返回null                            
    return inCart ? new TextStyle(color: Colors.black54, decoration: TextDecoration.lineThrough) : null;
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      onTap: () {
        callback(product, !inCart);
      },
      //CircleAvatar 圆形图像组件
      leading: new CircleAvatar(
        backgroundColor: _getColor(context),
        child: new Text(product.name),
      ),
      title: new Text(product.name, style: _getTextStyle(context)),
    );
  }
}

class ShoppingList extends StatefulWidget {

  List<Product> products;

  ShoppingList({Key, key, this.products}) : super(key:key);

  @override
  State<StatefulWidget> createState() {
    return new _ShoppingListState();
  }
}

class _ShoppingListState extends State<ShoppingList> {

  //购物车，加到购物车里面的数据，会变灰
  Set<Product> _shoppingCart = new Set<Product>();

  //点击item的时候，进行状态切换，会调用该方法
  //函数也是个对象， 类型是void Function(Product, bool)
  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      if (inCart) {
        _shoppingCart.add(product);
      } else {
        _shoppingCart.remove(product);
      }
    });
  }

  //展示列表，使用到了ShoppingListItem这个组件
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //头
      appBar: new AppBar(title: new Text('Shooping list')),
      //body，是一个列表
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        //children是一个列表，使用到了ShoppingListItem，需要将product，inCart和回调方法传进去
        children: widget.products.map((Product product) {
          return new ShoppingListItem(
            product: product, 
            inCart: _shoppingCart.contains(product), 
            callback: _handleCartChanged);
        }).toList()
      ),
    ) ;
  }  
}


//主函数入口
void main() => runApp(new MaterialApp(
  title: 'Shopping App',
  //home需要指定一个组件ShoppingList，初始化ShoppingList的时候会调用createState方法
  //createState方法会调用_ShoppingListState中的build方法
  home: new ShoppingList(
    products: <Product>[
      new Product(name: 'Eggs'), 
      new Product(name: 'Flour'), 
      new Product(name: 'Chocolate chips')
    ]
  )
));

