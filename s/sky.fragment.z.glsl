
precision highp float;

uniform float time;
uniform vec3 cameraPosition;

uniform sampler2D myTexture;

varying vec2 v_uv;
varying vec3 v_position;
varying vec4 v_worldPosition;

#import sky/defines.glsl
#import sky/fundamentals.glsl
#import sky/firmament.glsl
#import sky/sun.glsl
#import sky/night-sky.glsl
#import sky/day-sky.glsl
#import sky/composite-full-sky.glsl

#import tools/drawing.glsl
#import tools/gradients.glsl
#import tools/numerology.glsl

void main() {
	vec3 direction = getViewDirectionToPixel();
	float clocktime = getClocktime();

	Firmament firmament = calculateFirmamentTransforms(direction, clocktime);

	vec3 sunBase = calculateSunBase(clocktime);
	vec3 sunVector = applyTransform(firmament.domeTransform, sunBase);
	vec3 sunDisk = drawCircle(direction, SUN_RADIUS, sunVector);

	vec3 nightSky = sampleNightSky(firmament.view);

	Skypoint skypoint = getSkypoint(direction, sunVector);
	vec3 daySky = sampleDaySky(skypoint);

	vec3 fullSky = compositeFullSky(skypoint, nightSky, daySky);

	vec3 debugSunDisk = drawCircle(direction, 0.05, sunVector) * RED;
	vec3 debugHorizon = drawBelowHorizon(direction) * 0.1;
	vec3 debugEastMarker = drawCircle(direction, 0.05, EAST) * GREEN;

	// vec3 composite = nightSky + debugSunDisk - debugHorizon;
	vec3 composite = fullSky - debugHorizon;
	gl_FragColor = vec4(composite, 1.0);
}
