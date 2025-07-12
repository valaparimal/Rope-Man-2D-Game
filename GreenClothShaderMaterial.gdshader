shader_type canvas_item;

uniform vec3 dress_color : source_color  = vec3(0.8, 0.2, 1.0); // Pinkish-purple
uniform float sparkle_speed = 1.0;
uniform float sparkle_density = 20.0;
uniform float sparkle_size = 0.1;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	float t = TIME * sparkle_speed;

	// Estimate brightness
	float brightness = (tex_color.r + tex_color.g + tex_color.b) / 3.0;

	// Dress detection (tweak if needed)
	bool is_dress = (tex_color.r > 0.4 && tex_color.r > tex_color.g && tex_color.b < 0.3 && brightness < 0.6);

	if (is_dress) {
		// Dress tint (preserve shading)
		tex_color.rgb = brightness * dress_color;

		// Sparkle overlay
		vec2 sparkle_uv = UV * sparkle_density;
		sparkle_uv += vec2(sin(t), cos(t)); // Move sparkles

		float sparkle = fract(sin(dot(sparkle_uv, vec2(12.9898,78.233))) * 43758.5453);
		float pulse = sin(t * 10.0 + sparkle * 10.0) * 0.5 + 0.5;

		if (sparkle > 0.95) {
			tex_color.rgb += pulse * sparkle_size;
		}
	}

	COLOR = tex_color;
}
