import { Knex } from "knex";


export async function up(knex: Knex): Promise<void> {
  // Update table events, updating field content from string to text
  await knex.schema.alterTable('events', (table) => {
    table.text('content').notNullable().alter()
  })
}


export async function down(knex: Knex): Promise<void> {
  // Make the opposite migration, updating field content from text to string
  await knex.schema.alterTable('events', (table) => {
    table.string('content').notNullable().alter()
  })
}

