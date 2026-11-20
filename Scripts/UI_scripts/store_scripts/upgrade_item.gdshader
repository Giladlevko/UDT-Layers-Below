shader_type canvas_item;
uniform sampler2D x_tex:source_color, filter_nearest,repeat_enable,hint_anisotropy;
uniform float tiled_amount = 1.0;
varying vec2 vertex_scale;
void vertex() {
	vertex_scale = vec2(length(MODEL_MATRIX[0]), length(MODEL_MATRIX[1]));
	UV.x-=0.3*TIME;
	UV.y-=0.6*TIME;
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	if(COLOR == vec4(0,0,0,1)){
		vec2 size = vec2(textureSize(TEXTURE,1))/vertex_scale;
		vec2 x_size = vec2(textureSize(x_tex,0));
		vec2 tiling = vec2(1.0*x_size.x/size.x,1);
		vec4 base = COLOR;
		vec2 uv = UV*tiling;
		uv = fract((uv));
		vec4 color = texture(x_tex,uv);
		COLOR = vec4(color.r,color.g,color.b,base.a);
	}
		
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
