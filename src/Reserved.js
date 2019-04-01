/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
const utils = require('./utils');

class Reserved {
  constructor(type, count) {
    this.type = type;
    if (count == null) { count = 1; }
    this.count = count;
  }
  decode(stream, parent) {
    stream.pos += this.size(null, parent);
    return undefined;
  }

  size(data, parent) {
    const count = utils.resolveLength(this.count, null, parent);
    return this.type.size() * count;
  }

  encode(stream, val, parent) {
    return stream.fill(0, this.size(val, parent));
  }
}

module.exports = Reserved;
