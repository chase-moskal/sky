float easeExpo(float x){
	if (x == 0.0){
		return 0.0;
	}
	else {
		if (x == 1.0){
			return 1.0;
		}
		else  {
			if (x < 0.5){
				return pow(2.0, (20.0 * x) - 10.0) / 2.0;
			}
			else {
				return (2.0 - pow(2.0, (-20.0 * x) + 10.0)) / 2.0;
			}
		}
	}
}

float easeSharpExpo(float x){
	if (x == 0.0){
		return 0.0;
	}
	else {
		return pow(2.0, (10.0 * x) - 10.0);
	}
}