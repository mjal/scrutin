const { DataTypes } = require('sequelize')

module.exports = function (sequelize) {

  const Event = sequelize.define('Event', {
    type_: {
      type: DataTypes.STRING
    },
    content: {
      type: DataTypes.TEXT
    },
    cid: {
      type: DataTypes.TEXT
    },
    publicKey: {
      type: DataTypes.TEXT
    },
    signature: {
      type: DataTypes.TEXT
    }
  }, {})

  return {
    Event,
  }
}
