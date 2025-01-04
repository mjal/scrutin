import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import Knex from "knex";
import knexConfig from "./knexfile";

dotenv.config();
const env = process.env.NODE_ENV || "development";
const knex = Knex(knexConfig[env]);

const app = express();
app.use(express.json());
app.use(cors());

app.get("/", (_req, res) => {
  res.send("<h1>Hello :)</h1>");
});

app.put("/:uuid", async (req, res) => {
  const { uuid } = req.params;
  const { setup } = req.body;

  try {
    await knex("setup").insert({ uuid, setup });
    res.status(201).json({ success: true, uuid, setup });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: "Error storing election setup." });
  }
});

app.post("/:uuid/ballots", async (req, res) => {
  const { uuid } = req.params;
  const { ballot, name } = req.body;

  try {
    const election = await knex("setup").select().where({ uuid }).first();
    if (!election) {
      return res.status(404).json({ success: false, message: "Election not found." });
    }

    await knex("ballots").insert({ uuid, ballot, name });

    res.status(201).json({ success: true, uuid, ballot, name });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: "Error storing ballot." });
  }
});

app.put("/:uuid/encryptedTally", async (req, res) => {
  const { uuid } = req.params;
  const { encryptedTally } = req.body;

  try {
    const election = await knex("setup").select().where({ uuid }).first();
    if (!election) {
      return res.status(404).json({ success: false, message: "Election not found." });
    }

    await knex("encryptedTally").insert({ uuid, encryptedTally });
    res.status(201).json({ success: true, uuid, encryptedTally });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: "Error storing encryptedTally." });
  }
});

app.post("/:uuid/partialDecryptions", async (req, res) => {
  const { uuid } = req.params;
  const { partialDecryption } = req.body;

  try {
    const election = await knex("setup").select().where({ uuid }).first();
    if (!election) {
      return res.status(404).json({ success: false, message: "Election not found." });
    }

    await knex("partialDecryptions").insert({ uuid, partialDecryption });
    res.status(201).json({ success: true, uuid, partialDecryption });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: "Error storing partialDecryption." });
  }
});


app.put("/:uuid/result", async (req, res) => {
  const { uuid } = req.params;
  const { result } = req.body;

  try {
    const election = await knex("setup").select().where({ uuid }).first();
    if (!election) {
      return res.status(404).json({ success: false, message: "Election not found." });
    }

    await knex("result").insert({ uuid, result });
    res.status(201).json({ success: true, uuid, result });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: "Error storing result." });
  }
});


app.get("/:uuid", async (req, res) => {
  const { uuid } = req.params;
  try {
    const setup = await knex("setup").select().where({ uuid }).first();
    if (!setup) {
      return res.status(404).json({ success: false, message: "Election not found." });
    }
    const ballots = await knex("ballots").select().where({ uuid });
    const encryptedTally = await knex("encryptedTally").select().where({ uuid }).first();
    const partialDecryptions = await knex("partialDecryptions").select().where({ uuid });
    const result = await knex("result").select().where({ uuid }).first();
    res.status(200).json({ success: true, setup: setup.setup, ballots: ballots.map((o) => o.ballot), partialDecryptions, encryptedTally, result });
  } catch (error) {
    console.log(error);
    res.status(500).json({ success: false, message: "Error fetching election." });
  }
});

//app.get("/:uuid/ballots", async (req, res) => {
//  const { uuid } = req.params;
//  try {
//    const ballots = await knex("ballots").select().where({ election_uuid: uuid });
//    res.status(200).json({ success: true, ballots });
//  } catch (error) {
//    res.status(500).json({ success: false, message: "Error fetching ballots." });
//  }
//});

// Start Server
const port = process.env.PORT || 8080;
app.listen(port, () => console.log(`App listening on port ${port}!`));
