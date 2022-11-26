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
