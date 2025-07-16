const express = require("express");
const mongoose = require("mongoose");
require("dotenv").config();

const app = express();
const PORT = 3000;

const userRoutes = require("./routes/UserRoutes");

app.use(express.json());

app.use("/api/users", userRoutes);

mongoose
  .connect(process.env.MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.error("MongoDB connection error:", err));

app.get("/", (req, res) => {
  res.send("Expense Tracker API is running!");
});

app.listen(PORT, () => {
  console.log(`Server started on http://localhost:${PORT}`);
});
