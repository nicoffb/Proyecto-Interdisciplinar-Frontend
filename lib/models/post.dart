import 'package:equatable/equatable.dart';

class Post {
  List<Content>? content;
  bool? last;
  bool? first;
  int? totalPages;
  int? totalElements;
  int? currentPage;

  Post(
      {this.content,
      this.last,
      this.first,
      this.totalPages,
      this.totalElements,
      this.currentPage});

  Post.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(new Content.fromJson(v));
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
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['last'] = this.last;
    data['first'] = this.first;
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    data['currentPage'] = this.currentPage;
    return data;
  }
}

class Content {
  int? id;
  String? title;
  String? description;
  double? price;

  Content({this.id, this.title, this.description, this.price});

  Content.fromJson(Map<String, dynamic> json) {
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
