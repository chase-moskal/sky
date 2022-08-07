
float calculateRadiansToHorizon(vec3 vector) {
	return (vector.y == 1.0)
		? PIHALF
		: (vector.y == 0.0)
			? 0.0
			: acos(dot(
				vector,
				normalize(vec3(
					vector.x,
					0.0,
					vector.z
				))
			));
}

vec3 sampleNoon(float radiansFromSun, float radiansFromHorizon) {
	float factor = gradient(radiansFromHorizon, FloatStop[3](
		FloatStop(0.0, 0.0),
		FloatStop(PIQUARTER, 0.5),
		FloatStop(PIHALF, 1.0)
	));
	return vec3(1.0);
}

vec3 sampleSunset(float radiansFromSun, float radiansFromHorizon) {
	float factor = gradient(radiansFromHorizon, FloatStop[3](
		FloatStop(0.0, 0.0),
		FloatStop(PIQUARTER, 0.5),
		FloatStop(PIHALF, 1.0)
	));
	return vec3(1.0, 0.0, 0.0);
}

vec3 sampleDaySky(
		float radiansFromSun,
		float radiansFromHorizon,
		float sunRadiansFromHorizon
	) {
	float factor = gradient(sunRadiansFromHorizon, FloatStop[3](
		FloatStop(0.0, 1.0),
		FloatStop(PIHALF * .1, 0.0),
		FloatStop(PIHALF, 0.0)
	));
	return mix(
		sampleNoon(radiansFromSun, radiansFromHorizon),
		sampleSunset(radiansFromSun, radiansFromHorizon),
		factor
	);
}
