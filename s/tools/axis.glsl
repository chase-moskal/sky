
@import ./numerology.glsl;

struct Firmament {
	vec3 view;
	mat4 viewTransform;
	mat4 domeTransform;
};

vec3 drawCircle(vec3 direction, float radius, vec3 vector) {
	float between = radiansBetween(direction, vector);
	return (between < radius)
		? vec3(1.0)
		: vec3(0.0);
}

vec3 drawBelowHorizon(vec3 direction) {
	return (direction.y < 0.0)
		? vec3(1.0)
		: vec3(0.0);
}

vec3 calculateSunBase(float clocktime) {
	vec3 up = vec3(0.0, 1.0, 0.0);
	vec3 east = vec3(1.0, 0.0, 0.0);
	float seasonalInfluence = sin(SEASON * PI2);
	float seasonalOffset = seasonalInfluence * EARTH_AXIAL_TILT;
	return applyTransform(rotation3d(up, -seasonalOffset), east);
}

Firmament calculateFirmamentTransforms(vec3 direction, float clocktime) {
	float circle = clocktime * PI2;

	mat4 swivelTransform = rotation3d(NORTH, circle);
	mat4 longitudeTransform = rotation3d(EAST, LONGITUDE);

	mat4 reverseSwivelTransform = rotation3d(NORTH, -circle);
	mat4 reverseLongitudeTransform = rotation3d(EAST, -LONGITUDE);

	mat4 viewTransform = swivelTransform * longitudeTransform;
	mat4 domeTransform = reverseSwivelTransform * reverseLongitudeTransform;

	vec3 view = applyTransform(viewTransform, direction);

	return Firmament(
		view,
		viewTransform,
		domeTransform
	);
}
