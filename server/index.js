console.log("Hello World");

const express = require("express");
const mongoose = require("mongoose");

const authRouter = require("./routes/auth");

// initialize
const port = 3000;
const app = express();
const dbUri =
  "mongodb+srv://kenta:*G46jmAkUpPg2C*@cluster0.to4jhyj.mongodb.net/?retryWrites=true&w=majority";

// middleware
// json のみを解析し、Content-Type ヘッダが Content-Type オプションに一致するリクエストのみを検索するミドルウェアを返す。
app.use(express.json());
app.use(authRouter);

// connect to mongodb
mongoose
  .connect(dbUri)
  .then(() => {
    console.log("Connected to mongodb");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(port, "0.0.0.0", () => {
  console.log(`Server is listening on port ${port}`);
});
