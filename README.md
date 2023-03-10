## Documentation

### main logic

[Core](https://scrutin-app.github.io/scrutin/src/Core.html)

### state management

[State](https://scrutin-app.github.io/scrutin/src/State.html)

[StateEffect](https://scrutin-app.github.io/scrutin/src/StateEffect.html)

### models

##### What we need to model an election 

[Election](https://scrutin-app.github.io/scrutin/src/model/Election.html)

[Ballot](https://scrutin-app.github.io/scrutin/src/model/Ballot.html)

[Trustee](https://scrutin-app.github.io/scrutin/src/model/Trustee.html)

##### The mean of decentralized authentication

[Identity](https://scrutin-app.github.io/scrutin/src/model/Identity.html)

##### The mean of a decentralized storage

[Transaction](https://scrutin-app.github.io/scrutin/src/model/Transaction.html)

## Features

##### [Belenios]() integration

- [x] Generate trustee keys on device
- [x] Encrypt Ballot on device
- [x] Tally election on device
- [ ] Verify result on device

##### Trustlessness

- [x] Every action (called a transaction) must be signed by an authorized identity
- [x] Transactions
	- [x] Election creation. From election organizer
	- [x] Ballot emission (adding a new voter identity). From election organizer
	- [x] Ballot filling. From voter
- [ ] Running a main public pod
- [ ] Merging divergent transactions logs
	Note: the signed events do not include a `previous` field like in SecureScuttleButt. Making merging possible (maybe using Lamport Clock) 


##### UI/UX

- [ ] Resuts as a pie chart
- [ ] Inspect deroulement of an elections (how many empty/filled ballots)

##### Nice to have

- [ ] Douglas Crockford base32
- [ ] Compressed ECDSA addresses
- [ ] Allow an election to be managed by multiples organizations (allowing different entities to emit identities with voting rights)
- [ ] Extract rescript-sjcl

## Developer instructions

```
# Install dependencies (You need nodejs 14, use nvm if you need)
npm install

# Compile rescript in another tab (or use the vscode plugin)
npm run re:start

npm run web
```

## Release

[Web demo](https://demo.scrutin.app)

[Android apk](https://expo.dev/accounts/mlalisse/projects/scrutin/builds/e6bd66f5-ce96-4dac-b874-ab2c0a1f3b1b)
