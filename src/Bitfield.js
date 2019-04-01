/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
class Bitfield {
  constructor(type, flags) {
    this.type = type;
    if (flags == null) { flags = []; }
    this.flags = flags;
  }
  decode(stream) {
    const val = this.type.decode(stream);

    const res = {};
    for (let i = 0; i < this.flags.length; i++) {
      const flag = this.flags[i];
      if (flag != null) {
        res[flag] = !!(val & (1 << i));
      }
    }

    return res;
  }

  size() {
    return this.type.size();
  }

  encode(stream, keys) {
    let val = 0;
    for (let i = 0; i < this.flags.length; i++) {
      const flag = this.flags[i];
      if (flag != null) {
        if (keys[flag]) { val |= (1 << i); }
      }
    }

    return this.type.encode(stream, val);
  }
}

module.exports = Bitfield;
