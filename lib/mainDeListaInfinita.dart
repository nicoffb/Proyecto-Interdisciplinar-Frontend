import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_authentication/app.dart';
import 'package:flutter_bloc_authentication/config/locator.dart';
import 'package:flutter_bloc_authentication/blocs/blocs.dart';
import 'package:flutter_bloc_authentication/services/services.dart';
import 'package:flutter_bloc_authentication/pages/pages.dart';
import 'package:flutter_bloc_authentication/simple_bloc_observer.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  configureDependencies();
  runApp(const App());
}
