import { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable("elections", (table) => {
    table.uuid("uuid").primary();
    table.jsonb("election").notNullable();
    table.jsonb("trustees").notNullable();
    table.jsonb("credentials").notNullable();
    table.timestamps(true, true);
  });
};

export async function down(knex: Knex): Promise<void> {
  return knex.schema.dropTable("elections");
}
