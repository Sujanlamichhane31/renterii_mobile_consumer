import 'package:flutter/material.dart';
import 'package:renterii/Themes/colors.dart';

class RegisterTextField extends StatefulWidget {
  const RegisterTextField(
      {Key? key,
      required this.title,
      required this.hint,
      required this.img,
      required this.textEditingController,
      this.validator,
      required this.onlyRead,
      this.onTap})
      : super(key: key);
  final String title;
  final String hint;
  final String img;
  final String? Function(String?)? validator;
  final TextEditingController textEditingController;
  final bool onlyRead;
  final void Function()? onTap;

  @override
  State<RegisterTextField> createState() => _RegisterTextFieldState();
}

class _RegisterTextFieldState extends State<RegisterTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.img.trim().isNotEmpty
            ? Row(
                children: [
                  SizedBox(
                    height: 22,
                    child: Image(
                      image: AssetImage(
                        widget.img,
                      ),
                      color: kMainColor,
                    ),
                  ),
                  const SizedBox(
                    width: 13,
                  ),
                  Text(widget.title,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12))
                ],
              )
            : const SizedBox(),
        Container(
          padding: const EdgeInsets.only(left: 25),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox.shrink(),
                    TextFormField(
                      readOnly: widget.onlyRead,
                      controller: widget.textEditingController,
                      validator: widget.validator,
                      onTap: widget.onTap,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: Colors.black, fontSize: 14),
                      decoration: InputDecoration(
                          suffix: null,
                          isDense: true,
                          prefixStyle: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.black, fontSize: 12),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[200]!),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[200]!),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[200]!),
                          ),
                          hintText: widget.hint,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.grey, fontSize: 14)),
                    ),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}