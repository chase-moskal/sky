
@import ./noise.glsl;

// clouds
// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd

float random (in vec2 st) {
	return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float cloudnoise (in vec2 st) {
	vec2 i = floor(st);
	vec2 f = fract(st);

	// Four corners in 2D of a tile
	float a = random(i);
	float b = random(i + vec2(1.0, 0.0));
	float c = random(i + vec2(0.0, 1.0));
	float d = random(i + vec2(1.0, 1.0));

	vec2 u = f * f * (3.0 - 2.0 * f);

	return mix(a, b, u.x) +
		(c - a)* u.y * (1.0 - u.x) +
		(d - b) * u.x * u.y;
}

//fractal brownian motion
#define FRACTAL_BROWNIAN_MOTION_OCTAVES 6
float clouds(in vec2 st) {
	// Initial values
	float value = 0.0;
	float amplitude = .5;
	float frequency = 0.;
	//
	// Loop of octaves
	for (int i = 0; i < FRACTAL_BROWNIAN_MOTION_OCTAVES; i++) {
		value += amplitude * cloudnoise(st);
		st *= 2.;
		amplitude *= .5;
	}
	return value;
}
