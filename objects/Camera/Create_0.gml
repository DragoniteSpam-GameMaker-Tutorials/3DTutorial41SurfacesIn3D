/// @description Set up 3D things

// Bad things happen if you turn off the depth buffer in 3D
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);

gpu_set_cullmode(cull_counterclockwise);

view_mat = undefined;
proj_mat = undefined;

#region vertex format setup
// Vertex format: data must go into vertex buffers in the order defined by this
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_color();
vertex_format = vertex_format_end();
#endregion

#region shadow vertex buffer
vb_shadow = vertex_create_buffer();
vertex_begin(vb_shadow, vertex_format);

vertex_add_point(vb_shadow, -32, -32, 0,        0, 0, 1,        0, 0,       c_white, 1);
vertex_add_point(vb_shadow,  32, -32, 0,        0, 0, 1,        1, 0,       c_white, 1);
vertex_add_point(vb_shadow,  32,  32, 0,        0, 0, 1,        1, 1,       c_white, 1);

vertex_add_point(vb_shadow,  32,  32, 0,        0, 0, 1,        1, 1,       c_white, 1);
vertex_add_point(vb_shadow, -32,  32, 0,        0, 0, 1,        0, 1,       c_white, 1);
vertex_add_point(vb_shadow, -32, -32, 0,        0, 0, 1,        0, 0,       c_white, 1);

vertex_end(vb_shadow);
#endregion

#region create the grid
vbuffer = vertex_create_buffer();
vertex_begin(vbuffer, vertex_format);

// Create a checkerboard pattern on the floor
var s = 128;

var xtex = room_width / sprite_get_width(spr_grass);
var ytex = room_height / sprite_get_height(spr_grass);
var color = c_white;

#region add data to the vertex buffer
vertex_add_point(vbuffer, 0, 0, 0,                          0, 0, 1,        0, 0,       color, 1);
vertex_add_point(vbuffer, room_width, 0, 0,                 0, 0, 1,        xtex, 0,       color, 1);
vertex_add_point(vbuffer, room_width, room_height, 0,       0, 0, 1,        xtex, ytex,       color, 1);

vertex_add_point(vbuffer, room_width, room_height, 0,       0, 0, 1,        xtex, ytex,       color, 1);
vertex_add_point(vbuffer, 0, room_height, 0,                0, 0, 1,        0, ytex,       color, 1);
vertex_add_point(vbuffer, 0, 0, 0,                          0, 0, 1,        0, 0,       color, 1);
#endregion

vertex_end(vbuffer);
#endregion

instance_create_depth(0, 0, 0, Player);

vb_player = load_model("player.d3d");

vb_link = load_model("link.d3d");
link_rotation = 0;

time = 0;

surface_extra = surface_create(surface_get_width(application_surface), surface_get_height(application_surface));

application_surface_draw_enable(false);

vb_rock = load_model("rock.d3d");
rock_positions = array_create(40);
for (var i = 0; i < array_length(rock_positions); i++) {
    rock_positions[i] = [random(room_width), random(room_height)];
}