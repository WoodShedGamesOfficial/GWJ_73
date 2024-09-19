shader_type canvas_item;

uniform vec3 light_color : source_color;
uniform vec3 dark_color : source_color;

uniform float horizontal_speed : hint_range(-5.0, 5.0, 0.1) = 0.0;
uniform float vertical_speed : hint_range(-5.0, 5.0, 0.1) = 0.5;

uniform float speed_modifier : hint_range(-10.0, 10.0, 0.25) = 1.5;

uniform float wave_strength : hint_range(0.0, 0.2, 0.01) = 0.01;
uniform float wave_speed : hint_range(0.0, 30.0, 0.1) = 5.0;

uniform float emission : hint_range(0.0, 5.0, 0.1) = 2.5;

uniform float noise_edge_1 : hint_range(0.0, 2.0, 0.05) = 0.05;
uniform float noise_edge_2 : hint_range(0.0, 2.0, 0.05) = 0.5;

uniform float light_edge_1 : hint_range(-2.0, 2.0, 0.1) = 0.9;
uniform float light_edge_2 : hint_range(-2.0, 2.0, 0.1) = 1.2;

uniform bool fading = true;
uniform float fade_edge_1 : hint_range(0.0, 2.0, 0.1) = 0.15;
uniform float fade_edge_2 : hint_range(0.0, 2.0, 0.1) = 1.2;


uniform sampler2D noise_tex : repeat_enable;
uniform sampler2D noise_tex2 : repeat_enable;


float soft_light(float base, float blend) {
	float limit = step(0.5, blend);
	return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);
}


void fragment() {
	float noise = texture(noise_tex, vec2(
		UV.x + TIME * (horizontal_speed * speed_modifier),
		UV.y + TIME * (vertical_speed * speed_modifier)
	)).r;
	
	float noise2 = texture(noise_tex2, vec2(
		UV.x + TIME * horizontal_speed,
		UV.y + TIME * vertical_speed
	)).r;
	
	float flames = soft_light(noise, noise2);
	if (fading) flames = soft_light(smoothstep(fade_edge_1, fade_edge_2, UV.y), flames);
	
	
	vec3 col = mix(dark_color, light_color, flames);
	col = mix(col, vec3(1.0), smoothstep(light_edge_1, light_edge_2, UV.y));
	
	vec2 mask_uv = UV;
	mask_uv.x += (1.0 - UV.y) * wave_strength * cos(VERTEX.y * 0.05 + TIME * wave_speed);
	float texture_mask = texture(TEXTURE, mask_uv).a;
	float mask = texture_mask * smoothstep(noise_edge_1, noise_edge_2, UV.y);
	mask = soft_light(mask, flames);
	
	COLOR.rgb = col * emission;
	COLOR.a = mask;
}

