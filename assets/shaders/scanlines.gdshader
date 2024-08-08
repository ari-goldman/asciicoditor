shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	int row = int(SCREEN_UV.y / SCREEN_PIXEL_SIZE.y);
	vec3 col = texture(screen_texture, SCREEN_UV).xyz;
	if(row % 3 == 2){
		col *= 0.7;
	}
	COLOR = vec4(col, 1.0);
}
