
#import ../tools/numerology.glsl
#import ../tools/gradients.glsl

struct Skypoint {
	float radiansFromSun;
	float radiansFromHorizon;
	float sunRadiansFromHorizon;
};

Skypoint getSkypoint(vec3 direction, vec3 sunVector) {
	return Skypoint(
		radiansBetween(sunVector, direction),
		radiansFromHorizon(direction),
		radiansFromHorizon(sunVector)
	);
}

vec3 sampleNoon(Skypoint point) {
	float distanceFromHorizon = abs(point.radiansFromHorizon) / PIHALF;
	vec3 baseSkyColor = gradient(distanceFromHorizon, ColorStop[3](
		ColorStop(0.0, vec3(0.78, 0.90, 1.00)),
		ColorStop(0.2, vec3(0.36, 0.72, 1.00)),
		ColorStop(1.0, vec3(0.00, 0.56, 1.00))
	));
	float sunGlareBig = 0.8 * gradient(point.radiansFromSun, FloatStop[3](
		FloatStop(0.0, 1.0),
		FloatStop(1.5, 0.0),
		FloatStop(PI, 0.0)
	));
	float sunGlareSmall = 0.5 * gradient(point.radiansFromSun, FloatStop[3](
		FloatStop(0.0, 1.0),
		FloatStop(0.3, 0.0),
		FloatStop(PI, 0.0)
	));
	float sunGlare = sunGlareBig + sunGlareSmall;
	vec3 sunDisk = point.radiansFromSun < SUN_RADIUS
		? vec3(1.0)
		: vec3(0.0);
	return mix(baseSkyColor, vec3(1.0), sunGlare) + sunDisk;
}

vec3 sampleSunset(Skypoint point) {
	float distanceFromHorizon = abs(point.radiansFromHorizon) / PIHALF;
	vec3 baseColor = gradient(distanceFromHorizon, ColorStop[3](
		ColorStop(0.0, vec3(1.00, 0.48, 0.00)),
		ColorStop(0.1, vec3(0.38, 0.44, 0.56)),
		ColorStop(1.0, vec3(0.14, 0.19, 0.45))
	));
	vec3 sunsetColor = gradient(distanceFromHorizon, ColorStop[3](
		ColorStop(0.0, vec3(1.00, 0.48, 0.00)),
		ColorStop(0.2, vec3(0.66, 0.00, 1.00)),
		ColorStop(1.0, vec3(0.42, 0.36, 0.75))
	));
	vec3 color = mix(sunsetColor, baseColor, gradient(point.radiansFromSun, FloatStop[3](
		FloatStop(0.0, 0.0),
		FloatStop(PIHALF, 0.8),
		FloatStop(PI, 1.0)
	)));
	float sunGlareBig = 0.7 * gradient(point.radiansFromSun, FloatStop[3](
		FloatStop(0.0, 1.0),
		FloatStop(1.5, 0.0),
		FloatStop(PI, 0.0)
	));
	float sunGlareSmall = 0.25 * gradient(point.radiansFromSun, FloatStop[3](
		FloatStop(0.0, 1.0),
		FloatStop(0.3, 0.0),
		FloatStop(PI, 0.0)
	));
	float sunGlare = sunGlareBig + sunGlareSmall;
	vec3 sunDisk = point.radiansFromSun < SUN_RADIUS
		? vec3(1.0)
		: vec3(0.0);
	return mix(color, vec3(1.0, 1.0, 0.5), sunGlare) + sunDisk;
}

vec3 sampleDaySky(Skypoint point) {
	float factor = gradient(abs(point.sunRadiansFromHorizon), FloatStop[3](
		FloatStop(0.0, 1.0),
		FloatStop(PIHALF * .3, 0.0),
		FloatStop(PIHALF, 0.0)
	));
	return mix(
		sampleNoon(point),
		sampleSunset(point),
		clamp(factor, 0.0, 1.0)
	);
}
