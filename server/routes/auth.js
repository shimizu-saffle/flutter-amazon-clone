const express = require("express");
const User = require("../models/user");
const bcryptjs = require("bcryptjs");
const authRouter = express.Router();

authRouter.post("/api/signup", async (req, res) => {
  try {
    // クライアントからデータを取得
    const { name, email, password } = req.body;

    // クライアントから取得したデータをデータベースに保存する
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      // ステータスコードを指定する
      return res
        .status(400) // 400 Bad Request
        .json({ message: "User with same email already exists!" });
    }

    // ユーザーが入力したパスワードをハッシュ化
    const hashedPassword = await bcryptjs.hash(password, 8);

    // 再代入できるようにするため、let で宣言している
    let user = new User({
      email,
      password: hashedPassword,
      name,
    });

    // dbに保存したuserを再代入
    user = await user.save();

    // そのデータをクライアントに返す
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// export することによって server/index.js で import できる。
module.exports = authRouter;
