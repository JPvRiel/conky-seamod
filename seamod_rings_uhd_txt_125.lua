--[[===========================================================================
Example for 32" UHD / 4K screen with 125% font scaling, paired CPU threads, global ring sizing variables

Date    : 2020/04/30
Author  : SeaJey, modified by JPvRiel
Version : v0.5
License : Distributed under the terms of GNU GPL version 2 or later

This version is a modification of lunatico_rings.lua wich is modification of conky_orange.lua
- conky_orange.lua:    http://gnome-look.org/content/show.php?content=137503&forumpage=0
- lunatico_rings.lua:  http://gnome-look.org/content/show.php?content=142884
===========================================================================]]--

require 'cairo'

-- Global vars/defaults: 

--[[
Note about global vars used in gauge struct later:
- While a loop could be used to generate the gauges instead of needing static structs to be defined, the static structures allow for greater flexibility where defaults can be overidden.
- Gauge attributes related to spacing and scaling are defined gloably and then referenced in the gauge structs/attributes.
]]

-- General gauge spacing and scale
gauge_max_outer_radius = 100
gauge_target_inner_radius = 50
gauge_min_inner_radius = 25
gauge_ring_gap = 4
gauge_max_ring_thinkness = 20
gauge_x = gauge_max_outer_radius
gauge_y_start = gauge_max_outer_radius
gauge_y_offset = gauge_max_outer_radius * 3

-- CPU / process gauge rings 
cpu_gauge_rings_n = 12
-- Div 2 because of pairing hyperthread sibblings without any gap
cpu_gauge_rings_gaps_n = cpu_gauge_rings_n / 2 - 1
-- Slightly decrease the default ring gap when there are a lot of thinner rings
cpu_gauge_ring_gap = gauge_ring_gap - 1
-- Decrease the gauge_min_inner_radius even futher because there are 12 rings!
cpu_gauge_thickness = math.min((gauge_max_outer_radius - gauge_min_inner_radius - cpu_gauge_ring_gap * cpu_gauge_rings_gaps_n) / cpu_gauge_rings_n, gauge_max_ring_thinkness)

-- Memory rings
mem_gauge_rings_n = 2
mem_gauge_rings_gaps_n = mem_gauge_rings_n - 1
mem_gauge_ring_gap = gauge_ring_gap
mem_gauge_thickness = math.min((gauge_max_outer_radius - gauge_target_inner_radius - mem_gauge_ring_gap * mem_gauge_rings_gaps_n) / mem_gauge_rings_n, gauge_max_ring_thinkness)

-- Storage rings
storage_gauge_rings_n = 3
storage_gauge_rings_gaps_n = storage_gauge_rings_n - 1
storage_gauge_ring_gap = gauge_ring_gap
storage_gauge_thickness = math.min((gauge_max_outer_radius - gauge_target_inner_radius - storage_gauge_ring_gap * storage_gauge_rings_gaps_n) / storage_gauge_rings_n, gauge_max_ring_thinkness)

-- Network rings (has tick marks for 3rd signal ring)
net_gauge_rings_n = 3
net_gauge_rings_gaps_n = net_gauge_rings_n - 1
net_gauge_ring_gap = gauge_ring_gap
net_gauge_thickness = math.min((gauge_max_outer_radius - gauge_target_inner_radius - net_gauge_ring_gap * net_gauge_rings_gaps_n) / net_gauge_rings_n, gauge_max_ring_thinkness)


--[[
- Data / size rendering for the gauges is loaded just once when included and is therefore static, i.e, dynamic values don't appply.
- 'name' and 'arg' for simple conky objects with static arguments
- 'conky_line' for complex, conditional and dynamic behavior
- 'conky_line' supersedes 'name' and 'arg' (in case both are present)
--]]
gauge = {

-- CPU rings
--[[
If you don't have hyper threaded cores, simply delete every 2nd CPU and adjust the CPU arg
Hyper-thread sibblings share the same arc/ring
Bash output for listing sibling hyper-threaded instances on a 6 core, 12 thread Intel:
$ for c in /sys/devices/system/cpu/cpu*[0-9]/; do cat $c/topology/thread_siblings_list; done | sort -u
0,6
1,7
2,8
3,9
4,10
5,11
Note, cpu0 is overall CPU, so +1 when referencing a CPU hyper-thread instance, i.e. starting at cpu1.
--]]
-- Siblings 0,6 (cpu1,cpu7)
{
    name='cpu',                    arg='cpu1',                  max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 0,
    graph_radius=gauge_max_outer_radius - cpu_gauge_thickness * 1 - cpu_gauge_ring_gap * 0,
    graph_thickness=cpu_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.5,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=0.75,
    txt_radius=0,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='',
    caption_weight=0.8,            caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='cpu',                    arg='cpu7',                  max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 0,
    graph_radius=gauge_max_outer_radius - cpu_gauge_thickness * 2 - cpu_gauge_ring_gap * 0,
    graph_thickness=cpu_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.5,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=0.75,
    txt_radius=0,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='0:6',
    caption_weight=0.8,            caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
-- Siblings 1,7 (cpu2,cpu8)
{
    name='cpu',                    arg='cpu2',                  max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 0,
    graph_radius=gauge_max_outer_radius - cpu_gauge_thickness * 3 - cpu_gauge_ring_gap * 1,
    graph_thickness=cpu_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.5,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=0.75,
    txt_radius=0,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='',
    caption_weight=0.8,            caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='cpu',                    arg='cpu8',                  max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 0,
    graph_radius=gauge_max_outer_radius - cpu_gauge_thickness * 4 - cpu_gauge_ring_gap * 1,
    graph_thickness=cpu_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.5,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=0.75,
    txt_radius=0,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='1:7',
    caption_weight=0.8,            caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
-- Siblings 2,8 (cpu3,cpu9)
{
    name='cpu',                    arg='cpu3',                  max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 0,
    graph_radius=gauge_max_outer_radius - cpu_gauge_thickness * 5 - cpu_gauge_ring_gap * 2,
    graph_thickness=cpu_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.5,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=0.75,
    txt_radius=0,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='',
    caption_weight=0.8,            caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='cpu',                    arg='cpu9',                  max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 0,
    graph_radius=gauge_max_outer_radius - cpu_gauge_thickness * 6 - cpu_gauge_ring_gap * 2,
    graph_thickness=cpu_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.5,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=0.75,
    txt_radius=0,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='2:8',
    caption_weight=0.8,            caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
-- Siblings 3,9 (cpu4,cpu10)
{
    name='cpu',                    arg='cpu4',                  max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 0,
    graph_radius=gauge_max_outer_radius - cpu_gauge_thickness * 7 - cpu_gauge_ring_gap * 3,
    graph_thickness=cpu_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.5,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=0.75,
    txt_radius=0,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='',
    caption_weight=0.8,            caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='cpu',                    arg='cpu10',                  max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 0,
    graph_radius=gauge_max_outer_radius - cpu_gauge_thickness * 8 - cpu_gauge_ring_gap * 3,
    graph_thickness=cpu_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.5,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=0.75,
    txt_radius=0,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='3:9',
    caption_weight=0.8,            caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
-- Siblings 4,10 (cpu5,cpu11)
{
    name='cpu',                    arg='cpu5',                  max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 0,
    graph_radius=gauge_max_outer_radius - cpu_gauge_thickness * 9 - cpu_gauge_ring_gap * 4,
    graph_thickness=cpu_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.5,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=0.75,
    txt_radius=0,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='',
    caption_weight=0.8,            caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='cpu',                    arg='cpu11',                  max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 0,
    graph_radius=gauge_max_outer_radius - cpu_gauge_thickness * 10 - cpu_gauge_ring_gap * 4,
    graph_thickness=cpu_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.5,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=0.75,
    txt_radius=0,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='4:10',
    caption_weight=0.8,            caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
-- Siblings 5,11 (cpu6,cpu12)
{
    name='cpu',                    arg='cpu6',                  max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 0,
    graph_radius=gauge_max_outer_radius - cpu_gauge_thickness * 11 - cpu_gauge_ring_gap * 5,
    graph_thickness=cpu_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.5,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=0.75,
    txt_radius=0,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='',
    caption_weight=0.8,            caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='cpu',                    arg='cpu12',                  max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 0,
    graph_radius=gauge_max_outer_radius - cpu_gauge_thickness * 12 - cpu_gauge_ring_gap * 5,
    graph_thickness=cpu_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.5,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=0.75,
    txt_radius=0,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='5:11',
    caption_weight=0.8,            caption_size=8.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},

-- Memory rings
{
    name='memperc',                arg='',                      max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 1,
    graph_radius=gauge_max_outer_radius - mem_gauge_thickness * 1 - mem_gauge_ring_gap * 0,
    graph_thickness=mem_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.4,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=gauge_max_outer_radius - mem_gauge_thickness * 1 - mem_gauge_ring_gap * 0 + mem_gauge_thickness,
    txt_weight=1.0,                txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=54,
    graduation_thickness=0,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='RAM',
    caption_weight=0.8,            caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='swapperc',               arg='',                      max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 1,
    graph_radius=gauge_max_outer_radius - mem_gauge_thickness * 2 - mem_gauge_ring_gap * 1,
    graph_thickness=mem_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.4,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=gauge_max_outer_radius - mem_gauge_thickness * 2 - mem_gauge_ring_gap * 1 - mem_gauge_thickness,
    txt_weight=1.0,                txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=23,
    graduation_thickness=0,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='SWAP',
    caption_weight=0.8,            caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},

-- Storage rings
{
    name='fs_used_perc',           arg='/home',                 max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 2,
    graph_radius=gauge_max_outer_radius - storage_gauge_thickness * 1 - storage_gauge_ring_gap * 0,
    graph_thickness=storage_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.4,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=gauge_max_outer_radius - storage_gauge_thickness * 1 - storage_gauge_ring_gap * 0 + storage_gauge_thickness,
    txt_weight=1.0,                txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=0,
    graduation_thickness=0,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='home',
    caption_weight=0.8,            caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='fs_used_perc',           arg='/',                     max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 2,
    graph_radius=gauge_max_outer_radius - storage_gauge_thickness * 2 - storage_gauge_ring_gap * 1,
    graph_thickness=storage_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.4,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=gauge_max_outer_radius - storage_gauge_thickness * 2 - storage_gauge_ring_gap * 1 + storage_gauge_thickness,
    txt_weight=1.0,                txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=0,
    graduation_thickness=0,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='root',
    caption_weight=0.8,            caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='fs_used_perc',           arg='/var',                  max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 2,
    graph_radius=gauge_max_outer_radius - storage_gauge_thickness * 3 - storage_gauge_ring_gap * 2,
    graph_thickness=storage_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.4,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=gauge_max_outer_radius - storage_gauge_thickness * 3 - storage_gauge_ring_gap * 2 - storage_gauge_thickness,
    txt_weight=1.0,                txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=0,
    graduation_thickness=0,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='var',
    caption_weight=0.8,            caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},

-- Network rings
{
    --conky_line='${if_up eth0}${downspeedf eth0}${else}${if_up wlan0}{downspeedf wlan0}${endif}${endif}',
    conky_line='${if_match "${addr eth0}" != "No Address"}${downspeedf eth0}${else}${if_match "${addr wlan0}" != "No Address"}${downspeedf wlan0}${endif}${endif}',
    name='downspeedf',             arg='eth0',                  max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 3,
    graph_radius=gauge_max_outer_radius - net_gauge_thickness * 1 - net_gauge_ring_gap * 0,
    graph_thickness=net_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.4,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=gauge_max_outer_radius - net_gauge_thickness * 1 - net_gauge_ring_gap * 0 + net_gauge_thickness,
    txt_weight=1.0,                txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=68,
    graduation_thickness=0,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='Down',
    caption_weight=0.8,            caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    --conky_line='${if_up eth0}${upspeedf eth0}${else}${if_up wlan0}${upspeedf wlan0}${endif}${endif}',
    conky_line='${if_match "${addr eth0}" != "No Address"}${upspeedf eth0}${else}${if_match "${addr wlan0}" != "No Address"}${upspeedf wlan0}${endif}${endif}',
    name='upspeedf',               arg='eth0',                  max_value=100,
    x=gauge_x,                     y=gauge_y_start + gauge_y_offset * 3,
    graph_radius=gauge_max_outer_radius - net_gauge_thickness * 2 - net_gauge_ring_gap * 1,
    graph_thickness=net_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.4,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=gauge_max_outer_radius - net_gauge_thickness * 2 - net_gauge_ring_gap * 1 + net_gauge_thickness,
    txt_weight=1.0,                txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=56,
    graduation_thickness=0,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='Up',
    caption_weight=0.8,            caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    -- add special grduation marks for the signal ring
    conky_line='${if_match "${addr wlan0}" != "No Address"}${wireless_link_qual_perc wlan0}${else}0${endif}',
    name='wireless_link_qual_perc', arg='wlan0',                max_value=100,
    x=gauge_x,                      y=gauge_y_start + gauge_y_offset * 3,
    -- need an extra gap to splice in the graduation marks
    graph_radius=gauge_max_outer_radius - net_gauge_thickness * 3 - net_gauge_ring_gap * 2 - 5,
    graph_thickness=net_gauge_thickness,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.08,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.4,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=gauge_max_outer_radius - net_gauge_thickness * 3 - net_gauge_ring_gap * 2 - net_gauge_thickness * 2,
    txt_weight=1.0,                txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=gauge_max_outer_radius - net_gauge_thickness * 3 - net_gauge_ring_gap * 2 + 5,
    graduation_thickness=4,        graduation_mark_thickness=2,
    graduation_unit_angle=14,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='Signal',
    caption_weight=0.8,            caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
}

-- converts color in hexa to decimal
function rgb_to_r_g_b(colour, alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

-- convert degree to rad and rotate (0 degree is top/north)
function angle_to_position(start_angle, current_angle)
    local pos = current_angle + start_angle
    return ( ( pos * (2 * math.pi / 360) ) - (math.pi / 2) )
end


-- displays gauges
function draw_gauge_ring(display, data, value, border)
    local max_value = data['max_value']
    local x, y = data['x'] + border, data['y'] + border
    local graph_radius = data['graph_radius']
    local graph_thickness, graph_unit_thickness = data['graph_thickness'], data['graph_unit_thickness']
    local graph_start_angle = data['graph_start_angle']
    local graph_unit_angle = data['graph_unit_angle']
    local graph_bg_colour, graph_bg_alpha = data['graph_bg_colour'], data['graph_bg_alpha']
    local graph_fg_colour, graph_fg_alpha = data['graph_fg_colour'], data['graph_fg_alpha']
    local hand_fg_colour, hand_fg_alpha = data['hand_fg_colour'], data['hand_fg_alpha']
    local graph_end_angle = (max_value * graph_unit_angle) % 360

    -- background ring
    cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, 0), angle_to_position(graph_start_angle, graph_end_angle))
    cairo_set_source_rgba(display, rgb_to_r_g_b(graph_bg_colour, graph_bg_alpha))
    cairo_set_line_width(display, graph_thickness)
    cairo_stroke(display)

    -- arc of value
    local val = value % (max_value + 1)
    local start_arc = 0
    local stop_arc = 0
    local i = 1
    while i <= val do
        start_arc = (graph_unit_angle * i) - graph_unit_thickness
        stop_arc = (graph_unit_angle * i)
        cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
        cairo_set_source_rgba(display, rgb_to_r_g_b(graph_fg_colour, graph_fg_alpha))
        cairo_stroke(display)
        i = i + 1
    end
    local angle = start_arc

    -- hand
    start_arc = (graph_unit_angle * val) - (graph_unit_thickness)
    stop_arc = (graph_unit_angle * val)
    cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
    cairo_set_source_rgba(display, rgb_to_r_g_b(hand_fg_colour, hand_fg_alpha))
    cairo_stroke(display)

    -- graduations marks
    local graduation_radius = data['graduation_radius']
    local graduation_thickness, graduation_mark_thickness = data['graduation_thickness'], data['graduation_mark_thickness']
    local graduation_unit_angle = data['graduation_unit_angle']
    local graduation_fg_colour, graduation_fg_alpha = data['graduation_fg_colour'], data['graduation_fg_alpha']
    if graduation_radius > 0 and graduation_thickness > 0 and graduation_unit_angle > 0 then
        local nb_graduation = graph_end_angle / graduation_unit_angle
        local i = 0
        while i < nb_graduation do
            cairo_set_line_width(display, graduation_thickness)
            start_arc = (graduation_unit_angle * i) - (graduation_mark_thickness / 2)
            stop_arc = (graduation_unit_angle * i) + (graduation_mark_thickness / 2)
            cairo_arc(display, x, y, graduation_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
            cairo_set_source_rgba(display,rgb_to_r_g_b(graduation_fg_colour,graduation_fg_alpha))
            cairo_stroke(display)
            cairo_set_line_width(display, graph_thickness)
            i = i + 1
        end
    end

    -- text
    local txt_radius = data['txt_radius']
    local txt_weight, txt_size = data['txt_weight'], data['txt_size']
    local txt_fg_colour, txt_fg_alpha = data['txt_fg_colour'], data['txt_fg_alpha']
    local movex = txt_radius * math.cos(angle_to_position(graph_start_angle, angle))
    local movey = txt_radius * math.sin(angle_to_position(graph_start_angle, angle))
    cairo_select_font_face (display, "ubuntu", CAIRO_FONT_SLANT_NORMAL, txt_weight)
    cairo_set_source_rgba (display, rgb_to_r_g_b(txt_fg_colour, txt_fg_alpha))
    cairo_set_font_size (display, txt_size)
    if txt_radius > 0 then
        cairo_move_to (display, x + movex - (txt_size / 2), y + movey + 3)
        cairo_show_text (display, value)
        cairo_stroke (display)
    end

    -- caption
    local caption = data['caption']
    local caption_weight, caption_size = data['caption_weight'], data['caption_size']
    local caption_fg_colour, caption_fg_alpha = data['caption_fg_colour'], data['caption_fg_alpha']
    local tox = graph_radius * (math.cos((graph_start_angle * 2 * math.pi / 360)-(math.pi/2)))
    local toy = graph_radius * (math.sin((graph_start_angle * 2 * math.pi / 360)-(math.pi/2)))
    cairo_select_font_face (display, "ubuntu", CAIRO_FONT_SLANT_NORMAL, caption_weight);
    cairo_set_font_size (display, caption_size)
    cairo_set_source_rgba (display, rgb_to_r_g_b(caption_fg_colour, caption_fg_alpha))
    cairo_move_to (display, x + tox + 5, y + toy + 5)
    -- bad hack but not enough time !
    if graph_start_angle < 105 then
        cairo_move_to (display, x + tox - 30, y + toy + 1)
    end
    cairo_show_text (display, caption)
    cairo_stroke (display)
end


-- loads data and displays gauges
function go_gauge_rings(display, border)
    local function load_gauge_rings(display, data)
        local str, value = '', 0
        if data['conky_line'] == nil then
            str = string.format('${%s %s}',data['name'], data['arg'])
        else
            str = data['conky_line']
        end
        str = conky_parse(str)
        value = tonumber(str)
        if (value == nil) then
            value = 0
        else
            value = math.floor(value + 0.5)
        end
        draw_gauge_ring(display, data, value, border)
    end

    for i in pairs(gauge) do
        load_gauge_rings(display, gauge[i])
    end

end


-- other util functions

function conky_nproc()
  return io.popen('nproc'):read('*n')
end

-- provide a global var of nproc so that it is run only once, not every interval
nproc = conky_nproc()

function cpu_freq_list()
  fl = {}
  for i=1, nproc do
    fl[i] = conky_parse('${freq ' .. i .. '}')
  end
  return fl
end

function conky_freq_min()
  return math.min(unpack(cpu_freq_list()))
end

function conky_freq_max()
  return math.max(unpack(cpu_freq_list()))
end

function conky_freq_avg()
  fl = cpu_freq_list()
  sum = 0
  for i=1, #fl do
    sum = sum + fl[i]
  end
  return math.floor((sum/#fl) + 0.5)
end


-------------------------------------------------------------------------------
--                                                                         MAIN
function conky_main()
    if conky_window == nil then
        return
    end

    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local display = cairo_create(cs)

    go_gauge_rings(display, conky_window.border_outer_margin)

    cairo_surface_destroy(cs)
    cairo_destroy(display)

end
