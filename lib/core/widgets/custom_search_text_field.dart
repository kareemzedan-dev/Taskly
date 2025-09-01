import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class CustomSearchTextField extends StatefulWidget {
  const CustomSearchTextField({super.key, required this.hintTexts});

  final List<String> hintTexts;

  @override
  State<CustomSearchTextField> createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {
  final TextEditingController _controller = TextEditingController();

  bool get _isTyping => _controller.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        // TextField الأساسي
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            ),
            style: const TextStyle(color: Colors.black, fontSize: 16),
            onChanged: (_) => setState(() {}),
          ),
        ),

        // Animated hint
        if (!_isTyping)
          Positioned.fill(
            left: 48, // بعد أيقونة السيرش
            child: Align(
              alignment: Alignment.centerLeft,
              child: IgnorePointer(
                ignoring: true,
                child: AnimatedTextKit(
                  repeatForever: true,
                  pause: const Duration(milliseconds: 1000),
                  animatedTexts:
                      widget.hintTexts
                          .map(
                            (text) => TypewriterAnimatedText(
                              text,
                              textStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                              speed: const Duration(milliseconds: 100),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
