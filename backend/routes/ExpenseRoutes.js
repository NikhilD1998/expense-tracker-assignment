const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/AuthMiddleware");
const {
  addExpense,
  getUserExpenses,
} = require("../controllers/AddExpenseController");

router.post("/add", authMiddleware, addExpense);
router.get("/all", authMiddleware, getUserExpenses);

module.exports = router;
