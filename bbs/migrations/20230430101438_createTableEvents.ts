import { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable('events', (table) => {
    table.increments('id').primary()
    table.string('cid')
    table.string('type_')
    table.string('content')
    table.string('emitterId')
    table.string('signature')
  })
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTable('events')
}
