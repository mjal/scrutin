import { Knex } from "knex";


export async function up(knex: Knex): Promise<void> {
  return knex.schema.alterTable('users', table => {
    table.dropUnique(['electionId', 'email'])
    table.dropColumn('email')
    table.string('username')
    table.enum('type', ['email', 'phone']).notNullable().defaultTo('email')
    table.unique(['electionId', 'username', 'type'])
  })
};

export async function down(knex: Knex): Promise<void> {
};
