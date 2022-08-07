
@import gradients.glsl;

float factorize(vec3 direction, vec3 axis){
	float ness = dot(direction, axis);
	return gradient(ness, FloatStop[3](
		FloatStop(-1.0, 1.0),
		FloatStop(0.0, 0.0),
		FloatStop(1.0, 1.0)
	));
}

float triplanar(vec3 normal, vec3 samples){
	float nyfactor = factorize(normal, vec3(0.0, 1.0, 0.0));
	float nzfactor = factorize(normal, vec3(0.0, 0.0, 1.0));
	float biplanar = mix(samples.x, samples.y, nyfactor);
	return mix(biplanar, samples.z, nzfactor);
}
