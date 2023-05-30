// ignore_for_file: implementation_imports, unused_shown_name

import 'package:flutter_bloc/src/bloc_provider.dart'
    show BlocProvider, BlocProviderSingleChildWidget;

abstract class ProviderList {
  static List<BlocProviderSingleChildWidget> providers = [
    // BlocProvider<LangBloc>(create: (_) => LangBloc()),
  ];
}
