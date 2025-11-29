import 'package:flutter/material.dart';

class ReminderDialog extends StatefulWidget {
  final void Function(DateTime reminderTime) onSetReminder;

  const ReminderDialog({super.key, required this.onSetReminder});

  @override
  State<ReminderDialog> createState() => _HomeReminderDialogState();
}

class _HomeReminderDialogState extends State<ReminderDialog> {
  DateTime selectedDateTime = DateTime.now();

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    setState(() => selectedDateTime = DateTime(
        date.year, date.month, date.day, selectedDateTime.hour, selectedDateTime.minute));
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime:
      TimeOfDay(hour: selectedDateTime.hour, minute: selectedDateTime.minute),
    );
    if (time == null) return;
    setState(() => selectedDateTime = DateTime(
        selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, time.hour, time.minute));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xff1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Set Reminder",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: pickDate,
            leading: const Icon(Icons.calendar_today, color: Colors.white),
            title: Text(
              "${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            onTap: pickTime,
            leading: const Icon(Icons.access_time, color: Colors.white),
            title: Text(
              "${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal, foregroundColor: Colors.white),
          onPressed: () {
            widget.onSetReminder(selectedDateTime);
            Navigator.pop(context);
          },
          child: const Text("Set"),
        ),
      ],
    );
  }
}
