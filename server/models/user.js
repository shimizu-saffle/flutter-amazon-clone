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
  },
});
