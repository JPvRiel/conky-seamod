-----------------------------------------------------------------------------
-- conkyrc_seamod
-- Date : 2016/11/13
-- Author : SeaJey, Maxiwell and JPvRiel
-- Conky : >= 1.10
-- License : Distributed under the terms of GNU GPL version 2 or later
-----------------------------------------------------------------------------

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
  --own_window_type = 'override',
  --own_window_type = 'desktop',
  own_window_type = 'dock',
  own_window_hints = 'undecorated,sticky,skip_taskbar,skip_pager,below',

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
  gap_y = 70,
  minimum_width = 340, minimum_height = 600,
  maximum_width = 360,
  border_inner_margin = 0,
  border_outer_margin = 20,
  xinerama_head = 0,

  override_utf8_locale = true,
  use_xft = true,
  font = 'Ubuntu:size=11',
  xftalpha = 0.8,
  uppercase = false,

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
  color6 = '#77B753',

  -- Loading lua script for drawning rings
  lua_load = '~/.conky/seamod/seamod_rings.lua',
  lua_draw_hook_post = 'main'

};

conky.text = [[
# Showing CPU Graph with TOP 5
${offset 180}${color1}${font Ubuntu:size=10:style=bold}Temp: ${font Ubuntu:size=10:style=normal}${alignr}${color4}[${hwmon 2 temp 2},${hwmon 2 temp 3},${hwmon 2 temp 4},${hwmon 2 temp 5}] ${alignr}${color2}${hwmon 2 temp 1} C
${offset 180}${color1}${font Ubuntu:size=10:style=bold}Fan: ${alignr}${font Ubuntu:size=10:style=normal}${color2}${hwmon 3 fan 1} RPM
${offset 180}${color1}${font Ubuntu:size=10:style=bold}Freq: ${alignr}${font Ubuntu:size=10:style=normal}${alignr}${color4}[${lua freq_min} - ${lua freq_max}] ${alignr}${color2}${lua freq_avg} MHz
${offset 145}${cpugraph cpu0 30,200 666666 666666}
${voffset -32}
${offset 91}${font Ubuntu:size=11:style=bold}${color6}PROC
# Showing TOP 5 CPU-consumers
${offset 110}${font Ubuntu:size=11:style=normal}${color5}${top name 1}${alignr}${top cpu 1}%
${offset 110}${font Ubuntu:size=11:style=normal}${color1}${top name 2}${alignr}${top cpu 2}%
${offset 110}${font Ubuntu:size=10:style=normal}${color2}${top name 3}${alignr}${top cpu 3}%
${offset 110}${font Ubuntu:size=10:style=normal}${color3}${top name 4}${alignr}${top cpu 4}%
${offset 110}${font Ubuntu:size=10:style=normal}${color3}${top name 5}${alignr}${top cpu 5}%


#Showing memory Graph with TOP 5
${offset 180}${color1}${font Ubuntu:size=10:style=bold}Availble: ${alignr}${font Ubuntu:size=10:style=normal}${color2}${memeasyfree}
${offset 180}${color1}${font Ubuntu:size=10:style=bold}Cache: ${alignr}${font Ubuntu:size=10:style=normal}${color2}${cached}
${offset 180}${color1}${font Ubuntu:size=10:style=bold}Buffer: ${alignr}${font Ubuntu:size=10:style=normal}${color2}${buffers}
${offset 145}${memgraph 30,200 666666 666666}
${voffset -32}
${offset 100}${font Ubuntu:size=11:style=bold}${color6}MEM
${offset 110}${font Ubuntu:size=12:style=normal}${color5}${top_mem name 1}${alignr}${top_mem mem_res 1}
${offset 110}${font Ubuntu:size=11:style=normal}${color1}${top_mem name 2}${alignr}${top_mem mem_res 2}
${offset 110}${font Ubuntu:size=10:style=normal}${color2}${top_mem name 3}${alignr}${top_mem mem_res 3}
${offset 110}${font Ubuntu:size=10:style=normal}${color3}${top_mem name 4}${alignr}${top_mem mem_res 4}
${offset 110}${font Ubuntu:size=10:style=normal}${color3}${top_mem name 5}${alignr}${top_mem mem_res 5}



# Showing disk partitions: root, home and files
${offset 180}${color1}${font Ubuntu:size=10:style=bold}Read: ${alignr}${font Ubuntu:size=10:style=normal}${color2}${diskio_read}
${offset 180}${color1}${font Ubuntu:size=10:style=bold}Write: ${alignr}${font Ubuntu:size=10:style=normal}${color2}${diskio_write}
${offset 145}${diskiograph 30,200 666666 666666}
${voffset -32}
${offset 85}${font Ubuntu:size=11:style=bold}${color6}STORE
${offset 110}${font Ubuntu:size=12:style=normal}${color5}${top_io name 1}${alignr}r:${top_io io_read 1}w:${top_io io_write 1}
${offset 110}${font Ubuntu:size=11:style=normal}${color1}${top_io name 2}${alignr}r:${top_io io_read 2}w:${top_io io_write 2}
${offset 110}${font Ubuntu:size=10:style=normal}${color2}${top_io name 3}${alignr}r:${top_io io_read 3}w:${top_io io_write 3}
${offset 110}${font Ubuntu:size=10:style=normal}${color2}${top_io name 4}${alignr}r:${top_io io_read 4}w:${top_io io_write 4}
${offset 110}${font Ubuntu:size=10:style=normal}${color2}${top_io name 5}${alignr}r:${top_io io_read 5}w:${top_io io_write 5}

# Network data (assumes wireless info). NET ring is mostly useless but looks pretty, main info is in the graphs
${if_up eth0}
${if_match "${addr eth0}" != "No Address"}\
${offset 180}${font Ubuntu:size=10:style=bold}${color1}Wired
${offset 180}${font Ubuntu:size=10:style=bold}${color1}IP: ${alignr}${font Ubuntu:size=10:style=normal}${color2}${addr eth0}
${offset 180}${font Ubuntu:size=10:style=bold}${color1}Public IP: ${alignr}${font Ubuntu:size=10:style=normal}${color2}${curl http://api.ipify.org 300}
${offset 145}${upspeedgraph eth0 25,200 4B1B0C FF5C2B 10240KiB -l}
${offset 145}${color1}${font Ubuntu:size=10:style=bold}Up: ${alignr}${font Ubuntu:size=10:style=normal}${color3}${upspeed eth0} / ${totalup eth0}
${offset 145}${downspeedgraph eth0 25,200 324D23 77B753 10240KiB -l}
${offset 145}${color1}${font Ubuntu:size=10:style=bold}Down: ${alignr}${font Ubuntu:size=10:style=normal}${color3}${downspeed eth0} / ${totaldown eth0}
${endif}\
${else}\
${if_match "${addr wlan0}" != "No Address"}\
${offset 180}${font Ubuntu:size=10:style=bold}${color1}Wifi: ${alignr}${font Ubuntu:size=10:style=normal}${color2}${wireless_essid} (${wireless_bitrate wlan0})
${offset 180}${font Ubuntu:size=10:style=bold}${color1}IP: ${alignr}${font Ubuntu:size=10:style=normal}${color2}${addr wlan0}
${offset 180}${font Ubuntu:size=10:style=bold}${color1}Public IP: ${alignr}${font Ubuntu:size=10:style=normal}${color2}${curl http://api.ipify.org 300}
${offset 145}${upspeedgraph wlan0 25,200 4B1B0C FF5C2B 10240KiB -l}
${offset 145}${color1}${font Ubuntu:size=10:style=bold}Up: ${alignr}${font Ubuntu:size=10:style=normal}${color3}${upspeed wlan0} / ${totalup wlan0}
${offset 145}${downspeedgraph wlan0 25,200 324D23 77B753 10240KiB -l}
${offset 145}${color1}${font Ubuntu:size=10:style=bold}Down: ${alignr}${font Ubuntu:size=10:style=normal}${color3}${downspeed wlan0} / ${totaldown wlan0}
${else}\
${offset 180}${font Ubuntu:size=10:style=bold}${color1}Disconnected
${offset 180}${font Ubuntu:size=10:style=normal}${color3}(eth0 and wlan0 have no IP)
${offset 145}${upspeedgraph eth0 25,200 4B1B0C FF5C2B 10240KiB -l}
${offset 145}${color1}${font Ubuntu:size=10:style=bold}Up: ${alignr}${font Ubuntu:size=10:style=normal}${color3}NA
${offset 145}${downspeedgraph eth0 25,200 324D23 77B753 10240KiB -l}
${offset 145}${color1}${font Ubuntu:size=10:style=bold}Down: ${alignr}${font Ubuntu:size=10:style=normal}${color3}NA
${endif}\
${endif}\
${voffset -100}
${offset 105}${font Ubuntu:size=11:style=bold}${color6}NET

#### Modifications below HERE wont cause alignment problems with the gauges/rings ####
# Extra info
${voffset 60}
${offset 15}${font Ubuntu:size=11:style=normal}${color1}Entropy:${tab}${color3}${entropy_bar 5,140} ${color3}${entropy_perc}% (${entropy_avail}/${entropy_poolsize})
${offset 15}${font Ubuntu:size=11:style=normal}${color1}Battery:${tab}${color3}${battery_bar 5,140} ${if_match ${battery_percent BAT0} <= 33}${color5}${else}${color3}${endif}${battery_short}${if_match ${battery_percent BAT0} != 100} (${battery_time})${endif}
${offset 15}${font Ubuntu:size=11:style=normal}${color1}Uptime:${tab}${tab}${color3}$uptime

# Log feed
${offset 15}${font Ubuntu:size=11:style=normal}${color1}Syslog Err:
${voffset 3}${color3}${font Ubuntu Condensed:size=8:style=normal}${texecpi 60 ~/.conky/seamod/syslog-err-feed.sh }
]];
