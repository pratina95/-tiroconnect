import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tiroconnect/src/features/customer/domain/entities/customer.dart';

@lazySingleton
class CustomerFirestoreDatasource {
  final FirebaseFirestore firestore;
  CustomerFirestoreDatasource(this.firestore);

  Future<void> createCustomer(Customer customer) async {
    await firestore.collection("customers").doc(customer.id).set({
      'id': customer.id,
      'name': customer.name,
      'phone': customer.phone,
      'location': customer.location,
      'createdAt': customer.createdAt.toIso8601String(),
    });
  }

  Future<Customer?> getCustomerById(String id) async {
    final doc = await firestore.collection("customers").doc(id).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return Customer(
      id: data['id'] as String,
      name: data['name'] as String,
      phone: data['phone'] as String,
      location: data['location'] as String,
      createdAt: DateTime.parse(data['createdAt'] as String),
    );
  }
}
