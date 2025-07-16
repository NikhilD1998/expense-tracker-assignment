const Expense = require("../models/ExpenseModel");

const addExpense = async (req, res) => {
  try {
    const { name, amount, date } = req.body;
    const userId = req.user.userId;

    if (!name || !amount || !date) {
      return res.status(400).json({ message: "All fields are required" });
    }

    const expense = new Expense({
      name,
      amount,
      date,
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

module.exports = { addExpense };
