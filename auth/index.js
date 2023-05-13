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
const crypto_1 = __importDefault(require("crypto"));
const dotenv_1 = __importDefault(require("dotenv"));
const mail_1 = __importDefault(require("@sendgrid/mail"));
const fs_1 = require("fs");
const knex_1 = __importDefault(require("knex"));
const knexfile_1 = __importDefault(require("./knexfile"));
const env = process.env.NODE_ENV || 'development';
const knex = (0, knex_1.default)(knexfile_1.default[env]);
const Account = require("./scrutin-lib/Account.bs.js");
const Event_ = require("./scrutin-lib/Event_.bs.js");
let baseUrl = "https://demo.scrutin.app";
if (env == 'development') {
    baseUrl = "http://localhost:19006";
}
dotenv_1.default.config();
if (process.env.SENDGRID_API_KEY) {
    mail_1.default.setApiKey(process.env.SENDGRID_API_KEY);
}
function sendMail(email, electionId, userToken) {
    let link = `${baseUrl}/elections/${electionId}/challenge/${userToken}`;
    if (env === 'production') {
        mail_1.default.send({
            from: 'Scrutin <hello@scrutin-mailing.org>',
            to: email,
            subject: "Vous êtes invité à une élection",
            text: `
        Vous êtes invité à une élection.
        Cliquez ici pour voter :
        ${link}
      `
        })
            .then((response) => {
            console.log("mail sent", response[0].statusCode);
        })
            .catch((error) => {
            console.error(error);
        });
    }
    else {
        fs_1.promises.mkdir("emails", { recursive: true }).then(() => {
            fs_1.promises.writeFile("emails/" + email, JSON.stringify({
                electionId,
                userToken,
                link
            })).then(() => {
                console.log("mail written to disk");
            });
        });
    }
}
const app = (0, express_1.default)();
app.use(express_1.default.json());
app.use((0, cors_1.default)());
app.get('/', (_req, res) => {
    res.send('<h1>Hello :)</h1>');
});
app.post('/users', (0, cors_1.default)(), (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    let { email, electionId, sendInvite } = req.body;
    let userToken = crypto_1.default.randomBytes(16).toString('hex')
        .slice(0, 16).toUpperCase();
    let managerAccount = Account.make();
    let managerId = managerAccount.userId;
    yield knex('users').insert({
        electionId,
        email,
        managerId,
        secret: managerAccount.secret,
        userToken
    });
    if (sendInvite) {
        sendMail(email, electionId, userToken);
    }
    res.send({
        electionId,
        email,
        managerId
    });
}));
app.post('/login', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    let { email, electionId } = req.body;
    const user = yield knex('users').where({ email, electionId }).first();
    if (user) {
        sendMail(user.email, user.electionId, user.userToken);
        res.send(200);
    }
    res.send(401);
}));
app.post('/challenge', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    let { userId, userToken } = req.body;
    const user = yield knex('users').where({
        userToken
    }).first();
    if (!user) {
        return res.status(404).send({ error: 'User not found' });
    }
    const manager = Account.make2(user.secret);
    const event = Event_.ElectionDelegate.create({
        electionId: user.electionId,
        voterId: user.managerId,
        delegateId: userId
    }, manager);
    console.log(user.managerId);
    console.log(manager.userId);
    res.status(200).send(Object.assign(Object.assign({}, event), { id: 0 }));
}));
const port = process.env.PORT || 8081;
app.listen(port, () => console.log(`app listening on port ${port}!`));
