"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = __importDefault(require("dotenv"));
const knex_1 = __importDefault(require("knex"));
const knexfile_1 = __importDefault(require("./knexfile"));
dotenv_1.default.config();
const env = process.env.NODE_ENV || "development";
const knex = (0, knex_1.default)(knexfile_1.default[env]);
const app = (0, express_1.default)();
app.use(express_1.default.json());
app.use((0, cors_1.default)());
app.get("/", (_req, res) => {
    res.send("<h1>Hello :)</h1>");
});
app.put("/:uuid", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { uuid } = req.params;
    const { election, trustees, credentials } = req.body;
    console.log(election, trustees, credentials);
    try {
        yield knex("elections").insert({
            uuid,
            election,
            trustees,
            credentials
        });
        res.status(201).json({ success: true, uuid, election, trustees, credentials });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: "Error storing election." });
    }
}));
app.post("/:uuid/ballots", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { uuid } = req.params;
    const { ballot, name, demo_plaintexts } = req.body;
    try {
        // Check if election exists
        const election = yield knex("elections").select().where({ uuid }).first();
        if (!election) {
            return res.status(404).json({ success: false, message: "Election not found." });
        }
        yield knex("ballots").insert({
            election_uuid: uuid,
            ballot,
            name,
            demo_plaintexts: JSON.stringify(demo_plaintexts),
        });
        res.status(201).json({ success: true, election_uuid: uuid, ballot });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: "Error storing ballot." });
    }
}));
app.post("/:uuid/result", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { uuid } = req.params;
    const { result } = req.body;
    try {
        // Check if election exists
        const election = yield knex("elections").select().where({ uuid }).first();
        if (!election) {
            return res.status(404).json({ success: false, message: "Election not found." });
        }
        yield knex("ballots").insert({
            election_uuid: uuid,
            result: JSON.stringify(result)
        });
        res.status(201).json({ success: true, election_uuid: uuid, result });
    }
    catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: "Error storing result." });
    }
}));
app.get("/:uuid", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { uuid } = req.params;
    try {
        const setup = yield knex("elections").select().where({ uuid }).first();
        const { election, trustees, credentials } = setup;
        if (!election) {
            return res.status(404).json({ success: false, message: "Election not found." });
        }
        res.status(200).json({ success: true, election, trustees, credentials });
    }
    catch (error) {
        res.status(500).json({ success: false, message: "Error fetching election." });
    }
}));
app.get("/:uuid/ballots", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { uuid } = req.params;
    try {
        const ballots = yield knex("ballots").select().where({ election_uuid: uuid });
        res.status(200).json({ success: true, ballots });
    }
    catch (error) {
        res.status(500).json({ success: false, message: "Error fetching ballots." });
    }
}));
// Start Server
const port = process.env.PORT || 8080;
app.listen(port, () => console.log(`App listening on port ${port}!`));
