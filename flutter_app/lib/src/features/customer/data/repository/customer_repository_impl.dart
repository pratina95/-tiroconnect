import 'package:injectable/injectable.dart';
import 'package:tiroconnect/src/features/customer/data/datasource/customer_firestore_datasource.dart';
import 'package:tiroconnect/src/features/customer/domain/entities/customer.dart';

@lazySingleton
class CustomerRepositoryImpl {
  final CustomerFirestoreDatasource datasource;
  CustomerRepositoryImpl(this.datasource);

  Future<void> createCustomer(Customer customer) =>
      datasource.createCustomer(customer);

  Future<Customer?> getCustomerById(String id) =>
      datasource.getCustomerById(id);
}
