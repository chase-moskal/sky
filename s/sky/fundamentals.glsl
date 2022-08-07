
vec3 getViewDirectionToPixel() {
	return -normalize(cameraPosition - v_worldPosition.xyz);
}

float getClocktime() {
	return mod(time, EARTH_ROTATION_PERIOD) / EARTH_ROTATION_PERIOD;
}
