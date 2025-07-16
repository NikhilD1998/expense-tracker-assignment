const Expense = require("../models/ExpenseModel");

const addExpense = async (req, res) => {
  try {
    const { name, amount, date, category } = req.body;
    const userId = req.user.userId;

    if (!name || !amount || !date || !category) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const expense = new Expense({
      name,
      amount,
      date,
      category,
      user: userId,
    });

    await expense.save();

    res.status(201).json({
      message: "Expense added successfully",
      expense,
    });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Failed to add expense", error: error.message });
  }
};

const getUserExpenses = async (req, res) => {
  try {
    const userId = req.user.userId;
    const expenses = await Expense.find({ user: userId }).sort({ date: -1 });
    res.status(200).json({ expenses });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Failed to fetch expenses", error: error.message });
  }
};

const deleteExpense = async (req, res) => {
  try {
    const userId = req.user.userId;
    const expenseId = req.params.id;

    const expense = await Expense.findOneAndDelete({
      _id: expenseId,
      user: userId,
    });
    if (!expense) {
      return res
        .status(404)
        .json({ message: "Expense not found or unauthorized" });
    }

    res.status(200).json({ message: "Expense deleted successfully" });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Failed to delete expense", error: error.message });
  }
};

module.exports = { addExpense, getUserExpenses, deleteExpense };
