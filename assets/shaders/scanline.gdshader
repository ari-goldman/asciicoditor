shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec3 col = texture(screen_texture, SCREEN_UV).rgb;
	if(int(SCREEN_UV.y / SCREEN_PIXEL_SIZE.y) % 2 == 0){
		col *= sin(SCREEN_UV.y * 3.7481 * TIME) * 0.1 + 0.75;
	}
	
	COLOR = vec4(col, 1.0);
}
