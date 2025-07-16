import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/helpers/device_dimensions.dart';
import 'package:frontend/widgets/custom_primary_button.dart';
import 'package:frontend/widgets/custom_text_field.dart';
import 'package:frontend/providers/expense_provider.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  DateTime? selectedDate;
  String selectedCategory = 'Food';

  final List<String> categories = ['Food', 'Transport', 'Shopping', 'Bills'];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _addExpense() async {
    if (nameController.text.trim().isEmpty ||
        amountController.text.trim().isEmpty ||
        selectedDate == null ||
        selectedCategory.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    await ref
        .read(expenseProvider.notifier)
        .addExpense(
          name: nameController.text.trim(),
          amount: double.tryParse(amountController.text.trim()) ?? 0,
          date: selectedDate!.toIso8601String(),
          category: selectedCategory,
        );

    final state = ref.read(expenseProvider);
    if (state.success) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else if (state.error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    DeviceDimensions.init(context);
    final expenseState = ref.watch(expenseProvider);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('Add New Expense'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: DeviceDimensions.width * 0.05,
          vertical: DeviceDimensions.height * 0.03,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: DeviceDimensions.width * 0.9,
                child: CustomTextField(
                  controller: nameController,
                  label: 'Expense Name',
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: DeviceDimensions.width * 0.9,
                child: CustomTextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  label: 'Amount',
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: DeviceDimensions.width * 0.9,
                child: InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      selectedDate != null
                          ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                          : 'Select Date',
                      style: TextStyle(
                        color: selectedDate != null
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: DeviceDimensions.width * 0.9,
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: categories
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: DeviceDimensions.width * 0.9,
                height: 48,
                child: CustomPrimaryButton(
                  onPressed: _addExpense,
                  label: expenseState.isLoading ? 'Adding...' : 'Add',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
