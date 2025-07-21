import * as Sirona from 'sirona';
import { Election, Trustee, Question } from 'sirona';
import { Dayjs } from 'dayjs';

export type PasswordPolicy = 'local' | 'file' | 'extern';
export type InvitationMethod = 'lien' | 'email';

export interface ElectionState {
  title: string;
  desc: string;
  questions: Question.QuestionH.t[];
  emails: string[];
  access?: 'open' | 'closed';
  invitationMethod?: InvitationMethod;
  votingMethod?: 'uninominal' | 'majorityJudgement';
  startDate?: Dayjs;
  endDate?: Dayjs;
  passwordPolicy?: PasswordPolicy;
  mnemonic?: string;
  election?: any; // Using any for sirona Election type
  trustees?: any; // Using any for sirona Trustee type
}