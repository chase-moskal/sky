
struct FloatStop {
	float position;
	float content;
};

struct ColorStop {
	float position;
	vec3 content;
};

float gradient(float value, FloatStop[3] stops) {
	FloatStop left;
	FloatStop right;
	if (value < stops[1].position) {
		left = stops[0];
		right = stops[1];
	}
	else {
		left = stops[1];
		right = stops[2];
	}
	float span = right.position - left.position;
	float progress = value - left.position;
	float factor = progress / span;
	return mix(left.content, right.content, factor);
}

vec3 gradient(float value, ColorStop[3] stops) {
	ColorStop left;
	ColorStop right;
	if (value < stops[1].position) {
		left = stops[0];
		right = stops[1];
	}
	else {
		left = stops[1];
		right = stops[2];
	}
	float span = right.position - left.position;
	float progress = value - left.position;
	float factor = progress / span;
	return mix(left.content, right.content, factor);
}
