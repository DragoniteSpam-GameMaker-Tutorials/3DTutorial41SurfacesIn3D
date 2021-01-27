function scr_draw_all_the_stuff() {
    gpu_set_tex_repeat(true);
    // Everything must be drawn after the 3D projection has been set
    vertex_submit(vbuffer, pr_trianglelist, sprite_get_texture(spr_grass, 0));
    
    matrix_set(matrix_world, matrix_build(room_width, room_height, 0, 0, 0, 0, 1, 1, 1));
    vertex_submit(vb_screen, pr_trianglelist, surface_get_texture(surface_extra_copy));
    matrix_set(matrix_world, matrix_build_identity());
    
    shader_reset();
    
    time++;
    
    shader_set(shd_toon_hlsl);
    var uniform_light_pos = shader_get_uniform(shd_toon_hlsl, "lightPosition");
    var uniform_light_color = shader_get_uniform(shd_toon_hlsl, "lightColor");
    var uniform_light_range = shader_get_uniform(shd_toon_hlsl, "lightRange");
    shader_set_uniform_f(uniform_light_pos, 150, 150, 32);
    // this color uniform is kinda pointless now, since light color
    // is now controlled via the ramp texture
    shader_set_uniform_f(uniform_light_color, 1, 1, 1, 1);
    shader_set_uniform_f(uniform_light_range, 1000);
    
    gpu_set_tex_repeat(false);
    var uniform_time = shader_get_uniform(shd_toon_hlsl, "time");
    shader_set_uniform_f(uniform_time, frac(time / 400));
    
    var sampler_toon_ramp = shader_get_sampler_index(shd_toon_hlsl, "rampTexture");
    texture_set_stage(sampler_toon_ramp, sprite_get_texture(spr_toonification, 0));
    
    matrix_set(matrix_world, matrix_build(250, 250, 0, 0, 0, link_rotation, 1, 1, 1));
    vertex_submit(vb_link, pr_trianglelist, sprite_get_texture(spr_link, 0));
    matrix_set(matrix_world, matrix_build_identity());
    
    for (var i = 0; i < array_length(rock_positions); i++) {
        matrix_set(matrix_world, matrix_build(rock_positions[i][0], rock_positions[i][1], 0, 0, 0, current_time / 250, 1, 1, 1));
        vertex_submit(vb_rock, pr_trianglelist, sprite_get_texture(spr_rock, 0));
        matrix_set(matrix_world, matrix_build_identity());
    }
    
    shader_reset();
}