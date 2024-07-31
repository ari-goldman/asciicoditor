shader_type canvas_item;

//void vertex() {
	//// Called for every vertex the material is visible on.
//}
#define RANGE 3
#define GAUSS_SIGMA 1.0

uniform sampler2D screen_texture : hint_screen_texture;

float gaussian(vec2 x, float sigma) {
	return 0.3989423*exp(-0.5*dot(x,x)/(sigma*sigma)) / sigma;
}

void fragment() {
	float weight;
	float weight_sum = 0.0;
	vec3 color_sum = vec3(0.0);
	vec2 texel = 1.0 / vec2(textureSize(screen_texture, 0));
	
	for(int xx = -RANGE; xx <= RANGE; xx++){
		for(int yy = -RANGE; yy <= RANGE; yy++){
			weight = gaussian(vec2(float(xx), float(yy)), GAUSS_SIGMA);
			color_sum += texture(screen_texture, SCREEN_UV + (texel * vec2(float(xx), float(yy)))).rgb * weight;
			weight_sum += weight;
		}
	}
	//COLOR = texture(screen_texture, SCREEN_UV) * gaussian(vec2(2.0), GAUSS_SIGMA);
	COLOR = vec4(color_sum / weight_sum, 1.0);
	//COLOR = texture(screen_texture, SCREEN_UV + (SCREEN_PIXEL_SIZE * sin(SCREEN_UV.x * TAU * 5.0 + TIME) * 3.0));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
