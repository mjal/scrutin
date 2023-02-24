const { DataTypes } = require('sequelize')

module.exports = function (sequelize) {

  const Event_ = sequelize.define('Event', {
    content: {
      type: DataTypes.STRING
    },
    contentHash: {
      type: DataTypes.STRING
    },
    publicKey: {
      type: DataTypes.STRING
    },
    signature: {
      type: DataTypes.STRING
    }
  }, {})

  const Election = sequelize.define('Election', {
    eventHash: {
      type: DataTypes.STRING
    },
    orgPublicKey: {
      type: DataTypes.STRING
    }
  }, {})

  const Ballot = sequelize.define('Ballot', {
    eventHash: {
      type: DataTypes.STRING
    },
    orgPublicKey: {
      type: DataTypes.STRING
    },
    userPublicKey: {
      type: DataTypes.STRING
    },
    ciphertext: {
      type: DataTypes.STRING
    }
  }, {})

  const Organization = sequelize.define('Key', {
    name: { type: DataTypes.STRING },
    publicKey: { type: DataTypes.STRING },
    secretKey: { type: DataTypes.STRING }
  }, {})

  const User = sequelize.define('User', {
    fullName: { type: DataTypes.STRING },
    publicKey: { type: DataTypes.STRING },
    secretKey: { type: DataTypes.STRING },
    email: { type: DataTypes.STRING },
    emailConfirmed: { type: DataTypes.BOOLEAN },
    emailConfirmationToken: { type: DataTypes.STRING },
    phoneNumber: { type: DataTypes.STRING },
    phoneNumberConfirmed: { type: DataTypes.BOOLEAN },
    phoneNumberConfirmationToken: { type: DataTypes.STRING }
  }, {})

  return {
    Event_,
    Election,
    Ballot,
    Organization,
    User
  }
}
