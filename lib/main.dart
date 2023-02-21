import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_authentication/config/locator.dart';
import 'package:flutter_bloc_authentication/blocs/blocs.dart';
import 'package:flutter_bloc_authentication/pages/product_list.dart';
import 'package:flutter_bloc_authentication/pages/product_page.dart';
import 'package:flutter_bloc_authentication/services/services.dart';
import 'package:flutter_bloc_authentication/pages/pages.dart';
import 'package:flutter_bloc_authentication/simple_bloc_observer.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  setupAsyncDependencies();
  configureDependencies();

  final authService = getIt<JwtAuthenticationService>();
  final authenticationBloc = AuthenticationBloc(authService);
  authenticationBloc.add(AppLoaded());

  runApp(BlocProvider<AuthenticationBloc>.value(
    value: authenticationBloc,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            // show home page
            return HomePage(
              user: state.user,
            );
          }
          // otherwise show login page
          return LoginPage();
        },
      ),
    );
  }
}
