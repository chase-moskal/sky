
#import numerology.glsl;

vec3 drawCircle(vec3 direction, vec3 vector, float radius) {
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
