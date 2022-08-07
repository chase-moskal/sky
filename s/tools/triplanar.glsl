
float triplanar(vec3 normal, vec3 samples){
	float nyfactor = abs(dot(normal, vec3(0.0, 1.0, 0.0)));
	float nzfactor = abs(dot(normal, vec3(0.0, 0.0, 1.0)));
	float biplanar = mix(samples.x, samples.y, nyfactor);
	return mix(biplanar, samples.z, nzfactor);
}
