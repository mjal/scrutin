import { Election, Trustee, Question, Setup, Ballot, EncryptedTally, PartialDecryption, Result } from 'sirona';
import { Dayjs } from 'dayjs';

export type PasswordPolicy = 'local' | 'file' | 'extern';


// ElectionData module
export namespace ElectionData {

  export interface t {
    setup: Setup.t;
    ballots: Ballot.t[];
    encryptedTally?: EncryptedTally.t;
    partialDecryptions: PartialDecryption.t[];
    result?: Result.t;
  }
}