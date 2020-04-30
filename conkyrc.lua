--[[===========================================================================
Example for 32" UHD / 4K screen with 125% font scaling

Date    : 2020/04/30
Author  : SeaJey, modified by JPvRiel
Version : v0.3
License : Distributed under the terms of GNU GPL version 2 or later

This version is a modification of lunatico_rings.lua wich is modification of conky_orange.lua
- conky_orange.lua:    http://gnome-look.org/content/show.php?content=137503&forumpage=0
- lunatico_rings.lua:  http://gnome-look.org/content/show.php?content=142884
===========================================================================--]]

conky.config = {

  background = true,
  update_interval = 1,

  cpu_avg_samples = 2,
  net_avg_samples = 2,
  temperature_unit = 'celsius',
  if_up_strictness = 'address',

  double_buffer = true,
  no_buffers = true,
  text_buffer_size = 2048,

  own_window = true,
  own_window_class = 'conky-semi',
  --own_window_type = 'normal',
  own_window_type = 'desktop',
  --own_window_type = 'dock',
  --own_window_type = 'panel',
  --own_window_type = 'override',
  --own_window_hints = 'undecorated,sticky,skip_taskbar,skip_pager,below',

  own_window_colour = '#000000',
  own_window_transparent = false,
  own_window_argb_visual = true,
  own_window_argb_value = 192,

  draw_shades = false,
  draw_outline = false,
  draw_borders = false,
  draw_graph_borders = false,

  alignment = 'top_right',
  gap_x = 80,
  gap_y = 110,
  minimum_width = 340, minimum_height = 600,
  maximum_width = 480,
  border_inner_margin = 0,
  border_outer_margin = 25,
  xinerama_head = 0,

  override_utf8_locale = true,
  use_xft = true,
  font = 'Roboto:size=10',
  xftalpha = 0.8,
  uppercase = false,

  -- Options
  top_cpu_separate = true,
  top_name_verbose = true,
  top_name_width = 25,
  short_units = true,

  -- Defining colors
  default_color = '#FFFFFF',
  -- Shades of Gray
  color1 = '#DDDDDD',
  color2 = '#AAAAAA',
  color3 = '#888888',
  color4 = '#444444',
  -- Orange
  color5 = '#EF5A29',
  -- Green
  --color6 = '#77B753',
  -- Blue
  color6 = '#2D6A92',

  -- Loading lua script for drawning rings
  lua_load = '~/.conky/seamod/seamod_rings.lua',
  lua_draw_hook_post = 'main'

};

conky.text = [[
# Showing CPU Graph with TOP 5
${offset 250}${color1}${font Roboto:medium:size=10}Temp: ${font Roboto:regular:size=10}${alignr}${color4}[${hwmon 6 temp 2},${hwmon 6 temp 3},${hwmon 6 temp 4},${hwmon 6 temp 5},${hwmon 6 temp 6},${hwmon 6 temp 7}] ${alignr}${color2}${hwmon 6 temp 1} C
${offset 250}${color1}${font Roboto:medium:size=10}Fan: ${alignr}${font Roboto:regular:size=10}${color2}${hwmon 4 fan 1} RPM
${offset 250}${color1}${font Roboto:medium:size=10}Freq: ${alignr}${font Roboto:regular:size=10}${alignr}${color4}[${lua freq_min} - ${lua freq_max}] ${alignr}${color2}${lua freq_avg} MHz
${offset 230}${cpugraph cpu0 50,0 808080 808080}
${voffset -35}\
${offset 150}${font Roboto:bold:size=12}${color6}PROC
# Showing TOP 5 CPU-consumers
${offset 160}${font Roboto:regular:size=11}${color5}${top name 1}${alignr}${font Roboto:medium:size=11}${top cpu 1}%
${offset 160}${font Roboto:regular:size=10}${color1}${top name 2}${alignr}${font Roboto:medium:size=10}${top cpu 2}%
${offset 160}${font Roboto:regular:size=9}${color2}${top name 3}${alignr}${font Roboto:medium:size=9}${top cpu 3}%
${offset 160}${font Roboto:light:size=9}${color3}${top name 4}${alignr}${font Roboto:regular:size=9}${top cpu 4}%
${offset 160}${font Roboto:thin:size=9}${color3}${top name 5}${alignr}${font Roboto:light:size=9}${top cpu 5}%
${voffset 60}\
#Showing memory Graph with TOP 5
${offset 320}${color1}${font Roboto:medium:size=10}Availble: ${alignr}${font Roboto:regular:size=10}${color2}${memeasyfree}
${offset 320}${color1}${font Roboto:medium:size=10}Cache: ${alignr}${font Roboto:regular:size=10}${color2}${cached}
${offset 320}${color1}${font Roboto:medium:size=10}Buffer: ${alignr}${font Roboto:regular:size=10}${color2}${buffers}
${offset 230}${memgraph 50,0 808080 808080}
${voffset -45}\
${offset 150}${font Roboto:bold:size=12}${color6}MEM
${offset 160}${font Roboto:medium:size=11}${color5}${top_mem name 1}${alignr}${font Roboto:medium:size=11}${top_mem mem_res 1}
${offset 160}${font Roboto:medium:size=10}${color1}${top_mem name 2}${alignr}${font Roboto:medium:size=10}${top_mem mem_res 2}
${offset 160}${font Roboto:regular:size=9}${color2}${top_mem name 3}${alignr}${font Roboto:medium:size=9}${top_mem mem_res 3}
${offset 160}${font Roboto:light:size=9}${color3}${top_mem name 4}${alignr}${font Roboto:regular:size=9}${top_mem mem_res 4}
${offset 160}${font Roboto:thin:size=9}${color3}${top_mem name 5}${alignr}${font Roboto:light:size=9}${top_mem mem_res 5}
${voffset 30}\
# Showing disk partitions: root, home and files
# Would be nice to show and summarise iowait times, and while conky source reads it, theres no exposed object for it
${offset 320}${color1}${font Roboto:medium:size=10} 
${offset 320}${color1}${font Roboto:medium:size=10}Read: ${alignr}${font Roboto:medium:size=10}${color2}${diskio_read}
${offset 320}${color1}${font Roboto:medium:size=10}Write: ${alignr}${font Roboto:medium:size=10}${color2}${diskio_write}
${offset 230}${diskiograph 50,0 808080 808080}
${voffset -15}\
${offset 150}${font Roboto:bold:size=12}${color6}STORE
${offset 160}${font Roboto:medium:size=12}${color5}${top_io name 1}${alignr} ${font Roboto:medium:size=11}r:${top_io io_read 1}| w:${top_io io_write 1}
${offset 160}${font Roboto:medium:size=10}${color1}${top_io name 2}${alignr} ${font Roboto:medium:size=10}r:${top_io io_read 2}| w:${top_io io_write 2}
${offset 160}${font Roboto:regular:size=9}${color2}${top_io name 3}${alignr} ${font Roboto:medium:size=9}r:${top_io io_read 3}| w:${top_io io_write 3}
${offset 160}${font Roboto:light:size=9}${color2}${top_io name 4}${alignr} ${font Roboto:regular:size=9}r:${top_io io_read 4}| w:${top_io io_write 4}
${offset 160}${font Roboto:thin:size=9}${color2}${top_io name 5}${alignr} ${font Roboto:light:size=9}r:${top_io io_read 5}| w:${top_io io_write 5}
${voffset 60}\
# Network data (assumes wireless info). NET ring is mostly useless but looks pretty, main info is in the graphs
${if_up eth0}\
${if_match "${addr eth0}" != "No Address"}\
${offset 270}${font Roboto:medium:size=10}${color1}Wired
${offset 270}${font Roboto:medium:size=10}${color1}IP: ${alignr}${font Roboto:regular:size=10}${color2}${addr eth0}
${offset 270}${font Roboto:medium:size=10}${color1}Public IP: ${alignr}${font Roboto:regular:size=10}${color2}${curl http://api.ipify.org 300}
${offset 230}${upspeedgraph eth0 40,0 4B1B0C FF5C2B 10240KiB -l}
${offset 300}${color1}${font Roboto:regular:size=10}Up: ${alignr}${font Roboto:regular:size=10}${color3}${upspeed eth0} / ${totalup eth0}
${offset 230}${downspeedgraph eth0 40,0 324D23 77B753 10240KiB -l}
${offset 300}${color1}${font Roboto:regular:size=10}Down: ${alignr}${font Roboto:regular:size=10}${color3}${downspeed eth0} / ${totaldown eth0}
${endif}\
${else}\
${if_match "${addr wlan0}" != "No Address"}\
${offset 270}${font Roboto:medium:size=10}${color1}Wifi: ${alignr}${font Roboto:regular:size=10}${color2}${wireless_essid} (${wireless_bitrate wlan0})
${offset 270}${font Roboto:medium:size=10}${color1}IP: ${alignr}${font Roboto:regular:size=10}${color2}${addr wlan0}
${offset 270}${font Roboto:medium:size=10}${color1}Public IP: ${alignr}${font Roboto:regular:size=10}${color2}${curl http://api.ipify.org 300}
${offset 230}${upspeedgraph wlan0 40,0 4B1B0C FF5C2B 10240KiB -l}
${offset 300}${color1}${font Roboto:medium:size=10}Up: ${alignr}${font Roboto:regular:size=10}${color3}${upspeed wlan0} / ${totalup wlan0}
${offset 230}${downspeedgraph wlan0 40,0 324D23 77B753 10240KiB -l}
${offset 300}${color1}${font Roboto:medium:size=10}Down: ${alignr}${font Roboto:regular:size=10}${color3}${downspeed wlan0} / ${totaldown wlan0}
${else}\
${offset 180}${font Roboto:bold:size=10}${color1}Disconnected
${offset 180}${font Roboto:regular:size=10}${color3}(eth0 and wlan0 have no IP)
${offset 230}${upspeedgraph eth0 40,0 4B1B0C FF5C2B 10240KiB -l}
${offset 300}${color1}${font Roboto:medium:size=10}Up: ${alignr}${font Roboto:medium:size=10}${color3}NA
${offset 230}${downspeedgraph eth0 40,0 324D23 77B753 10240KiB -l}
${offset 300}${color1}${font Roboto:medium:size=10}Down: ${alignr}${font Roboto:medium:size=10}${color3}NA
${endif}\
${endif}\
${voffset -170}
${offset 150}${font Roboto:bold:size=12}${color6}NET
${voffset 170}\
#### Modifications below HERE wont cause alignment problems with the gauges/rings ####
# Extra info
${offset 10}${font Roboto:medium:size=10}${color1}Entropy:${tab}${color3}${entropy_bar 5,250} ${color3}${entropy_perc}% (${entropy_avail}/${entropy_poolsize})
${offset 10}${font Roboto:medium:size=10}${color1}Battery:${tab}${tab}${color3}${battery_bar 5,250} ${if_match ${battery_percent BAT0} <= 33}${color5}${else}${color3}${endif}${battery_short}${if_match ${battery_percent BAT0} != 100} (${battery_time})${endif}
${offset 10}${font Roboto:medium:size=10}${color1}Uptime:${tab}${color3} $uptime
${voffset 0}
# Log feed
${offset 10}${font Roboto:bold:size=10}${color6}JOURNAL ${font Roboto:regular:size=10}${color1}(Err|Warn):
${voffset 3}\
${color3}${font Ubuntu Condensed:light:size=8}${texecpi 15 ~/.conky/seamod/journal-err-feed.sh }
${voffset -90}\
]];
