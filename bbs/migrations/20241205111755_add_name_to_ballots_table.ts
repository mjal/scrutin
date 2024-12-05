import { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.alterTable("ballots", (table) => {
    table.string("name").notNullable().defaultTo(""); // Adding the "name" field with a default value
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.alterTable("ballots", (table) => {
    table.dropColumn("name"); // Remove the "name" field
  });
}
