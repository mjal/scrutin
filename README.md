<p align="center">
  <a href="https://app.netlify.com/sites/scrutin/deploys">
    <img src="https://api.netlify.com/api/v1/badges/c5ba7726-90e0-474e-b85f-4d1447fb11f5/deploy-status" alt="Deploy status" />
  </a>
  <a href="https://hosted.weblate.org/engage/scrutin/">
    <img src="https://hosted.weblate.org/widgets/scrutin/-/app/svg-badge.svg" alt="Translation status" />
  </a>
</p>

A mobile app for secure voting using the Helios protocol and INRIA’s [Belenios](https://www.belenios.org) voting library.

```mermaid
sequenceDiagram
  participant Guardians
  participant Election
  participant Voters

  Guardians->>Election: Create
  Voters->>Election: Vote
  Guardians->>Election: Tally
	Voters->>Election: Verify
```

## Features

##### Belenios integration

- [x] Generate trustee keys on device
- [x] Encrypt ballot on device
- [x] Tally election on device
- [ ] Verify result on device

##### Architecture

- [x] Every events must be signed by an authorized identity
- [x] Events
	- [x] Election creation. From election organizer
	- [x] Ballot emission (adding a new voter identity). From election organizer
	- [x] Ballot filling. From voter
- [X] Running a main public pod

##### UI/UX

- [ ] Resuts as a pie chart
- [ ] Inspect the progress of an elections (how many empty/filled ballots)

##### Translations
on [Hosted Weblate](https://hosted.weblate.org/engage/scrutin/) \
<a href="https://hosted.weblate.org/engage/scrutin/">
<img src="https://hosted.weblate.org/widgets/scrutin/-/app/multi-auto.svg" alt="Translation status" />
</a>

##### Nice to have

- [ ] Extract rescript-belenios
- [ ] Extract rescript-sjcl

## Developer instructions

```
npm install
npm run re:start # or use the VSCode plugin
npm start
```

## Annotated source code

main | models
-----|-------
[Core](https://scrutin-app.github.io/scrutin/src/Core.html) | [Event](https://scrutin-app.github.io/scrutin/src/model/Event_.html)
[State](https://scrutin-app.github.io/scrutin/src/State.html) | ~~[Ballot](https://scrutin-app.github.io/scrutin/src/model/Ballot.html)~~
~~[StateEffect](https://scrutin-app.github.io/scrutin/src/StateEffect.html)~~ | ~~[Trustee](https://scrutin-app.github.io/scrutin/src/model/Trustee.html)~~
. | ~~[Identity](https://scrutin-app.github.io/scrutin/src/model/Identity.html)~~
. | ~~[Election](https://scrutin-app.github.io/scrutin/src/model/Election.html)~~


<!--
## Release
[Web demo](https://demo.scrutin.app)
[Android APK](https://expo.dev/accounts/mlalisse/projects/scrutin/builds/e6bd66f5-ce96-4dac-b874-ab2c0a1f3b1b)
-->
