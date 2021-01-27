/// @description draw the user interface
/*
if (keyboard_check(vk_space)) {
    draw_surface(surface_extra, 0, 0);
} else {
    draw_surface(application_surface, 0, 0);
}
*/

draw_surface(application_surface, 0, 0);

//gpu_set_blendmode_ext(bm_dest_color, bm_inv_src_alpha);
gpu_set_blendmode(bm_max);
shader_set(shd_sobel);
var u_tex_size = shader_get_uniform(shd_sobel, "texSize");
shader_set_uniform_f(u_tex_size, surface_get_width(surface_extra), surface_get_height(surface_extra));
draw_surface(surface_extra, 0, 0);
shader_reset();
gpu_set_blendmode(bm_normal);

draw_set_font(fnt_game);
draw_text(32, 32, "Hello, my name is Ezekiel");
draw_sprite_ext(spr_heart, 0, 32, 64, 2, 2, 0, c_white, 1);
draw_text(64, 64, "Health: " + string(Player.current_hp) + " / " + string(Player.max_hp));