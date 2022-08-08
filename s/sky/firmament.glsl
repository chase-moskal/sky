
#import ../tools/numerology.glsl

struct Firmament {
	vec3 view;
	mat4 viewTransform;
	mat4 domeTransform;
};

Firmament calculateFirmamentTransforms(vec3 direction, float clocktime) {
	float circle = clocktime * PI2;

	mat4 swivelTransform = rotation3d(NORTH, circle);
	mat4 longitudeTransform = rotation3d(EAST, LONGITUDE);

	mat4 viewTransform = swivelTransform * longitudeTransform;
	mat4 domeTransform = inverse(viewTransform);

	// mat4 reverseSwivelTransform = rotation3d(NORTH, -circle);
	// mat4 reverseLongitudeTransform = rotation3d(EAST, -LONGITUDE);
	// mat4 domeTransform = reverseSwivelTransform * reverseLongitudeTransform;

	vec3 view = applyTransform(viewTransform, direction);

	return Firmament(
		view,
		viewTransform,
		domeTransform
	);
}
