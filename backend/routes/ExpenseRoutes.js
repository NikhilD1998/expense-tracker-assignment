const express = require("express");
const router = express.Router();
const authMiddleware = require("../middlewares/AuthMiddleware");
const { addExpense } = require("../controllers/AddExpenseController");

router.post("/add", authMiddleware, addExpense);

module.exports = router;
