/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = function(knex) {
  return knex.schema
    .createTable('users', function (table) {
      table.text('electionId').notNullable();
      table.text('email').notNullable();
      table.text('managerId');
      table.text('secret');
      table.text('userId');
      table.text('userToken');

      table.unique(['electionId', 'email']);
    })
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = function(knex) {
  return knex.schema
    .dropTableIfExists('users');
};
