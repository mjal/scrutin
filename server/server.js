const { Sequelize } = require('sequelize');

navigator = {userAgent: ""}
let {belenios} = require("./belenios_jslib2")

const express = require("express");
const app = express();
const port = process.env.PORT || 8080;

const sequelize = new Sequelize(process.env.DATABASE_URL)

const Event = sequelize.define('Event', {
  content: {
    type: DataTypes.JSON,
  },
  contentHahs: {
    type: DataTypes.STRING,
  },
  signature: {
    type: DataTypes.STRING,
  }
}, {});

app.get("/", (req, res) => {
  greeting = "<h1>Hello :)</h1>";
  res.send(greeting);
});

app.listen(port, () => console.log(`app listening on port ${port}!`))
