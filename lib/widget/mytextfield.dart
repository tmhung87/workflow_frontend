import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MyTextField extends StatefulWidget {
  const MyTextField({
    super.key,
    this.label,
    required this.controller,
    this.isValidator = false,
    this.enable,
    this.obscureText = false,
    this.inputFormatters,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.isDate = false,
    this.hintText,
  });
  final String? label;
  final TextEditingController controller;
  final bool isValidator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool? enable;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool isDate;
  final String? hintText;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  String? _hintText;
  @override
  void initState() {
    super.initState();
    widget.isDate
        ? _hintText = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString()
        : _hintText = widget.hintText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: widget.keyboardType,
        inputFormatters:
            widget.isDate ? [dateTimeInput] : widget.inputFormatters,
        obscureText: widget.obscureText,
        enabled: widget.enable,
        controller: widget.controller,
        onFieldSubmitted: (value) {
          if (value == '.' || value.isEmpty) {
            widget.controller.text = _hintText ?? '';
          } else if (widget.isDate) {
            widget.controller.text = getDate(value);
          }
        },

        onTapOutside: (event) {
          if (widget.isDate &&
              !RegExp(r'\d{2}/\d{2}/\d{4}').hasMatch(widget.controller.text)) {
            widget.controller.clear();
          }
        },

        decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.green.shade300),
          hintText: _hintText,
          prefixStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),

          suffixIcon:
              widget.enable == false
                  ? null
                  : widget.suffixIcon ??
                      (widget.isDate
                          ? InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.date_range),
                            ),
                            onLongPress: () {
                              widget.controller.clear();
                            },
                            onTap: () async {
                              var dateTime = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now().subtract(
                                  Duration(days: 90),
                                ),
                                lastDate: DateTime.now().add(
                                  Duration(days: 30),
                                ),
                                currentDate: DateTime.now(),
                              );
                              if (dateTime != null) {
                                widget.controller.text = DateFormat(
                                  'dd/MM/yyyy',
                                ).format(dateTime);
                              }
                            },
                          )
                          : InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.clear),
                            ),
                            onTap: () {
                              widget.controller.clear();
                            },
                          )),
          prefix: widget.prefixIcon,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: true,
          // disabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(
          //     color: Theme.of(context).colorScheme.primary,
          //   ),
          // ),
          // labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(
          //     color: Theme.of(context).colorScheme.primary,
          //   ),
          // ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          labelText: widget.label,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),

        validator:
            widget.isValidator
                ? (value) {
                  if (value == null || value.isEmpty) {
                    return "This field cannot be empty";
                  }
                  return null;
                }
                : null,
      ),
    );
  }

  TextInputFormatter get dateTimeInput =>
      TextInputFormatter.withFunction((oldValue, newValue) {
        if (newValue.text.length < oldValue.text.length) {
          return newValue;
        }

        String formatted = '';
        String digitsOnly = '';

        if (!RegExp(r'^[\.\+\-]').hasMatch(newValue.text[0])) {
          digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
          if (digitsOnly.length > 8) {
            digitsOnly = digitsOnly.substring(0, 8);
          }

          for (int i = 0; i < digitsOnly.length; i++) {
            formatted += digitsOnly[i];
            if (i == 1 || i == 3) {
              formatted += '/';
            }
          }
        } else {
          formatted = newValue.text;
        }

        return TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      });
}

String getDate(String value) {
  if (RegExp(r'\-[0-9]+$').hasMatch(value)) {
    int? number = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
    if (number != null) {
      return DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.now().subtract(Duration(days: number)));
    }
  }
  if (RegExp(r'\+[0-9]+$').hasMatch(value)) {
    int? number = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
    if (number != null) {
      return DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.now().add(Duration(days: number)));
    }
  }
  if (RegExp(r'\-[0-9]+d').hasMatch(value)) {
    int? number = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
    if (number != null) {
      return DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.now().subtract(Duration(days: number)));
    }
  }
  if (RegExp(r'\+[0-9]+d').hasMatch(value)) {
    int? number = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
    if (number != null) {
      return DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.now().add(Duration(days: number)));
    }
  }
  if (RegExp(r'\-[0-9]+m').hasMatch(value)) {
    var dateTime = DateTime.now();
    var d = dateTime.day;
    var m = dateTime.month;
    var y = dateTime.year;
    int? number = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
    if (number != null) {
      return DateFormat('dd/MM/yyyy').format(DateTime(y, m - number, d));
    }
  }
  if (RegExp(r'\+[0-9]+m').hasMatch(value)) {
    var dateTime = DateTime.now();
    var d = dateTime.day;
    var m = dateTime.month;
    var y = dateTime.year;
    int? number = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
    if (number != null) {
      return DateFormat('dd/MM/yyyy').format(DateTime(y, m + number, d));
    }
  }
  if (RegExp(r'\-[0-9]+y').hasMatch(value)) {
    var dateTime = DateTime.now();
    var d = dateTime.day;
    var m = dateTime.month;
    var y = dateTime.year;
    int? number = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
    if (number != null) {
      return DateFormat('dd/MM/yyyy').format(DateTime(y - number, m, d));
    }
  }
  if (RegExp(r'\+[0-9]+y').hasMatch(value)) {
    var dateTime = DateTime.now();
    var d = dateTime.day;
    var m = dateTime.month;
    var y = dateTime.year;
    int? number = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
    if (number != null) {
      return DateFormat('dd/MM/yyyy').format(DateTime(y + number, m, d));
    }
  }
  return value;
}
