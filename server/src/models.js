const { Sequelize, DataTypes } = require('sequelize');

module.exports = function(sequelize) {
  const Event = sequelize.define('Event', {
    content: {
      type: DataTypes.STRING,
    },
    contentHash: {
      type: DataTypes.STRING,
    },
    publicKey: {
      type: DataTypes.STRING,
    },
    signature: {
      type: DataTypes.STRING,
    },
  }, {});

  const Election = sequelize.define('Election', {
    eventHash: {
      type: DataTypes.STRING,
    },
    orgPublicKey: {
      type: DataTypes.STRING,
    }
  }, {});

  const Ballot = sequelize.define('Ballot', {
    eventHash: {
      type: DataTypes.STRING,
    },
    orgPublicKey: {
      type: DataTypes.STRING,
    },
    userPublicKey: {
      type: DataTypes.STRING,
    },
    ciphertext: {
      type: DataTypes.STRING,
    }
  }, {});

  const Key = sequelize.define('Key', {
    publicKey: {
      type: DataTypes.STRING,
    },
    privateKey: {
      type: DataTypes.STRING,
    }
  }, {})

  return {
    Event,
    Election,
    Ballot
  }
}