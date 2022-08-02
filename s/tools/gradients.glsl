struct FloatStop{
	float position;
	float content;
};

float gradient(float value, FloatStop[3] stops){
	FloatStop leftstop = stops[0];
	FloatStop rightstop = stops[2];
	for(int i = 0; i < 3; i ++){
		FloatStop currentstop = stops[i];
		if(value > currentstop.position && currentstop.position > leftstop.position){
			leftstop = currentstop;
		}
		if(value < currentstop.position && currentstop.position < rightstop.position){
			rightstop = currentstop;
		}
	}
	float span = rightstop.position - leftstop.position;
	float progress = value - leftstop.position;
	float factor = progress / span;
	return mix(leftstop.content, rightstop.content, factor);
}

// float gradient3(float value, FloatStop[3] stops){
// 	GradientFloatStop leftstop = stops[0];
// 	GradientFloatStop rightstop = stops[2];
// 	for(int i = 0; i < 3; i ++){
// 		GradientFloatStop currentstop = stops[i];
// 		if(value > currentstop.position && currentstop.position > leftstop.position){
// 			leftstop = currentstop;
// 		}
// 		if(value < currentstop.position && currentstop.position < rightstop.position){
// 			rightstop = currentstop;
// 		}
// 	}
// 	float span = rightstop.position - leftstop.position;
// 	float progress = value - leftstop.position;
// 	float factor = progress / span;
// 	return mix(leftstop.content, rightstop.content, factor);
// }