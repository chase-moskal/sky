
float randy(vec2 p) {
	vec2 K1 = vec2(23.14069263277926, 2.665144142690225);
	return fract(cos(dot(p,K1)) * 12345.6789);
}

float whiteNoise(float resolution, float offset) {
	return randy((floor(gl_FragCoord.xy * resolution) + offset) * mod(time / 10000.0, 1.0));
}
