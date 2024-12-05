import { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.alterTable("ballots", (table) => {
    table.jsonb("demo_plaintexts").nullable();
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.alterTable("ballots", (table) => {
    table.dropColumn("demo_plaintexts");
  });
}
