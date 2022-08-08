
#import ../tools/clouds.glsl
#import ../tools/gradients.glsl
#import ../tools/triplanar.glsl
#import ../tools/white-noise.glsl

float makeStarLayer(vec3 direction, float frequency, float intensity){
	float threshold = 1.0 - intensity;
	float noise = noise(direction * frequency);
	return (noise < threshold)
		? 0.0
		: remap(noise, vec2(threshold, 1.0), vec2(0.0, 1.0));
}

vec3 makeStarField(vec3 direction, float twinkle){
	vec3 colornoise = vec3(
		whiteNoise(0.3, 1.0),
		whiteNoise(0.3, 2.0),
		whiteNoise(0.3, 3.0)
	);
	vec3 rawstars = vec3(
		makeStarLayer(direction, 50.0, .1)
		+ makeStarLayer(direction, 100.0, .05)
		- (colornoise * twinkle)
	);
	return clamp(rawstars, 0.0, 1.0);
}

vec3 makeNebula(vec3 direction){
	float cloudnoise = triplanar(direction, vec3(
		clouds(direction.zy * 5.0),
		clouds(direction.xz * 5.0),
		clouds(direction.xy * 5.0)
	));
	return vec3(
		gradient(cloudnoise, FloatStop[3](
			FloatStop(0.0, 0.0),
			FloatStop(0.5, 0.0),
			FloatStop(1.0, 0.3)
		)),
		gradient(cloudnoise, FloatStop[3](
			FloatStop(0.0, 0.0),
			FloatStop(0.5, 0.1),
			FloatStop(1.0, 0.0)
		)),
		gradient(cloudnoise, FloatStop[3](
			FloatStop(0.0, 0.1),
			FloatStop(0.5, 0.2),
			FloatStop(1.0, 0.7)
		))
	);
}

vec3 sampleNightSky(vec3 view) {
	vec3 starfield = makeStarField(view, 0.15);
	vec3 nebula = makeNebula(view) * 0.05;
	return starfield + nebula;
}
