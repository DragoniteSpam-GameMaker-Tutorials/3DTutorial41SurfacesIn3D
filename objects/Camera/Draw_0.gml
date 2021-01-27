/// @description Draw the 3D world

surface_set_target(surface_extra);
draw_clear(c_black);
surface_reset_target();

draw_clear(c_black);

shader_set(shd_basic_3d_stuff);

// 3D projections require a view and projection matrix
var camera = camera_get_active();
var camera_distance = 160;

var xfrom = Player.x;
var yfrom = Player.y;
var zfrom = Player.z + 64;
var xto = xfrom - camera_distance * dcos(Player.look_dir) * dcos(Player.look_pitch);
var yto = yfrom + camera_distance * dsin(Player.look_dir) * dcos(Player.look_pitch);
var zto = zfrom + camera_distance * dsin(Player.look_pitch);

view_mat = matrix_build_lookat(xfrom, yfrom, zfrom, xto, yto, zto, 0, 0, 1);
proj_mat = matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 1, 32000);
camera_set_view_mat(camera, view_mat);
camera_set_proj_mat(camera, proj_mat);
camera_apply(camera);

gpu_set_tex_repeat(true);
// Everything must be drawn after the 3D projection has been set
vertex_submit(vbuffer, pr_trianglelist, sprite_get_texture(spr_grass, 0));

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

if (keyboard_check(ord("Q"))) {
    link_rotation += 2;
} else if (keyboard_check(ord("E"))) {
    link_rotation -= 2;
}

surface_set_target_ext(1, surface_extra);

matrix_set(matrix_world, matrix_build(250, 250, 0, 0, 0, link_rotation, 1, 1, 1));
vertex_submit(vb_link, pr_trianglelist, sprite_get_texture(spr_link, 0));
matrix_set(matrix_world, matrix_build_identity());

for (var i = 0; i < array_length(rock_positions); i++) {
    matrix_set(matrix_world, matrix_build(rock_positions[i][0], rock_positions[i][1], 0, 0, 0, current_time / 250, 1, 1, 1));
    vertex_submit(vb_rock, pr_trianglelist, sprite_get_texture(spr_rock, 0));
    matrix_set(matrix_world, matrix_build_identity());
}

shader_reset();