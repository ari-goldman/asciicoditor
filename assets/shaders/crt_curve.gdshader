// https://babylonjs.medium.com/retro-crt-shader-a-post-processing-effect-study-1cb3f783afbc

shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

vec2 remap_uv(vec2 uv){
	vec2 curvature = vec2(4.0, 4.0);
	uv = 2.0 * uv - 1.0;
	vec2 offset = abs(uv.yx) / curvature;
	uv = uv + uv * offset * offset;
	uv = uv * 0.5 + 0.5;
	return uv;
}

void fragment() {
	vec3 col = texture(screen_texture, SCREEN_UV).rgb;
	
	vec2 new_uv = remap_uv(SCREEN_UV);
	if(new_uv.x < 0.0 || new_uv.y < 0.0 || new_uv.x > 1.0 || new_uv.y > 1.0){
		col = vec3(0.0);
	}else{
		col = texture(screen_texture, new_uv).rgb;
	}

	
	
	
	COLOR = vec4(col, 1.0);
}
