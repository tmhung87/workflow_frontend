import 'package:flutter/material.dart';

class PushProgressWidget<T> extends StatefulWidget {
  final List<T> items;
  final Future<Map<String, dynamic>> Function(T item) onPush;
  final String Function(T item)? getLabel;
  final void Function()? onFinish;
  final bool stopOnError;

  const PushProgressWidget({
    super.key,
    required this.items,
    required this.onPush,
    this.getLabel,
    this.onFinish,
    this.stopOnError = true,
  });

  @override
  State<PushProgressWidget<T>> createState() => _PushProgressWidgetState<T>();
}

class _PushProgressWidgetState<T> extends State<PushProgressWidget<T>> {
  int _current = 0;
  bool _isRunning = false;
  final List<String> _errors = [];

  @override
  void initState() {
    super.initState();
    _startPushing();
  }

  Future<void> _startPushing() async {
    setState(() {
      _isRunning = true;
      _errors.clear();
      _current = 0;
    });

    for (int i = 0; i < widget.items.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      final item = widget.items[i];

      try {
        var res = await widget.onPush(item);
        if (res['state'] != true) {
          throw res['message'] ?? 'Unknown error';
        }
      } catch (e) {
        _errors.add(widget.getLabel?.call(item) ?? 'Item ${i + 1}: $e');
        if (widget.stopOnError) break;
      }

      setState(() => _current = i + 1);
    }

    setState(() => _isRunning = false);
    widget.onFinish?.call();
  }

  @override
  Widget build(BuildContext context) {
    double percent = widget.items.isEmpty ? 0 : _current / widget.items.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isRunning) const Text('Pushing data...'),
        LinearProgressIndicator(value: percent),
        const SizedBox(height: 8),
        Text('$_current / ${widget.items.length}'),
        if (_current < widget.items.length && _isRunning)
          Text(widget.getLabel?.call(widget.items[_current]) ?? ''),
        const SizedBox(height: 12),
        if (_errors.isNotEmpty)
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Errors:',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ..._errors.map(
                  (e) =>
                      Text('- $e', style: const TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
