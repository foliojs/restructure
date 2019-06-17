let key, val;
exports.EncodeStream    = require('./src/EncodeStream');
exports.DecodeStream    = require('./src/DecodeStream');
exports.Array           = require('./src/Array');
exports.LazyArray       = require('./src/LazyArray');
exports.Bitfield        = require('./src/Bitfield');
exports.Boolean         = require('./src/Boolean');
exports.Buffer          = require('./src/Buffer');
exports.Enum            = require('./src/Enum');
exports.Optional        = require('./src/Optional');
exports.Reserved        = require('./src/Reserved');
exports.String          = require('./src/String');
exports.Struct          = require('./src/Struct');
exports.VersionedStruct = require('./src/VersionedStruct');

const object = require('./src/Number');
for (key in object) {
  val = object[key];
  exports[key] = val;
}

const object1 = require('./src/Pointer');
for (key in object1) {
  val = object1[key];
  exports[key] = val;
}
