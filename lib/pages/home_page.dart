import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_authentication/blocs/authentication/authentication.dart';
import 'package:flutter_bloc_authentication/blocs/productList/product_bloc.dart';
import 'package:flutter_bloc_authentication/config/locator.dart';
import 'package:flutter_bloc_authentication/pages/product_list.dart';
import 'package:flutter_bloc_authentication/pages/product_page.dart';
import 'package:flutter_bloc_authentication/services/services.dart';
import '../models/models.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocProvider(
      create: (_) => ProductBloc()..add(ProductFetched()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Welcome, ${user.fullName}',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 12,
                ),
                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state.status == ProductStatus.failure) {
                      return Text("fallo");
                    }
                    if (state.status == ProductStatus.initial) {
                      return Text("cargando");
                    }
                    if (state.status == ProductStatus.success) {
                      return Text("${state.products.length}");
                    }
                    return Text("pues nada");
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    print("Check");
                    JwtAuthenticationService service =
                        getIt<JwtAuthenticationService>();
                    await service.getCurrentUser();
                  },
                  child: Text('Check'),
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
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}
