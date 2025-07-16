const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/AuthMiddleware");
const {
  addExpense,
  getUserExpenses,
  deleteExpense,
} = require("../controllers/AddExpenseController");

router.post("/add", authMiddleware, addExpense);
router.get("/all", authMiddleware, getUserExpenses);
router.delete("/delete/:id", authMiddleware, deleteExpense);

module.exports = router;
