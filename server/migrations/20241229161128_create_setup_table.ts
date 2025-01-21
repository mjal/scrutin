import { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("setup", (table) => {
    table.string("uuid").primary(); // Election UUID
    table.json("setup");          // Election setup details (stored as JSON)
    table.timestamps(true, true); // created_at and updated_at
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTable("setup");
}
