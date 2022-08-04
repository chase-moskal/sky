
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
@import tools/lamenoise.glsl;
@import tools/easings.glsl;
@import tools/heavens.glsl;
@import tools/atmosphere.glsl;

void main(void) {

	vec3 direction = normalize(cameraPosition - v_worldPosition.xyz);
	vec3 skydirection = computeSkyDirection(direction);

	vec3 starfield = makeStarField(skydirection, 0.3);
	vec3 nebula = makeNebula(skydirection);
	
	vec3 skycolor = starfield + nebula;
	
	float suntime = mod(time, 20000.0) / 20000.0;
	float sunclamp = suntime * PI2;
	
	//sun orbit
	vec2 sunorbitalvector = vec2(0.0, 1.0);
	float sunorbitalperiod = sunclamp;
	vec3 sunorbitalaxis = vec3(0.0, 1.0, 1.0);
	vec3 sunorbitalaxisbase = vec3(1.0, 0.0, 0.0);
	vec2 sunorbitalperiodrotate2d = rotate2d(sunorbitalvector, sunorbitalperiod);

	vec3 matrixY = sunorbitalaxis;
	vec3 matrixZ = cross(matrixY, sunorbitalaxisbase);
	vec3 matrixX = cross(matrixZ, matrixY);
	vec3 matrixmix = (matrixX * sunorbitalperiodrotate2d.x) + (matrixZ * sunorbitalperiodrotate2d.y);
	vec3 sundirection = normalize(matrixmix);
	
	
	float sundot = dot(-direction, sundirection);
	float sunacos = acos(sundot);
	float sunlessthan = sunacos < 0.0047 ? 1.0 : 0.0;
	vec3 suncolordot = vec3(sunlessthan);
	
	//gl_FragColor = vec4(suncolordot, 1.0);
	
	
	
	// float suntime = mod(time, 60000.0) / 60000.0;
	// float sunclamp = clamp(suntime, -2.0, 2.0);
	// vec3 sunposition = normalize(vec3(0.0, sunclamp, 1.0));
	// float sundot = dot(vec3(-direction), vec3(sunposition));
	// float sundotcos = acos(sundot);
	// float sunlessthan = sundotcos < 0.0093 ? 1.0 : 0.0;
	// vec3 suncolordot = vec3(sunlessthan);
	



	vec3 color = atmosphere(
        -direction,                     // normalized ray direction
        vec3(0,6372e3,0),               // ray origin
        sundirection,                    // position of the sun
        22.0,                           // intensity of the sun
        6371e3,                         // radius of the planet in meters
        6471e3,                         // radius of the atmosphere in meters
        vec3(5.5e-6, 13.0e-6, 22.4e-6), // Rayleigh scattering coefficient
        21e-6,                          // Mie scattering coefficient
        8e3,                            // Rayleigh scale height
        1.2e3,                          // Mie scale height
        0.758                           // Mie preferred scattering direction
    );

    // Apply exposure.
    color = 1.0 - exp(-1.0 * color);
	
	gl_FragColor = vec4(color + suncolordot, 1.0);

}

