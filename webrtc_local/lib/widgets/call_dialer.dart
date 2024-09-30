import 'package:flutter/material.dart';
import 'package:webrtc_demo/common/constants.dart';

typedef StringCallback = void Function(String);

class CallDialer extends StatefulWidget {
  final StringCallback onCall;

  const CallDialer({super.key, required this.onCall});

  @override
  State<CallDialer> createState() => _CallDialerState();
}

class _CallDialerState extends State<CallDialer> {
  String _calleeId = "";

  void _addDigit(String digit) {
    if (_calleeId.length < Constants.kMaxCallerIdLength) {
      setState(() {
        _calleeId += digit;
      });
    }
  }

  void _deleteDigit() {
    if (_calleeId.isNotEmpty) {
      setState(() {
        _calleeId = _calleeId.substring(0, _calleeId.length - 1);
      });
    }
  }

  void _makeCall() {
    if (_calleeId.isNotEmpty) {
      widget.onCall(_calleeId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter callee Id')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 60.0,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Text(
            _calleeId,
            style: const TextStyle(fontSize: 50, letterSpacing: 2),
            textAlign: TextAlign.center,
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 20.0,
          endIndent: 20.0,
        ),
        _buildNumberPad(),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              iconColor: Colors.white,
              backgroundColor: Colors.green),
          onPressed: _makeCall,
          child: const Icon(Icons.call),
        ),
      ],
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        _buildNumberRow(['1', '2', '3']),
        _buildNumberRow(['4', '5', '6']),
        _buildNumberRow(['7', '8', '9']),
        _buildLastRow(),
      ],
    );
  }

  Widget _buildNumberRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((digit) {
        return _buildNumberButton(digit);
      }).toList(),
    );
  }

  Widget _buildLastRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNumberButton(''),
        _buildNumberButton('0'),
        _buildDeleteButton(),
      ],
    );
  }

  Widget _buildNumberButton(String digit) {
    return ElevatedButton(
      onPressed: () => _addDigit(digit),
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: Text(
        digit,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return ElevatedButton(
      onPressed: _deleteDigit,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: const Icon(Icons.backspace),
    );
  }
}
