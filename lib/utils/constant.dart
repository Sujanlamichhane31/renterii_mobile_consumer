import 'package:renterii/rentals/presentation/widgets/choose_ordering_method.dart';

class ProfileCategory {
  final String categoryId;
  final String name;

  ProfileCategory({required this.categoryId, required this.name});
}

List<ProfileCategory> profileCategory = [
  ProfileCategory(categoryId: '0', name: "Entrepreneur"),
  ProfileCategory(categoryId: '1', name: "Professional"),
  ProfileCategory(categoryId: '2', name: "Students"),
  ProfileCategory(categoryId: '3', name: "Figuring It Out"),
  ProfileCategory(categoryId: '4', name: "Freelancer"),
  ProfileCategory(categoryId: '5', name: "Retiree"),
  ProfileCategory(categoryId: '6', name: "Other"),
];

final List<Method> method = [
  Method('images/Group 473.png', "Pay + Pickup", '+\$2.50'),
  Method('images/Group 473.png', "Delivery At Spot", '+\$2.50'),
];

final List<Reach> reach = [
  Reach("1 Person"),
  Reach("2 Persons"),
  Reach("3 Persons"),
  Reach("4 Persons"),
  Reach("5 Persons"),
  Reach("5+ Person"),
  Reach("10+ Persons"),
];
