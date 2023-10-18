shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform vec2 scale = vec2(0.43, 0.17);
uniform float y_zoom = 4.7;

uniform vec4 water_color : source_color = vec4(0.31, 0.71, 0.78, 0.71);

uniform sampler2D noise : repeat_enable;
uniform vec2 distortion_scale = vec2(0.29, 0.65);
uniform float distortion_intensity : hint_range(0, 0.1) = 0.02;
uniform float time_scale : hint_range(0, 1) = 0.09;
uniform float water_transparency : hint_range(0, 1) = 0.824;

void fragment() {
	float distortion = texture(noise, UV * scale * distortion_scale + TIME * time_scale).x;
	distortion -= 0.5;
	float uv_height = SCREEN_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.y;
	float reflected_x = SCREEN_UV.x - distortion * distortion_intensity * y_zoom;
	float reflected_y = SCREEN_UV.y - uv_height * UV.y * scale.y * y_zoom * 2.0;
	vec2 reflected_screen_uv = vec2(reflected_x, reflected_y);
	vec4 reflection = texture(SCREEN_TEXTURE, reflected_screen_uv);
	vec3 rgb = mix(reflection.rgb, water_color.rgb, water_color.a);
	COLOR = vec4(rgb, water_transparency);
}
