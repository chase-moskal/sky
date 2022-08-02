float makeStarLayer(vec3 direction, float frequency, float intensity){
	float threshold = 1.0 - intensity;
	float noise = snoise(direction * frequency);
	if (noise < threshold){
		return 0.0;
	}
	else {
		return remap(noise, vec2(threshold, 1.0), vec2(0.0, 1.0));
	}
}

vec3 makeStarField(vec3 direction, float twinkle){
    vec3 colornoise = vec3(
		whiteNoise(0.3, 1.0),
		whiteNoise(0.3, 2.0),
		whiteNoise(0.3, 3.0)
	);
    vec3 rawstars = vec3(
		makeStarLayer(direction, 125.0, .12) 
		+ makeStarLayer(direction, 150.0, .2)
		- (colornoise * twinkle)
	);
    return clamp(rawstars, 0.0, 1.0);
}

vec3 computeSkyDirection(vec3 direction){
	float skytime = mod(time, EARTH_ROTATION_PERIOD) / EARTH_ROTATION_PERIOD;
	float skyradians = skytime * PI2;
	mat4 skyrotate = rotation3d(vec3(0.0, 1.0, 0.0), skyradians);
	return (skyrotate * vec4(direction, 1.0)).xyz;
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