const express = require('express');
const User = require('../models/user');
const bcryptjs = require('bcryptjs');
const authRouter = express.Router();
const jwt = require('jsonwebtoken');

// Sign Up Route
authRouter.post('/api/signup', async (req, res) => {
  try {
    // クライアントからデータを取得
    const { name, email, password } = req.body;

    // クライアントから取得したデータをデータベースに保存する
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      // ステータスコードを指定する
      return res
        .status(400) // 400 Bad Request
        .json({ message: 'User with same email already exists!' });
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

// Sign In Route
authRouter.post('/api/signin', async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .json({ message: 'User with this email does not exist!' });
    }

    const isMatch = bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res
        .status(400)
        .json({ message: 'Incorrect password! Please try again!' });
    }

    const token = jwt.sign({ id: user._id }, 'passwordKey');
    res.json({ token, ...user._doc });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

authRouter.post('/tokenIsValid', async (req, res) => {
  try {
    const token = req.headers('x-auth-token');
    if (!token) return res.json(false);

    const verified = jwt.verify(token, 'passwordKey');
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);

    res.json(true);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// export することによって server/index.js で import できる。
module.exports = authRouter;
