
#import numerology.glsl;

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
