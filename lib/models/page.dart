import 'package:equatable/equatable.dart';

class Page {
  List<Product>? product;
  bool? last;
  bool? first;
  int? totalPages;
  int? totalElements;
  int? currentPage;

  Page(
      {this.product,
      this.last,
      this.first,
      this.totalPages,
      this.totalElements,
      this.currentPage});

  Page.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      product = <Product>[];
      json['content'].forEach((v) {
        //aqui va content???
        product!.add(new Product.fromJson(v));
      });
    }
    last = json['last'];
    first = json['first'];
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
    currentPage = json['currentPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    data['last'] = this.last;
    data['first'] = this.first;
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    data['currentPage'] = this.currentPage;
    return data;
  }
}

class Product {
  int? id;
  String? title;
  String? description;
  double? price;

  Product({this.id, this.title, this.description, this.price});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['price'] = this.price;
    return data;
  }

  @override
  List<Object?> get props => [id, title, description, price];
}
