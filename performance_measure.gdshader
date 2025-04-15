shader_type canvas_item;
render_mode blend_mix;

#include "res://uint-hash.gdshaderinc"

//-------------------------------------------------------------------------
// Configuration Constants
//-------------------------------------------------------------------------
#define ITERATIONS 1
#define HASH_MODE 1 // 0: Default Sine Hash (2 in 1 out), 1: Uint Hash (2 in 1 out), 2: Sine Hash (hashOld33) (3 in 3 out), 3: Uint Hash (3 in 3 out)

const float GOLDEN_RATIO = 1.618033988749895;
const vec3 UV_SCALE = vec3(1.0);
const vec3 UV_OFFSET = vec3(0.0, 0.0, 0.0);
const vec3 STEP_OFFSET = vec3(GOLDEN_RATIO);
const float INV_ITERATIONS = 1.0 / float(ITERATIONS);

//-------------------------------------------------------------------------
// Simple Sine Hash Function (2 in 1 out)
//-------------------------------------------------------------------------
float sineHash(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

//-------------------------------------------------------------------------
// hashOld33 Function
// Hash without Sine (MIT License - David Hoskins, 2014)
// https://www.shadertoy.com/view/4djSRW
//-------------------------------------------------------------------------
vec3 hashOld33(vec3 p) {
	p = vec3( dot(p,vec3(127.1,311.7, 74.7)),
			  dot(p,vec3(269.5,183.3,246.1)),
			  dot(p,vec3(113.5,271.9,124.6)));
	return fract(sin(p)*43758.5453123);
}

//-------------------------------------------------------------------------
// Generic Hash Function
//-------------------------------------------------------------------------
vec3 genericHash(in highp vec3 pos) {
#if HASH_MODE == 0:
	return vec3(sineHash(pos.xy));
#elif HASH_MODE == 1:
	return vec3(uintTo01Float(uintHashVec2ToFloat(pos.xy)));
#elif HASH_MODE == 2:
	return hashOld33(pos);
#elif HASH_MODE == 3:
	return uvec3To01Vec3(uintHashVec3ToVec3(pos));
#else
	return vec3(0.0); // Fallback
#endif
}

//-------------------------------------------------------------------------
// Main Fragment Function
//-------------------------------------------------------------------------
void fragment() {
	vec2 uv = UV * 2.0 - 1.0;
	vec3 pos = vec3(uv, 0.0) * UV_SCALE + UV_OFFSET;
	//pos = vec3(SCREEN_UV / SCREEN_PIXEL_SIZE, 0.0); // Screen coordinates break the sine hash
	vec3 noise_result = genericHash(pos);

	vec3 noise_sum = vec3(0.0);
	for (int i = 1; i < ITERATIONS; i++) {
		pos = vec3(uv, 0.0) * UV_SCALE + float(i) * STEP_OFFSET + UV_OFFSET;
		noise_sum += genericHash(pos) * INV_ITERATIONS;
	}

	vec3 color = noise_result + noise_sum * 0.00001;

	COLOR = vec4(color, 1.0);
}
