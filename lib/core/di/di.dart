import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskly/features/freelancer/data/data_sources/remote/freelancer_orders/fetch_private_orders_remote_data_source/fetch_private_orders_remote_data_source.dart' as _i765;
import 'package:taskly/features/freelancer/data/data_sources_impl/remote/freelancer_orders/fetch_private_orders_remote_data_source_impl/fetch_private_orders_remote_data_source_impl.dart' as _i919;

import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  // تأكد من تسجيل هذه التبعيات قبل استخدامها

 
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
  
)

Future<void> configureDependencies() async {
  
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => Supabase.instance.client);
  getIt.init();
}