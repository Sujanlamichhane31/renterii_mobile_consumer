import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  final String? label;
  final String? title;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const EntryField({
    Key? key,
    this.label,
    this.title,
    this.controller,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        label != null
            ? Row(
                children: [
                  Text(
                    label!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 12),
                  ),
                ],
              )
            : const SizedBox.shrink(),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixStyle: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.black),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            hintText: title,
            hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Colors.black,
                  fontSize: 17,
                ),
          ),
        ),
      ],
    );
  }
}

class SmallTextFormField extends StatelessWidget {
  final String? label;
  final String? title;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const SmallTextFormField({
    Key? key,
    this.label,
    this.title,
    this.keyboardType,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        label != null
            ? Row(
                children: [
                  Text(
                    label!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 11),
                  ),
                ],
              )
            : const SizedBox.shrink(),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
              isDense: true,
              prefixStyle: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              hintText: title,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.black, fontSize: 14)),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

class SmallImageTextFormField extends StatelessWidget {
  final String img;
  final String label;
  final String title;

  const SmallImageTextFormField({
    Key? key,
    required this.img,
    required this.label,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style:
                  Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 11),
            ),
          ],
        ),
        TextFormField(
          decoration: InputDecoration(
              isDense: true,
              prefixStyle: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              hintText: title,
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.black, fontSize: 14)),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}
