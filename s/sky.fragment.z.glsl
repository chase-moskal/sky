
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

#import tools/drawing.glsl

void main() {
	vec3 direction = getViewDirectionToPixel();
	float clocktime = getClocktime();

	Firmament firmament = calculateFirmamentTransforms(direction, clocktime);

	vec3 sunVector = calculateSunBase(clocktime);
	vec3 sunDisk = drawCircle(firmament.view, 0.03, sunVector);

	vec3 nightSky = sampleNightSky(firmament.view);

	vec3 debugHorizon = drawBelowHorizon(direction) * 0.1;
	vec3 debugEastMarker = drawCircle(direction, 0.05, EAST) * RED;

	vec3 composite = nightSky + debugEastMarker + sunDisk - debugHorizon;
	gl_FragColor = vec4(composite, 1.0);
}
