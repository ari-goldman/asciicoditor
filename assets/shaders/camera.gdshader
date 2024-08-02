shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float whiteness = 0.0;

void fragment() {
	float clamped_whiteness = clamp(whiteness, 0.0, 1.0);
	vec3 white = vec3(1.0);
	vec3 screen = texture(screen_texture, SCREEN_UV).rgb;
	vec3 final_col = (white * clamped_whiteness) + (screen * (1.0 - clamped_whiteness));
	COLOR = vec4(final_col, 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
