import { Knex } from "knex";

export async function up(knex: Knex): Promise<void> {
  await knex.schema.createTable("encryptedTally", (table) => {
    table.increments("id").primary(); // Auto-increment ID
    table.uuid("uuid").notNullable(); // Foreign key to setup
    table.json("encryptedTally").notNullable(); // Encrypted tally data
    table.timestamps(true, true); // created_at and updated_at
  });
}

export async function down(knex: Knex): Promise<void> {
  await knex.schema.dropTable("encryptedTally");
}
