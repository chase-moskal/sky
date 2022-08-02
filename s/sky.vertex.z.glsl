
precision highp float;

attribute vec2 uv;
attribute vec3 normal;
attribute vec3 position;

uniform float time;
uniform mat4 world;
uniform mat4 worldViewProjection;

varying vec2 v_uv;
varying vec3 v_position;
varying vec4 v_worldPosition;

void main(void) {
	gl_Position = worldViewProjection * vec4(position, 1.0);
	v_uv = uv;
	v_position = position;
	v_worldPosition = world * vec4(position, 1.0);
}
