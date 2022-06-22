const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
  name: {
    reqired: true,
    trim: true,
    type: String,
  },
  email: {
    reqired: true,
    trim: true,
    type: String,
    validate: {
      validator: (value) => {
        // 正規表現は String型 で渡さない。
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a vailid email address",
    },
    password: {
      required: true,
      type: String,
    },
    address: {
      type: String,
      default: "",
    },
    type: {
      type: String,
      default: "user",
    },
  },
  // cart
});

const User = mongoose.model("User", userSchema);
module.exports = User;
