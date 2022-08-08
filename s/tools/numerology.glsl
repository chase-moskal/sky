
float radiansBetween(vec3 a, vec3 b) {
	return acos(dot(a, b));
}

float radiansFromHorizon(vec3 vector) {
	return PIHALF - radiansBetween(UP, vector);
}

vec2 rotate2d(vec2 v, float a) {
	float s = sin(a);
	float c = cos(a);
	mat2 m = mat2(c, -s, s, c);
	return m * v;
}

mat4 rotation3d(vec3 axis, float angle) {
	axis = normalize(axis);
	float s = sin(angle);
	float c = cos(angle);
	float oc = 1.0 - c;
	return mat4(
		oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
		oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
		oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
		0.0,                                0.0,                                0.0,                                1.0
	);
}

vec3 applyTransform(mat4 transform, vec3 vector) {
	return (transform * vec4(vector, 1.0)).xyz;
}

float remap(float point, vec2 inrange, vec2 outrange){
	float difference = inrange.y - inrange.x;
	float progress = point - inrange.x;
	float fraction = progress / difference;
	float outdifference = outrange.y - outrange.x;
	float outprogress = outdifference * fraction;
	return outrange.x + outprogress;
}

vec3 remap3(vec3 point, vec2 inrange, vec2 outrange){
	float x = remap(point.x, inrange, outrange);
	float y = remap(point.y, inrange, outrange);
	float z = remap(point.z, inrange, outrange);
	return vec3(x, y, z);
}
