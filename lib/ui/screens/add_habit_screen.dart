import 'package:badhabit_tracker/logic/cubits/habit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/habit_model.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _titleController = TextEditingController();

  final List<int> _availableColors = [
    Colors.redAccent.toARGB32(),
    Colors.blueAccent.toARGB32(),
    Colors.greenAccent.toARGB32(),
    Colors.orangeAccent.toARGB32(),
    Colors.deepPurpleAccent.toARGB32(),
  ];
  late int _selectedColor = _availableColors[0];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Habit')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hint: Text(
                  'Habit Name',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Select Color', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [
              for (final colorValue in _availableColors)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = colorValue;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(colorValue),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == colorValue
                            ? Colors.white
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20),
          const Text('Kogda ti brosil?', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E), // Темный фон кнопки
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_selectedDate.day.toString().padLeft(2, '0')}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year}",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 210, 210, 210),
                      fontSize: 18,
                    ),
                  ),
                  const Icon(
                    Icons.calendar_month,
                    color: Color.fromARGB(255, 210, 210, 210),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: 150,
              height: 40,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),

                onPressed: () {
                  _saveHabit();
                },
                child: Text('Start', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(data: ThemeData.dark(), child: child!);
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveHabit() async {
    final textTitle = _titleController.text.trim();
    final newHabit = HabitModel(
      title: textTitle,
      userId: DateTime.now().millisecondsSinceEpoch.toString(),
      color: _selectedColor,
      startDate: _selectedDate,
    );

    if (textTitle.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Bra vvedi nazavnie')));
      return;
    }
    await context.read<HabitCubit>().newHabit(newHabit);

    if (!mounted) return;
    Navigator.pop(context);
  }
}
