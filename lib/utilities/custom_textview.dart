import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final int? maxLength;
  final Function(String)? onChanged;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final bool? enabled;
  final Color? borderColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final String? Function(String?)? validator;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.maxLength,
    this.onChanged,
    this.hintTextStyle,
    this.textStyle,
    this.enabled,
    this.borderColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.validator,
    this.readOnly = false,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  String? _errorText;
  bool _hasError = false;
  late ValueNotifier<int> _charCountNotifier;

  @override
  void initState() {
    super.initState();
    _charCountNotifier = ValueNotifier<int>(widget.controller?.text.length ?? 0);
    widget.controller?.addListener(_updateCharacterCount);
    _updateCharacterCount();
  }

  _updateCharacterCount() {
    if (!_charCountNotifier.hasListeners) return;
    if (widget.maxLength != null) {
      final usedCount = widget.controller?.text.length ?? 0;
      _charCountNotifier.value = usedCount;
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_updateCharacterCount);
    _charCountNotifier.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            SizedBox(
              height: 60, // Fixed height for consistency
              child: TextFormField(
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                obscureText: widget.isPassword ? _obscureText : false,
                maxLength: widget.maxLength,
                onChanged: (value) {
                  setState(() {
                    _errorText = null;
                    _hasError = false;
                  });

                  // Update character count only if maxLength is set
                  if (widget.maxLength != null) {
                    _charCountNotifier.value = value.length;
                  }

                  // Live validation
                  if (widget.validator != null) {
                    setState(() {
                      _errorText = widget.validator!(value.trim());
                      _hasError = _errorText != null;
                    });
                  }
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'^\s+')),
                  FilteringTextInputFormatter.deny(RegExp(r'\s{2,}')),
                ],
                enabled: widget.enabled ?? true,
                style: widget.textStyle ?? const TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(20, 12, 55, 12),
                  hintText: widget.hintText,
                  hintStyle: widget.hintTextStyle ??
                      TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w400),
                  counterText: "", // Hide default Flutter counter
                  filled: true,
                  fillColor: widget.enabled ?? true ? Colors.white : Colors.grey[300],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: widget.borderColor ?? Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: _hasError
                            ? (widget.errorBorderColor ?? Colors.red)
                            : (widget.enabledBorderColor ?? Colors.grey)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                        color: _hasError
                            ? (widget.errorBorderColor ?? Colors.red)
                            : (widget.focusedBorderColor ?? Colors.blue)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: widget.errorBorderColor ?? Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: widget.errorBorderColor ?? Colors.red),
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(widget.prefixIcon, color: Colors.grey[700])
                      : null,
                  suffixIcon: widget.isPassword
                      ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                      : null,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "This field cannot be empty";
                  } else if (widget.validator != null) {
                    return widget.validator!(value.trim());
                  }
                  return null;
                },
              ),
            ),
            // Positioned character counter (Show only if maxLength is set)
            if (widget.maxLength != null)
              Positioned(
                right: 15,  // Adjust positioning for right alignment
                bottom: 25, // Adjust to place it at bottom-right
                child: ValueListenableBuilder<int>(
                  valueListenable: _charCountNotifier,
                  builder: (context, usedChars, child) {
                    final totalChars = widget.maxLength ?? 0;
                    final remainingChars = totalChars - usedChars;

                    return Text(
                      "$usedChars/$totalChars", // Format as "0/30"
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    );
                  },
                ),
              ),
          ],
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              _errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}