const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
    },
    password: {
      type: String,
      required: true,
    },
    // Add more fields as needed (e.g., createdAt, avatar, etc.)
  },
  { timestamps: true }
);

const User = mongoose.model("User", userSchema);

module.exports = User;
