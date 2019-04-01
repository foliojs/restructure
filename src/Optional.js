/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class Optional {
  constructor(type, condition) {
    this.type = type;
    if (condition == null) { condition = true; }
    this.condition = condition;
  }

  decode(stream, parent) {
    let { condition } = this;
    if (typeof condition === 'function') {
      condition = condition.call(parent, parent);
    }

    if (condition) {
      return this.type.decode(stream, parent);
    }
  }

  size(val, parent) {
    let { condition } = this;
    if (typeof condition === 'function') {
      condition = condition.call(parent, parent);
    }

    if (condition) {
      return this.type.size(val, parent);
    } else {
      return 0;
    }
  }

  encode(stream, val, parent) {
    let { condition } = this;
    if (typeof condition === 'function') {
      condition = condition.call(parent, parent);
    }

    if (condition) {
      return this.type.encode(stream, val, parent);
    }
  }
}

module.exports = Optional;
