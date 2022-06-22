const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  email: {
    type: String,
    required: true,
    trim: true,
    validate: {
      validator: (value) => {
        // 正規表現は String型 で渡さない。
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return value.match(re);
      },
      message: "Please enter a vailid email address",
    },
  },
  password: {
    required: true,
    type: String,
    validate: {
      validator: (value) => {
        return value.length > 6;
      },
      message: "Please enter a longer password",
    },
  },
  // 必須フィールドでは無いので、default値を指定している。
  address: {
    type: String,
    default: "",
  },
  type: {
    type: String,
    default: "user",
  },
  // cart
});

const User = mongoose.model("User", userSchema);
module.exports = User;
