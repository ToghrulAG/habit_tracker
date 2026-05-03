import 'package:badhabit_tracker/logic/cubits/habit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/habit_model.dart';

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

  final List<String> _availableIcons = [
    'lib/assets/icons/alcohol.png',
    'lib/assets/icons/gambling.png',
    'lib/assets/icons/gaming.png',
    'lib/assets/icons/social-media.png',
    'lib/assets/icons/pornography.png',
    'lib/assets/icons/masturbation.png',
    'lib/assets/icons/marijuana.png',
    'lib/assets/icons/drug.png',
  ];

  late String _selectedIcon = _availableIcons[0];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() {
      setState(() {});
    });
  }

  DateTime _selectedDate = DateTime.now();

  String? _errorText = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Habit')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            GestureDetector(
              onTap: showIconPicker,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Image.asset(_selectedIcon),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  errorText: _errorText,
                  suffixIcon: _titleController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _titleController.clear();
                            FocusScope.of(context).unfocus();
                          },
                          icon: Icon(Icons.close),
                        )
                      : null,
                  hintText: 'Habit Name',
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
            SizedBox(height: 35),
            const Text('Quit Date', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),

            InkWell(
              onTap: _pickDate,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.calendar_today),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Date',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Text(
                        '${_selectedDate.day.toString().padLeft(2, '0')}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            // InkWell(
            //   onTap: _pickDate,
            //   borderRadius: BorderRadius.circular(16),
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 16,
            //       vertical: 16,
            //     ),
            //     decoration: BoxDecoration(
            //       color: const Color(0xFF1E1E1E), // Темный фон кнопки
            //       borderRadius: BorderRadius.circular(16),
            //       border: Border.all(color: Colors.grey.shade800),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           "${_selectedDate.day.toString().padLeft(2, '0')}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year}",
            //           style: TextStyle(
            //             color: const Color.fromARGB(255, 210, 210, 210),
            //             fontSize: 18,
            //           ),
            //         ),
            //         const Icon(
            //           Icons.calendar_month,
            //           color: Color.fromARGB(255, 210, 210, 210),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(height: 20),
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

  void showIconPicker() {
    showModalBottomSheet(
      context: context,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Icon',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  ..._availableIcons.map((iconPath) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = iconPath;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _selectedIcon == iconPath
                              ? Colors.blueAccent
                              : Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Image.asset(iconPath, width: 40, height: 40),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveHabit() async {
    final textTitle = _titleController.text.trim();
    final newHabit = HabitModel(
      title: textTitle,
      userId: DateTime.now().millisecondsSinceEpoch.toString(),
      color: _selectedColor,
      startDate: _selectedDate,
      icon: _selectedIcon,
      
    );

    if (textTitle.isEmpty) {
      setState(() {
        _errorText = 'Habit name is required';
      });
      return ;
    }
    await context.read<HabitCubit>().newHabit(newHabit);

    if (!mounted) return;
    Navigator.pop(context);
  }
}
