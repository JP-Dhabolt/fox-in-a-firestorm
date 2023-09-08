shader_type canvas_item;

uniform float speed = 0.2;
uniform float frequency = 50.0;
uniform float amplitude = 0.5;

void fragment() {
	vec2 uv = SCREEN_UV;
	float time = TIME * speed;

	// Create a water ripple effect
	float wave1 = sin(uv.x * frequency + time) * amplitude;
	float wave2 = cos(uv.y * frequency + time) * amplitude;
	uv += wave1 + wave2;

	// Generate constantly changing pastel colors using a gradient
	vec3 color1 = vec3(0.5 + 0.05 * sin(time), 0.7 + 0.05 * cos(time), 0.92 - 0.1 * sin(time));
	vec3 color2 = vec3(0.5 - 0.05 * cos(time), 0.7 + 0.05 * sin(time), 0.92 + 0.08 * cos(time));
	vec3 gradient_color = mix(color1, color2, uv.y);

	COLOR = vec4(gradient_color, 1.0);
}
