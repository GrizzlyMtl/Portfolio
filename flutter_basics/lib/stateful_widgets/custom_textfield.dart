import 'package:flutter/material.dart';

/// A professional, reusable custom text field widget (TextField-based).
/// Supports label, hint, icon, password toggle, and more, with container styling matching your custom_container.
class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final IconData? icon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool autoFocus;
  final int? maxLines;
  final int? minLines;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final Color? color;
  final double? borderRadius;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.icon,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.autoFocus = false,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.onSubmitted,
    this.color,
    this.borderRadius,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final Color containerColor =
        widget.color ??
        Theme.of(context).cardTheme.color ??
        const Color.fromARGB(255, 34, 34, 34);
    final double radius = widget.borderRadius ?? 16;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(90, 0, 0, 0),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            if (widget.icon != null)
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 4.0),
                child: Icon(
                  widget.icon,
                  color: Theme.of(context).iconTheme.color ?? Colors.white70,
                ),
              ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                obscureText: widget.isPassword ? _obscureText : false,
                keyboardType: widget.keyboardType,
                autofocus: widget.autoFocus,
                maxLines: widget.isPassword ? 1 : widget.maxLines,
                minLines: widget.minLines,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      Theme.of(context).textTheme.bodyLarge?.color ??
                      Colors.white,
                ),
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                decoration: InputDecoration(
                  labelText: widget.label,
                  labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color:
                        Theme.of(context).textTheme.labelLarge?.color ??
                        Colors.white70,
                  ),
                  hintText: widget.hint,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withAlpha(128) ??
                        Colors.white38,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 18,
                  ),
                ),
                cursorColor:
                    Theme.of(context).textTheme.bodyLarge?.color ??
                    Colors.white70,
              ),
            ),
            if (widget.isPassword)
              IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).iconTheme.color ?? Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
