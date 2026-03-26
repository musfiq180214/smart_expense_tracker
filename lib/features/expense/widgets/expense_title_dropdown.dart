import 'package:flutter/material.dart';

class TitleDropdownField extends StatefulWidget {
  final List<String> options;
  final TextEditingController controller;
  final FocusNode focusNode;

  const TitleDropdownField({
    super.key,
    required this.options,
    required this.controller,
    required this.focusNode,
  });

  @override
  _TitleDropdownFieldState createState() => _TitleDropdownFieldState();
}

class _TitleDropdownFieldState extends State<TitleDropdownField> {
  late LayerLink _layerLink;
  OverlayEntry? _overlayEntry;
  bool isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _layerLink = LayerLink();
    widget.focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    _removeOverlay();
    super.dispose();
  }

  void _handleFocusChange() {
    if (widget.focusNode.hasFocus && !isDropdownOpen) {
      _showOverlay();
    } else if (!widget.focusNode.hasFocus && isDropdownOpen) {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => isDropdownOpen = true);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => isDropdownOpen = false);
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final filteredOptions = widget.options
        .where(
          (o) => o.toLowerCase().contains(widget.controller.text.toLowerCase()),
        )
        .toList();

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: filteredOptions.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final option = filteredOptions[index];
                  return ListTile(
                    title: Text(option),
                    onTap: () {
                      widget.controller.text = option;
                      widget.focusNode.unfocus();
                      _removeOverlay();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
          labelText: "Title",
          suffixIcon: IconButton(
            icon: Icon(
              isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            ),
            onPressed: () {
              if (isDropdownOpen) {
                widget.focusNode.unfocus();
              } else {
                widget.focusNode.requestFocus();
              }
            },
          ),
        ),
        onChanged: (value) {
          if (isDropdownOpen) {
            _overlayEntry?.remove();
            _overlayEntry = _createOverlayEntry();
            Overlay.of(context).insert(_overlayEntry!);
          }
        },
        onTap: () {
          if (!isDropdownOpen) {
            _showOverlay();
          }
        },
      ),
    );
  }
}
