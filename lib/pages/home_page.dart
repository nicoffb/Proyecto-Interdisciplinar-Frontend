import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_authentication/blocs/authentication/authentication.dart';
import 'package:flutter_bloc_authentication/blocs/favorite/bloc/favorite_bloc.dart';
import 'package:flutter_bloc_authentication/blocs/productList/product_bloc.dart';
import 'package:flutter_bloc_authentication/repositories/favorite_repository.dart';

import '../models/models.dart';

class HomePage extends StatelessWidget {
  final User user;
  final FavoriteRepository favoriteRepository;

  const HomePage(
      {Key? key, required this.user, required this.favoriteRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (_) => ProductBloc()..add(ProductFetched()),
        ),
        BlocProvider<FavoriteBloc>(
          create: (_) => FavoriteBloc(favoriteRepository: favoriteRepository),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home Page'),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Welcome, ${user.fullName}',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 12,
                ),
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state.status == ProductStatus.failure) {
                      return const Text("fallo");
                    }
                    if (state.status == ProductStatus.initial) {
                      return const Text("cargando");
                    }
                    if (state.status == ProductStatus.success) {
                      return Column(
                        children: state.products.map((product) {
                          return Column(
                            children: [
                              Text('Name: ${product.title}'),
                              Text('Price: ${product.price}'),
                              Image.network(
                                  "http://localhost:8080/product/download/${product.image}"),
                              Text('Platform: ${product.platform}'),
                              const SizedBox(height: 12),
                              // BlocBuilder<FavoriteBloc, FavoriteState>(
                              //   builder: (context, state) {
                              //     if (state is FavoriteSuccess) {
                              //       return ElevatedButton(
                              //         onPressed: () {
                              //           // context.read<FavoriteBloc>().add(
                              //           //       FavoriteAdded(product: product),
                              //           //     );
                              //         },
                              //         child: const Text('Add to favorites'),
                              //       );
                              //     } else if (state is FavoriteFailure) {
                              //       return Text(state.error);
                              //     } else {
                              //       return const Text("no se han obtenido");
                              //     }
                              //   },
                              // ),
                            ],
                          );
                        }).toList(),
                      );
                    }
                    return const Text("no se han obtenido");
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0, // Indica el índice de la pestaña actual
          onTap: (index) {
            // Maneja el evento de toque de la pestaña
            if (index == 0) {
              // Navegar a la página de inicio
              Navigator.pushNamed(context, '/');
            } else if (index == 1) {
              // Navegar a la página de favoritos
              Navigator.pushNamed(context, '/favorites');
            } else if (index == 2) {
              // Realizar el logout
              authBloc.add(UserLoggedOut());
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.logout),
              label: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}
