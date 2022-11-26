import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shops/business_logic/cubit/shop_cubit.dart';
import '../../business_logic/cubit/category_cubit.dart';

class CategoriesListView extends StatefulWidget {
  final VoidCallback onTapCategory;

  const CategoriesListView({
    Key? key,
    required this.onTapCategory,
  }) : super(key: key);

  @override
  State<CategoriesListView> createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView> {
  @override
  int _value = -1;
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(left: 10),
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoaded) {
            return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: _value == index
                                ? Colors.blueAccent
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(4.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                state.categories[index].name,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () async {
                      if (_value != index) {
                        setState(() {
                          _value = index;
                        });
                      }
                      await context
                          .read<ShopCubit>()
                          .getShopsByCategory(state.categories[index].id!);
                      widget.onTapCategory();
                    },
                  );
                });
          } else {
            return const Text('No categories found. Try again');
          }
        },
      ),
    );
  }
}
