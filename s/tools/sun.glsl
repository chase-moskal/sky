
@import ./numerology.glsl;

vec3 calculateSunDirection(float clocktime) {
	float orbitRadians = clocktime * PI2;

	vec3 orbitAxis = vec3(0.0, 0.0, 1.0);
	vec4 startingSunDirection = vec4(1.0, 0.0, 0.0, 1.0);
	mat4 orbitTransform = rotation3d(orbitAxis, orbitRadians);

	mat4 tiltTransform = rotation3d(vec3(1.0, 0.0, 0.0), LONGITUDE);
	vec3 sunDirection = (tiltTransform * orbitTransform * startingSunDirection).xyz;
	vec3 tiltedOrbitAxis = (tiltTransform * vec4(orbitAxis, 1.0)).xyz;
	vec3 sunCross = cross(sunDirection, tiltedOrbitAxis);

	float seasonalInfluence = sin(SEASON * PI2);
	float offset = seasonalInfluence * EARTH_AXIAL_TILT;
	mat4 seasonalTransform = rotation3d(sunCross, -offset);

	return (seasonalTransform * vec4(sunDirection, 1.0)).xyz;
}
