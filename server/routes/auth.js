const express = require("express");

const authRouter = express.Router();

authRouter.post("api/signup", (req, res) => {
  // クライアントからデータを取得
  const { name, email, password } = req.body;
  // そのデータをデータベースに保存する

  // そのデータをクライアントに返す
});

// export することによって server/index.js で import できる。
module.exports = authRouter;
