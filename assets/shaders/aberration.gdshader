shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 offset = (uv - 0.5) * 2.0;
	offset *= pow(length((uv - 0.5) * 2.0), 0.9) + 1.0;
	offset *= SCREEN_PIXEL_SIZE;
	
	float r, g, b;
	r = texture(screen_texture, uv + offset).r;
	g = texture(screen_texture, uv).g;
	b = texture(screen_texture, uv - offset).b;
	COLOR = vec4(r, g, b, 1.0);
}
