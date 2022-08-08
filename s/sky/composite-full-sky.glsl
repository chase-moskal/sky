
#import day-sky.glsl

vec3 compositeFullSky(Skypoint skypoint, vec3 nightSky, vec3 daySky) {
	float dayStartSunRadians = -0.3;
	float dayEndSunRadians = 0.0;
	float span = dayEndSunRadians - dayStartSunRadians;
	float progress = (skypoint.sunRadiansFromHorizon - dayStartSunRadians) / span;
	float factor = clamp(progress, 0.0, 1.0);
	return mix(nightSky, daySky, factor);
}
