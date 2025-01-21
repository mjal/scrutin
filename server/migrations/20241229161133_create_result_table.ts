import { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("result", (table) => {
    table.increments("id").primary(); // Auto-increment ID
    table.string("uuid").notNullable(); // Foreign key to setup
    table.json("result").notNullable(); // Final result data
    table.timestamps(true, true); // created_at and updated_at
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTable("result");
}
