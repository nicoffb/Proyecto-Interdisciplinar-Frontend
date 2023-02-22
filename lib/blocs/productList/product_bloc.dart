import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_authentication/models/page.dart';
import 'package:flutter_bloc_authentication/repositories/product_repository.dart';

import 'package:get_it/get_it.dart';
//import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

part 'product_event.dart';
part 'product_state.dart';

//const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(/*{required this.httpClient}*/) : super(const ProductState()) {
    //ProductBloc({required this.repo}) : super(const ProductState()) {
    repo = GetIt.I.get<ProductRepository>();
    on<ProductFetched>(
      _onProductFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  late ProductRepository repo;

  Future<void> _onProductFetched(
    ProductFetched event,
    Emitter<ProductState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == ProductStatus.initial) {
        //final products = await _fetchProducts();
        final products = await repo.fetchProducts();
        return emit(
          state.copyWith(
            status: ProductStatus.success,
            products: products.product,
            hasReachedMax: false,
          ),
        );
      }
      //final products = await _fetchProducts(state.products.length);
      final products = await repo.fetchProducts(state.products.length);
      products.product!.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: ProductStatus.success,
                products: List.of(state.products)..addAll(products.product!),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }
}
