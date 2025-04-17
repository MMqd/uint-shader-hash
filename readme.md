# 🎲 uint-shader-hash

Fast, deterministic, and extensible uint-based hash for GLSL and Godot shaders. Provides high-quality, artifact-free randomness that's consistent across platforms, easily scales to any dimension, avoids floating-point issues, and is simple to integrate. Replaces unreliable float-based hashes (like the sine hash) for procedural effects, noise generation, RNG, and more.

Repository for the following MMqd video:

[![A dark-themed code editor showing the snippet `void fragment() { COLOR = vec3(hash(UV)); }`, with `hash(UV)` highlighted in blue and a red arrow pointing at it, and bold white text reading "Broken."](https://img.youtube.com/vi/EmD0wYZZ0Z0/0.jpg)](http://www.youtube.com/watch?v=EmD0wYZZ0Z0 "The Function Every Graphics Programmer Gets Wrong")

---

## ✂️ Quick Copy-Paste

To hash a `vec3` into a random `vec3` of floats in [0, 1):

```glsl
vec3 noise = uvec3To01Vec3(uintHashVec3ToVec3(pos));
```

Paste this setup into your shader:

```glsl
const uint MAGIC_NUMBERS[7] = uint[7](
    0x21f0aaadu, 0x7feb352du, 0x846ca68bu,
    0xd168aaadu, 0xaf723597u, 0x9e485565u, 0xef1d6b47u
);

highp uint fixZero(highp float f) {
    return floatBitsToUint(f + uintBitsToFloat(0x00800000u));
}

highp uint hashUint(highp uint h, highp uint magic) {
    h++; h ^= h >> 16u; h *= magic; return h;
}

highp float uintTo01Float(highp uint h) {
    return uintBitsToFloat((h >> 9u) | floatBitsToUint(1.0)) - 1.0;
}

vec3 uvec3To01Vec3(uvec3 h) {
    return vec3(uintTo01Float(h.x), uintTo01Float(h.y), uintTo01Float(h.z));
}

uvec3 uintHashVec3ToVec3(highp vec3 f) {
    uint fx = fixZero(f.x), fy = fixZero(f.y), fz = fixZero(f.z);
    highp uint h = 3u;
    h = hashUint(h + fx, MAGIC_NUMBERS[0]);
    h = hashUint(h + fy, MAGIC_NUMBERS[1]);
    h = hashUint(h + fz, MAGIC_NUMBERS[2]);
    return uvec3(
        hashUint(h, MAGIC_NUMBERS[0]),
        hashUint(h, MAGIC_NUMBERS[1]),
        hashUint(h, MAGIC_NUMBERS[2])
    );
}
```

---

## 🎲 Seeded RNG Example

Use a `uint` seed (like particle ID or index) to generate deterministic random values:

```glsl
float size  = uintTo01Float(hashUint(id + 1u, MAGIC_NUMBERS[0]));
float speed = uintTo01Float(hashUint(id + 2u, MAGIC_NUMBERS[0]));
float color = uintTo01Float(hashUint(id + 3u, MAGIC_NUMBERS[0]));
```

You can also XOR or increment the seed to generate multiple independent values.

---

For more usage tips, RNG patterns, and customization examples,
**see the comments in [`uint-hash.gdshaderinc`](./uint-hash.gdshaderinc).**

---

## 🪪 License

- This project is licensed under **CC0**.
- The function `hashOld33()` (used solely for performance comparison) is licensed under **MIT** (© 2014 David Hoskins) from [ShaderToy](https://www.shadertoy.com/view/4djSRW).
