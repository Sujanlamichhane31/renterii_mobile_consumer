import 'package:renterii/rentals/data/data_providers/rental_data_provider.dart';
import 'package:renterii/rentals/data/models/rental.dart';

class RentalRepository{
  final RentalDataProvider _rentalDataProvider;

  const RentalRepository({
    required RentalDataProvider rentalDataProvider
  }): _rentalDataProvider = rentalDataProvider;


 Future<dynamic> fetchRentals() async{
    final rentalsData = await _rentalDataProvider.fetchRentals();
    final rentals = <Rental>[];
    for (var rental in rentalsData) {
      Map<String, dynamic> data = rental.data();
      print('rentals: $data');
      rentals.add(Rental.fromMap(rental.data()));
      //print(rental.data());
    }
    //final renta = rentalsData.map((rental) => Rental.fromMap(rental.data())).toList();
    print(rentals);
    return rentals;
  }
}