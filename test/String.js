import assert from 'assert';
import {String as StringT, uint16le, uint8, DecodeStream, Struct} from 'restructure';

describe('String', function() {
  describe('decode', function() {
    it('should decode fixed length', function() {
      const string = new StringT(7);
      assert.equal(string.fromBuffer(Buffer.from('testing')), 'testing');
    });

    it('should decode length from parent key', function() {
      const stream = new DecodeStream(Buffer.from('testing'));
      const string = new StringT('len');
      assert.equal(string.decode(stream, {len: 7}), 'testing');
    });

    it('should decode length as number before string', function() {
      const string = new StringT(uint8);
      assert.equal(string.fromBuffer(Buffer.from('\x07testing')), 'testing');
    });

    it('should decode utf8', function() {
      const string = new StringT(4, 'utf8');
      assert.equal(string.fromBuffer(Buffer.from('🍻')), '🍻');
    });

    for (const encoding of ['utf8', 'utf16le', 'ucs2', 'utf16be']) {
      it(`should round-trip leading U+FEFF in ${encoding} strings`, function() {
        for (const length of [uint8, null]) {
          const string = new StringT(length, encoding);
          const value = '\uFEFFA\uFEFF';
          assert.equal(string.fromBuffer(string.toBuffer(value)), value);
        }
      });
    }

    it('should decode encoding computed from function', function() {
      const string = new StringT(4, function() { return 'utf8'; });
      assert.equal(string.fromBuffer(Buffer.from('🍻')), '🍻');
    });

    it('should decode null-terminated string and read past terminator', function() {
      const stream = new DecodeStream(Buffer.from('🍻\x00'));
      const string = new StringT(null, 'utf8');
      assert.equal(string.decode(stream), '🍻');
      assert.equal(stream.pos, 5);
    });

    it('should decode remainder of buffer when null-byte missing', function() {
      const string = new StringT(null, 'utf8');
      assert.equal(string.fromBuffer(Buffer.from('🍻')), '🍻');
    });

    it('should decode two-byte null-terminated string for utf16le', function() {
      const stream = new DecodeStream(Buffer.from('🍻\x00', 'utf16le'));
      const string = new StringT(null, 'utf16le');
      assert.equal(string.decode(stream), '🍻');
      assert.equal(stream.pos, 6);
    });

    it('should decode remainder of buffer when null-byte missing, utf16le', function() {
      const string = new StringT(null, 'utf16le');
      assert.equal(string.fromBuffer(Buffer.from('🍻', 'utf16le')), '🍻');
    });

    it('should decode x-mac-roman', function() {
      const string = new StringT(null, 'x-mac-roman');
      const buf = new Uint8Array([0x8a, 0x63, 0x63, 0x65, 0x6e, 0x74, 0x65, 0x64, 0x20, 0x63, 0x68, 0x87, 0x72, 0x61, 0x63, 0x74, 0x65, 0x72, 0x73]);
      assert.equal(string.fromBuffer(buf), 'äccented cháracters');
    })
  });

  describe('size', function() {
    it('should use string length', function() {
      const string = new StringT(7);
      assert.equal(string.size('testing'), 7);
    });

    it('should use correct encoding', function() {
      const string = new StringT(10, 'utf8');
      assert.equal(string.size('🍻'), 4);
    });

    it('should use encoding from function', function() {
      const string = new StringT(10, function() { return 'utf8'; });
      assert.equal(string.size('🍻'), 4);
    });

    it('should add size of length field before string', function() {
      const string = new StringT(uint8, 'utf8');
      assert.equal(string.size('🍻'), 5);
    });

    it('should work with utf16be encoding', function() {
      const string = new StringT(10, 'utf16be');
      assert.equal(string.size('🍻'), 4);
    });

    it('should take null-byte into account', function() {
      const string = new StringT(null, 'utf8');
      assert.equal(string.size('🍻'), 5);
    });

    it('should take null-byte into account, utf16le', function() {
      const string = new StringT(null, 'utf16le');
      assert.equal(string.size('🍻'), 6);
    });

    it('should use defined length if no value given', function() {
      const array = new StringT(10);
      assert.equal(array.size(), 10);
    });
  });

  describe('encode', function() {
    it('should encode using string length', function() {
      const string = new StringT(7);
      assert.deepEqual(string.toBuffer('testing'), Buffer.from('testing'));
    });

    it('should encode length as number before string', function() {
      const string = new StringT(uint8);
      assert.deepEqual(string.toBuffer('testing'), Buffer.from('\x07testing'));
    });

    it('should encode length as number before string utf8', function() {
      const string = new StringT(uint8, 'utf8');
      assert.deepEqual(string.toBuffer('testing 😜'), Buffer.from('\x0ctesting 😜', 'utf8'));
    });

    it('should encode utf8', function() {
      const string = new StringT(4, 'utf8');
      assert.deepEqual(string.toBuffer('🍻'), Buffer.from('🍻'));
    });

    it('should encode encoding computed from function', function() {
      const string = new StringT(4, function() { return 'utf8'; });
      assert.deepEqual(string.toBuffer('🍻'), Buffer.from('🍻'));
    });

    it('should encode null-terminated string', function() {
      const string = new StringT(null, 'utf8');
      assert.deepEqual(string.toBuffer('🍻'), Buffer.from('🍻\x00'));
    });

    it('should encode using string length, utf16le', function() {
      const string = new StringT(16, 'utf16le');
      assert.deepEqual(string.toBuffer('testing'), Buffer.from('testing', 'utf16le'));
    });

    it('should encode length as number before string utf16le', function() {
      const string = new StringT(uint16le, 'utf16le');
      assert.deepEqual(string.toBuffer('testing 😜'), Buffer.from('\u0014testing 😜', 'utf16le'));
    });

    it('should encode two-byte null-terminated string for UTF-16', function() {
      const string = new StringT(null, 'utf16le');
      assert.deepEqual(string.toBuffer('🍻'), Buffer.from('🍻\x00', 'utf16le'));
    });
  });
});
