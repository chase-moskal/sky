
precision highp float;

uniform float time;
uniform vec3 cameraPosition;

uniform sampler2D myTexture;

varying vec2 v_uv;
varying vec3 v_position;
varying vec4 v_worldPosition;

@import tools/defines.glsl;
@import tools/gradients.glsl;
@import tools/numerology.glsl;
@import tools/noise.glsl;
@import tools/clouds.glsl;
@import tools/white-noise.glsl;
@import tools/easings.glsl;
@import tools/heavens.glsl;
@import tools/atmosphere.glsl;
@import tools/scatter.glsl;

void main(void) {

	vec3 direction = normalize(cameraPosition - v_worldPosition.xyz);
	vec3 skydirection = computeSkyDirection(direction);

	vec3 starfield = makeStarField(skydirection, 0.3);
	vec3 nebula = makeNebula(skydirection);
	
	vec3 skycolor = starfield + nebula;
	
	float suntime = mod(time, 8000.0) / 8000.0;
	float sunradians = suntime * PI2;
	
	vec3 orbitAxis = vec3(0.0, 0.0, 1.0);
	vec4 startingSunDirection = vec4(1.0, 0.0, 0.0, 1.0);
	mat4 orbitTransform = rotation3d(orbitAxis, sunradians);
	
	float seasonalInfluence = sin(SEASON * PI2);
	float offset = seasonalInfluence * EARTH_AXIAL_TILT;
	
	mat4 tiltTransform = rotation3d(vec3(1.0, 0.0, 0.0), LONGITUDE);
	vec3 sunDirection = (tiltTransform * orbitTransform * startingSunDirection).xyz;
	vec3 tiltedOrbitAxis = (tiltTransform * vec4(orbitAxis, 1.0)).xyz;
	vec3 sunCross = cross(sunDirection, tiltedOrbitAxis);
	mat4 seasonalTransform = rotation3d(sunCross, -offset);

	vec3 finalSunDirection = (seasonalTransform * vec4(sunDirection, 1.0)).xyz;

	// vec2 sunorbitalvector = vec2(0.0, 1.0);
	// vec3 sunorbitalaxis = vec3(0.0, 1.0, 1.0);
	// vec3 sunorbitalaxisbase = vec3(1.0, 0.0, 0.0);
	// vec2 sunorbitalperiodrotate2d = rotate2d(sunorbitalvector, sunradians);

	// vec3 matrixY = sunorbitalaxis;
	// vec3 matrixZ = cross(matrixY, sunorbitalaxisbase);
	// vec3 matrixX = cross(matrixZ, matrixY);
	// vec3 matrixmix = (matrixX * sunorbitalperiodrotate2d.x) + (matrixZ * sunorbitalperiodrotate2d.y);
	// vec3 sundirection = normalize(matrixmix);
	
	float sundot2 = dot(-direction, startingSunDirection.xyz);
	float sunacos2 = acos(sundot2);
	float sunlessthan2 = sunacos2 < 0.0047 ? 1.0 : 0.0;
	vec3 suncolordot2 = vec3(sunlessthan2);
	
	float sundot = dot(-direction, finalSunDirection);
	float sunacos = acos(sundot);
	float sunlessthan = sunacos < 0.0047 ? 1.0 : 0.0;
	vec3 suncolordot = vec3(sunlessthan);
	
	float pixelRadiansFromSun = sunacos;
	float pixelRadiansFromHorizon = acos(dot(normalize(vec3(-direction.x, 0.0, -direction.z)), -direction));
	float sunRadiansFromHorizon = acos(dot(normalize(vec3(finalSunDirection.x, 0.0, finalSunDirection.z)), finalSunDirection));
	
	gl_FragColor = vec4(sampleDaySky(pixelRadiansFromSun, pixelRadiansFromHorizon, sunRadiansFromHorizon), 1.0);
	//gl_FragColor = vec4(suncolordot, 1.0);
	
	
	
	// float suntime = mod(time, 60000.0) / 60000.0;
	// float sunradians = clamp(suntime, -2.0, 2.0);
	// vec3 sunposition = normalize(vec3(0.0, sunradians, 1.0));
	// float sundot = dot(vec3(-direction), vec3(sunposition));
	// float sundotcos = acos(sundot);
	// float sunlessthan = sundotcos < 0.0093 ? 1.0 : 0.0;
	// vec3 suncolordot = vec3(sunlessthan);
	



	// vec3 color = atmosphere(
    //     (-direction),                     // normalized ray direction
    //     vec3(0,6372e3,0),               // ray origin
    //     finalSunDirection,                    // position of the sun
    //     22.0,                           // intensity of the sun
    //     6371e3,                         // radius of the planet in meters
    //     6471e3,                         // radius of the atmosphere in meters
    //     vec3(5.5e-6, 13.0e-6, 22.4e-6), // Rayleigh scattering coefficient
    //     21e-6,                          // Mie scattering coefficient
    //     8e3,                            // Rayleigh scale height
    //     1.2e3,                          // Mie scale height
    //     0.758                           // Mie preferred scattering direction
    // );
	// float horizon = direction.y < -0.0 ? 0.0 : 1.0;
    // // Apply exposure.
    // color = 1.0 - exp(-1.0 * color);
	
	// float horizon1 = direction.y < -0.0179 ? 1.0 : 0.0;
	// vec3 horizon2 = mix(color, vec3(1.0, 1.0, 1.0), horizon1);
	// // vec3 horizonfix = color * mix(horizon2, vec3(1.0), 1.06);
	// vec3 horizonfix = color * mix(horizon2, vec3(1.0), 1.06);
	// gl_FragColor = vec4(vec3(color), 1.0);
	// gl_FragColor = vec4(vec3(color + suncolordot), 1.0);

}

