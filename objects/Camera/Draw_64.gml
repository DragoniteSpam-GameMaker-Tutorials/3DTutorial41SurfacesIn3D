/// @description draw the user interface

draw_surface(application_surface, 0, 0);

draw_set_font(fnt_game);
draw_text(32, 32, "Hello, my name is Ezekiel");
draw_sprite_ext(spr_heart, 0, 32, 64, 2, 2, 0, c_white, 1);
draw_text(64, 64, "Health: " + string(Player.current_hp) + " / " + string(Player.max_hp));