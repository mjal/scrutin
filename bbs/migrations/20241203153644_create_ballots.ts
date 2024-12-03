import { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable("ballots", (table) => {
    table.increments("id").primary();
    table.uuid("election_uuid").notNullable();
    table.jsonb("ballot").notNullable();
    table.foreign("election_uuid").references("uuid").inTable("elections").onDelete("CASCADE");
    table.timestamps(true, true);
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.dropTable("ballots");
}
