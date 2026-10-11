declare module 'restructure' {
  export class DecodeStream {
    buffer: Buffer;
    view: DataView;
    pos: number;

    constructor(buffer: Buffer);

    readString(length: number, encoding = 'ascii'): Buffer;
    readBuffer(length: number): Buffer;
    // TODO: other read... methods
  }

  export class EncodeStream {
    buffer: Buffer;
    view: DataView;
    pos: number;
    length: number;

    constructor(buffer: Buffer);

    writeBuffer(buffer: Buffer): void;
    writeString(string: string, encoding = 'ascii'): void;
    // TODO: other write... methods

    fill(val: Buffer, length: number);
  }

  class Base<T> {
    constructor(...args: any);
    fromBuffer(buffer: Buffer): T;
    toBuffer(value: T): Buffer;

    decode(stream: r.DecodeStream): T;
    encode(stream: r.EncodeStream, val: T): void;
    size(): number;
  }
  export type BaseType<T> = typeof Base<T>;

  class BufferT extends Base<Buffer> {}
  export { BufferT as Buffer };

  type BaseOf<T> = T extends Base<infer U> ? U : never;

  export type LengthArray<T, N, R extends T[] = []> = N extends number
    ? number extends N
      ? T[]
      : R['length'] extends N
      ? R
      : LengthArray<T, N, [T, ...R]>
    : T[];

  // TODO: Fix array fo structs with computed properties type
  export class Array<T, N extends number | string> extends Base<
    LengthArray<BaseOf<T>, N>
  > {
    type: T;
    length?: N;
    lengthType?: 'count' | 'bytes';

    constructor(type: T, length?: N, lengthType?: 'count' | 'bytes');
  }
  export class Bitfield<T extends Record<string, boolean>> extends Base<T> {}

  export class Boolean extends Base<boolean> {}

  export class Enum<T extends readonly string[]> extends Base<
    T[number] | number
  > {
    constructor(type: Base<number>, options: T);
  }

  export class LazyArray<T> extends Base<T[]> {}

  class NumberT extends Base<number> {}
  export { NumberT as Number };

  export class Fixed extends Number<number> {}

  export class Optional<T> extends Base<T | undefined> {
    constructor(type: Base<T>, condition?: boolean);
  }

  export class Pointer extends Base<unknown> {}

  export class VoidPointer {
    constructor(type: any, value: any);
  }

  export class Reserved extends Base<never> {}

  class StringT extends Base<string> {}
  export { StringT as String };

  export type StructType<T extends Record<string, unknown>> = {
    [K in keyof T]: T[K] extends Base<infer U>
      ? U
      : T[K] extends () => infer V
      ? V
      : T[K];
  };

  export type StructFields<T extends Record<string, unknown>> = {
    [K in keyof T]: T[K] extends (...args: any[]) => infer V
      ? (
          this: StructType<Omit<T, K>>,
          ctx: StructType<Omit<T, K>>,
          parent: unknown
        ) => V
      : T[K];
  };

  type StructToBuffer<T extends Record<string, unknown>> = StructType<{
    [K in keyof T as T[K] extends () => unknown ? never : K]: T[K];
  }>;

  export class Struct<T extends Record<string, unknown>> extends Base<
    StructType<T>
  > {
    fields: StructFields<T>;
    constructor(fields: StructFields<T>);

    toBuffer(struct: StructToBuffer<T>): Buffer;
  }

  export class VersionedStruct extends Base<unknown> {}

  export const uint8: NumberT;
  export const uint16be: NumberT;
  export const uint16 = uint16be;
  export const uint16le: NumberT;
  export const uint24be: NumberT;
  export const uint24 = uint24be;
  export const uint24le: NumberT;
  export const uint32be: NumberT;
  export const uint32 = uint32be;
  export const uint32le: NumberT;
  export const int8: NumberT;
  export const int16be: NumberT;
  export const int16 = int16be;
  export const int16le: NumberT;
  export const int24be: NumberT;
  export const int24 = int24be;
  export const int24le: NumberT;
  export const int32be: NumberT;
  export const int32 = int32be;
  export const int32le: NumberT;
  export const floatbe: NumberT;
  export const float = floatbe;
  export const floatle: NumberT;
  export const doublebe: NumberT;
  export const double = doublebe;
  export const doublele: NumberT;
}
