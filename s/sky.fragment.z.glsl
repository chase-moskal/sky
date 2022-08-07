
precision highp float;

uniform float time;
uniform vec3 cameraPosition;

uniform sampler2D myTexture;

varying vec2 v_uv;
varying vec3 v_position;
varying vec4 v_worldPosition;

@import tools/defines.glsl;
@import tools/triplanar.glsl;
@import tools/gradients.glsl;
@import tools/numerology.glsl;
@import tools/axis.glsl;
@import tools/noise.glsl;
@import tools/clouds.glsl;
@import tools/white-noise.glsl;
@import tools/easings.glsl;
@import tools/heavens.glsl;
@import tools/atmosphere.glsl;
@import tools/scatter.glsl;
@import tools/sun.glsl;

void main() {
	vec3 direction = getViewDirectionToPixel();
	float clocktime = getClocktime();

	Firmament firmament = calculateFirmamentTransforms(direction, clocktime);

	vec3 sunVector = calculateSunBase(clocktime);
	vec3 sunDisk = drawCircle(firmament.view, 0.03, sunVector);

	vec3 nightSky = sampleNightSky(firmament.view);

	vec3 belowHorizon = drawBelowHorizon(direction) * 0.1;
	vec3 eastDebug = drawCircle(direction, 0.05, EAST) * RED;

	vec3 composite = nightSky + eastDebug + sunDisk - belowHorizon;
	gl_FragColor = vec4(composite, 1.0);
}
