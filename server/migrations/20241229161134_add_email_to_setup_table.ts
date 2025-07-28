import { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
  await knex.schema.alterTable("setup", (table) => {
    table.string("email").nullable();
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.alterTable("setup", (table) => {
    table.dropColumn("email");
  });
}