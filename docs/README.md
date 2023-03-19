#### I - End-to-end encryption

**Your vote, your choice.**

Your vote is encrypted: Nobody can read the content of your vote.

#### II - Verifiability

Real-world elections tend to be opaques.
Modern digital election system aims at more transparency.

To do so, the election data, including encrypted ballots is publicly available for everyone to verify the results, through:

**Individual verifibiality**

You can verify that your vote has been taken into account.

**Universal verifibiality**

You can verify that the result is indeed the result of all the ballots.

#### III - Voting list management

**This is still a work-in-progress**

```mermaid
sequenceDiagram
    participant Organisation
    participant Member
    participant Election

	Note over Organisation: GenerateKeyPair
	Note over Member: GenerateKeyPair
    rect rgb(0, 0, 64)
	Note over Member,Organisation: Register Members
    Member->>Organisation: Send public key
    Organisation->>Member: Sign public key
    Organisation-->>Election: Create
    Member->>Election: Vote
    end
    rect rgb(0, 64, 0)
	Note over Organisation,Election: Late registration and lost account
    Member->>Organisation: Send new public key
    Organisation->>Member: Sign new public key
    Organisation-->>Election: Amend voter list
    Member->>Election: Vote
    end
    rect rgb(64, 0, 0)
	Note over Organisation,Election: Decryption
    Organisation-->>Election: Tally and publish results
    Member->>Election: Verify
    end
```
