// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:tiroconnect/src/core/di/register_module.dart' as _i327;
import 'package:tiroconnect/src/core/services/api_service.dart' as _i562;
import 'package:tiroconnect/src/core/services/firebase_service.dart' as _i431;
import 'package:tiroconnect/src/features/auth/data/repositories/auth_repository.dart'
    as _i635;
import 'package:tiroconnect/src/features/auth/presentation/bloc/auth_bloc.dart'
    as _i570;
import 'package:tiroconnect/src/features/customer/data/datasource/customer_firestore_datasource.dart'
    as _i199;
import 'package:tiroconnect/src/features/customer/data/repository/customer_repository_impl.dart'
    as _i693;
import 'package:tiroconnect/src/features/jobs/data/repositories/jobs_repository.dart'
    as _i645;
import 'package:tiroconnect/src/features/jobs/presentation/bloc/jobs_bloc.dart'
    as _i442;
import 'package:tiroconnect/src/features/messaging/data/repository/messaging_repository.dart'
    as _i601;
import 'package:tiroconnect/src/features/notifications/data/datasource/notification_datasource.dart'
    as _i708;
import 'package:tiroconnect/src/features/notifications/data/repository/notification_repository.dart'
    as _i915;
import 'package:tiroconnect/src/features/notifications/data/repository/notification_repository_impl.dart'
    as _i432;
import 'package:tiroconnect/src/features/services/data/datasource/firestore_service_request_datasource.dart'
    as _i582;
import 'package:tiroconnect/src/features/services/data/repository/service_request_repository.dart'
    as _i362;
import 'package:tiroconnect/src/features/services/data/repository/service_request_repository_impl.dart'
    as _i1013;
import 'package:tiroconnect/src/features/workers/data/datasource/worker_firestore_datasource.dart'
    as _i928;
import 'package:tiroconnect/src/features/workers/data/repository/worker_repository_impl.dart'
    as _i1023;
import 'package:tiroconnect/src/features/workers/domain/repository/worker_repository.dart'
    as _i9;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.lazySingleton<_i431.FirebaseService>(() => _i431.FirebaseService());
    gh.lazySingleton<_i582.FirestoreServiceRequestDataSource>(
        () => _i582.FirestoreServiceRequestDataSource());
    gh.factory<_i708.NotificationDataSource>(
        () => _i708.FirestoreNotificationDataSource());
    gh.factory<_i915.NotificationRepository>(() =>
        _i432.NotificationRepositoryImpl(gh<_i708.NotificationDataSource>()));
    gh.lazySingleton<_i562.ApiService>(() => _i562.ApiService(gh<_i361.Dio>()));
    gh.lazySingleton<_i199.CustomerFirestoreDatasource>(
        () => _i199.CustomerFirestoreDatasource(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i928.WorkerFirestoreDatasource>(
        () => _i928.WorkerFirestoreDatasource(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i645.JobsRepository>(
        () => _i645.JobsRepositoryImpl(gh<_i562.ApiService>()));
    gh.lazySingleton<_i693.CustomerRepositoryImpl>(() =>
        _i693.CustomerRepositoryImpl(gh<_i199.CustomerFirestoreDatasource>()));
    gh.factory<_i362.ServiceRequestRepository>(() =>
        _i1013.ServiceRequestRepositoryImpl(
            gh<_i582.FirestoreServiceRequestDataSource>()));
    gh.lazySingleton<_i601.MessagingRepository>(
        () => _i601.MessagingRepository(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i635.AuthRepository>(() => _i635.AuthRepositoryImpl(
          gh<_i431.FirebaseService>(),
          gh<_i562.ApiService>(),
        ));
    gh.lazySingleton<_i570.AuthBloc>(
        () => _i570.AuthBloc(gh<_i635.AuthRepository>()));
    gh.lazySingleton<_i442.JobsBloc>(
        () => _i442.JobsBloc(gh<_i645.JobsRepository>()));
    gh.lazySingleton<_i9.WorkerRepository>(() =>
        _i1023.WorkerRepositoryImpl(gh<_i928.WorkerFirestoreDatasource>()));
    return this;
  }
}

class _$RegisterModule extends _i327.RegisterModule {}
