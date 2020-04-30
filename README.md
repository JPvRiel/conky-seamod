# Conky Seamod theme

Seamod theme was built by SeaJey. Maxiwell modified the original theme for conky 1.10 configuration. I tweaked it further with some major changes.

## Screenshot

![alt text](README-eg.png)

## New Features

### by Maxiwell

- Disk Read/Write
- Lan/Ext IP's

### by JPvRiel

Fixes:

- `border_outer_margin` can be adjusted without breaking the alignment of rings.
- now runs on Ubuntu 16.04 / 18.04 LTS with Gnome 3.18 / 3.28 using `dock` or `normal` window type and hints.

Changes/enhancements:

- gracefully accommodates switching between wired and wireless. NET section shows info for wired (eth0) else wireless (wlan0) info is shown.
- `own_window_argb_value` conifg option for background and semi-transparency settings.
- `conky_line` superseeds 'name' and 'arg' options to use more complex conkey objects and variables in `seamod_rings.lua`
- 'Free' text info moved to the bottom so changes avoid interfering with alignment of rings/gauges.
- Tweaked info per section, e.g. CPU temp, fan RPM, memory cache, etc.
- Added IO top info for disk / storage (matches top list for memory and processor).
- Added a few extra conky lua functions to calculate the min, max and average frequency of the cpu cores (requires `nproc` command), given this influences CPU temperature and fan speed.
  - Min to Max value added as 'Freq:' near the top under 'Temp:' and 'Fan:' values.
  - One can use `${nproc}`, `${freq_min}`, `${freq_max}`, and `${freq_avg}` elsewhere in the conky TEXT section.
- Added examples to closely pair/overlap CPU sibling hyperthreads.
- Adjusted `seamod_rings.lau` and `conkyrc.lau` for UHD/4K with 125% font scaling.
  - Previous examples for HD resolution remain as well.
- Added global ring scaling vars to `seamod_rings.lau` for better singular control.
- Added example scripts to feed last 5 warning or error messages from syslog or journald.

## Install and run

It's possible to install conky from the Ubuntu repo and add the seamod theme within your home dir (should work in Gnome 3 at least):

```bash
sudo apt-get install conky-all
mkdir -p ~/.conky/seamod
git clone --depth=1 https://github.com/JPvRiel/conky-seamod ~/.conky/seamod
cp ~/.conky/seamod/conky.desktop ~/.config/autostart/
ln -s ~/.conky/seamod/conkyrc.lua ~/.conkyrc
```

Start (ad-hoc in shell, useful for debugging):

```bash
conky -c ~/.conky/seamod/conkyrc.lua
```

Stop:

```bash
killall conky
```

Hints:

- Install location assumes `~/.conky/seamod`. If not, correct script references in `conkyrc.lua`.
- For auto-start, `conky.desktop` may need other tweaks for auto-start with other desktop environments.
- Tested with conky v1.10.8

## Modifying

Hardware such as number of CPU cores, the place to get temperatures and even the way in which network devices are named varies, so some modifications will likely be needed depending on your display setup:

- Screen resolution, e.g. HD vs UHD
- DPI and font scaling factor, e.g. 100% vs 125%

AFAIK, Gnome 3.28 (for Ubuntu 18.04 LTS) display settings options does not offer per display fractional scaling yet.

Herewith, the most likely changes that are typically needed.

### Adjusting the position of rings

If the graphs are not nicely aligned with the text, it's likely the issue relates to complications with conky handling high DPI settings or display font scaling.

You may need to shift the position of the text offsets to align with rings that are rendered independently from the text and other built-in conky graph options. Also look at the example config files for HD vs UHD (with 125% font scaling).

- In `conkyrc.lua`, adjust `voffset` sections in the text section to help text fit nicely with gauges/rings.
- In `seamod_rings.lua`, adjust gauges vars and table attributes for position, radius and thickness.

See:

- [#944: conky graph does not support HiDPI screen display like Mac Retina](https://github.com/brndnmtthws/conky/issues/944)
- [#218: Conky looks different on autostart than with manual start using XFCE](https://github.com/brndnmtthws/conky/issues/218)

### Adjusting the number of rings

Modify CPU rings in `seamod_rings.lua`'s `gauge` table vars. You'll likely need to the number of 'cpu' ring items to match the output of the `nproc` command.

Current examples are for an Intel i7-9750H (6 core, 12 thread). To adapt it:

- If you have less than 12, simply comment out or remove `cpu` items in the list.
  - You'll likely want to make rings thicker if you have less than 8.
- If you have more than 12, there's a bit of room left to extend it up to 16.
  - Scaling down the ring thickness will be needed for more than 16 cpu items.

There are some variations on the ring concept depending on hyper threading and the number of cores:

- The original evenly spaced CPU ring concept is in [seamod_rings_hd_simple.lua](seamod_rings_hd_simple.lua).
- My adaptations relate sibling hyper-thread 'cpus'. There are two styles to choose from:
  - [seamod_rings_hd_cpu_pairs.lua](seamod_rings_hd_cpu_pairs.lua):
    - Worked on my system with standard 1920x1080 HD resolution.
    - Sibling hyperthreads rings are paired closely to look as if they're a single ring.
    - This more clearly reflects a core with a pair of hyperthreads.
  - [seamod_rings_uhd_txt_125.lua](seamod_rings_uhd_txt_125.lua):
    - Similar to above, but scaled for UHD and font rendering at 125%.
  - [seamod_rings_hd_cpu_overlap.lua](seamod_rings_hd_cpu_overlap.lua):
    - Both sibling hyperthreads are drawning in the same ring contributing half of the opacity. Each has it's own red marker.
    - This provides a nicer way to cram in a high hyper-threaded CPU count, e.g. 16+, in order to avoid too many skinny rings.
    - It's also more technically accurate since a hyper-threaded instance of a core isn't a full additional CPU, but overlapped threads.

The CPU topology can be inspected via sysfs, e.g.:

```bash
$ for c in /sys/devices/system/cpu/cpu*[0-9]/; do cat $c/topology/thread_siblings_list; done | sort -u
0,6
1,7
2,8
3,9
4,10
5,11
```

Change 'fs_used_perc' items to suite systems partitioning scheme. E.g. default has 'root', 'home' and 'var' separate.

#### Keeping the rings and text info aligned

*N.B!* Alignment between rings and the text is painfully brittle. So avoid changing the number of lines in the text section that algin next to rings. See limitations section below for why...

Best place to add own text or info is under `# Extra info`. And to make room, you can remove some lines. This section is past where the rings are rendered.

To adjust ring/gauge sections:

- In `seamod_rings.lua`, the newer version allows for quicker adjustment via global vars, such as:
  - `gauge_max_outer_radius`: biggest outermost gauge/ring size.
  - `gauge_target_inner_radius`: desired innermost gauge/ring size.
  - etc.
- In the older/classic way, each item in the gauges table needs to be tweaked:
  - Fiddle with `graph_radius`, `graph_thickness` and if used, `txt_radius`, so adjust ring sizing.
  - In `gauges` items, use `conky_line` instead of `name` and `arg` if advanced objects are needed.

After adjusting rings, you'll have to realign the text offsets in `conkyrc.lua`:

- Look to tweak `voffset` and `offset` values in front of most items.
- Note, 3 lines of info are accommodated next to rings and above the built-in graph sections - substitute as you deem fit, but keep the spacing at 3 lines to avoid misalignment between rings and text.

### Setting appropriate network names

Modify network to monitor - sorry, this is messy!

- Find and replace names for `eth0` (typical for wired) and `wlan0` (typical for wireless) if your own device names differ.
- Recently, systemd has changed the way devices are named, i.e. based on firmware or BIOS (see RedHat doc [Consistent Network Device Naming - Naming Schemes Hierarchy](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Networking_Guide/ch-Consistent_Network_Device_Naming.html)
  - So it's going to be system specific and `eth0` or `wlan0` defaults are no longer as useful.
- Needs to be done in both `seamod_rings.lua` and `conkyrc.lua`

E.g. fix.

```bash
sed -i -e 's/eth0/eth1/g' ~/.conky/seamod/conkyrc.lua  ~/.conky/seamod/seamod_rings.lua
```

### Hardware monitor info like CPU temperature and fan speed

CPU and fan temperature uses the `hwmon` conky variable. You'll need to find your hardware specific path and inputs somewhere in `/sys/class/hwmon/*`. Sadly, some systems might not consistently use hwmon1 vs hwmon0 between boots.

To have an idea about what got mapped to which hwmon, e.g.:

```bash
$ for h in /sys/class/hwmon/hwmon?; do echo "$h = $(cat "$h/name")"; done
/sys/class/hwmon/hwmon0 = AC
/sys/class/hwmon/hwmon1 = acpitz
/sys/class/hwmon/hwmon2 = BAT0
/sys/class/hwmon/hwmon3 = pch_cannonlake
/sys/class/hwmon/hwmon4 = thinkpad
/sys/class/hwmon/hwmon5 = coretemp
/sys/class/hwmon/hwmon6 = iwlwifi
```

And, if like me, you also have coretemp (for Intel), then, e.g.:

```bash
$ for t in /sys/class/hwmon/hwmon5/temp*_label; do echo "$(basename $t): $(cat $t)"; done
temp1_label: Package id 0
temp2_label: Core 0
temp3_label: Core 1
temp4_label: Core 2
temp5_label: Core 3
temp6_label: Core 4
temp7_label: Core 5
```

Also fan speed probably found with the motherboard, e.g.:

```bash
$ cat /sys/class/hwmon/hwmon4/fan1_input
0
```

So in my case, I edited the conky config section to set the core temps as a grey prefix, and the overall package temp at the end:

```console
${offset 180}${color1}${font Roboto:medium:size=10}Temp: ${font Roboto:regular:size=10}${alignr}${color4}[${hwmon 5 temp 2},${hwmon 5 temp 3},${hwmon 5 temp 4},${hwmon 5 temp 5},${hwmon 5 temp 6},${hwmon 5 temp 7}] ${alignr}${color2}${hwmon 5 temp 1} C
${offset 180}${color1}${font Roboto:medium:size=10}Fan: ${alignr}${font Roboto:regular:size=10}${color2}${hwmon 4 fan 1} RPM
```

If you choose more or less than 3 things, alignment with rings break... #sadpanda

### Other misc stuff (change as you please)

- Entropy pool bar for crypto nerds may be arb and can be removed. Delete line with `entropy_bar` etc.
- You might prefer not to see how often errors and warnings are spat out by syslog. Delete line with `{texecpi 60 ~/.conky/seamod/syslog-err-feed.sh}`

## Bugs / Limitations / TODO

### Network changes

While `if_up` looks simpler, conky's `if_up` object triggers a seemingly benign stream of `SIOCGIFADDR: Cannot assign requested address` errors when used with the `if_up_strictness = 'address'` config option.

`${ip_up eth0}` is commented out and replaced with a more cumbersome (but reliable) option `${if_match "${addr eth0}" != "No Address"}` as the workaround.

### Multiple screens

Conky always displays on the rightmost screen's edge, given many desktops and graphics drivers setup the display as one large X screen and resolution.

- The `xinerama_head` option is supposed to help pin/dock the window to the first screen, but requires a very recent version of conkey (and Ubuntu 16.04 LTS only packaged v1.10.1 without the fix)
- Example issue [here](https://github.com/brndnmtthws/conky/issues/249) and [here](https://github.com/brndnmtthws/conky/issues/172).

### TODO: Dynamic conky rings

It's admittedly tedious for users with differing hardware to have to tweak `conkyrc.lua` and manually adjust spacing.

I assume that, for performance reasons, the original lua code to setup and render the rings was done statically and configured once-off, hence it's non-trivial handling platform differences. A major re-write would try to allow the number of rings to adjust according to:

- Number of cores the user has.
- Scale the core ring size according to current core frequency, .e.g.
  - Take into account 100% at 800MHz frequency is not the same as 100% at 2800MHz frequency.
- Number of file-system partitions the user wants to monitor.

#### TODO: Include current CPU frequency in ring size

Leverage this info to scale the size of the CPU wring so that only 100% at max frequency produces a full ring

```console
$ cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq
800000
$ cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq
3800000
$ cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
3051671
```

Other considerations:

- CPU base frequency (not same as max/turbo boost), e.g. 2.8 GHz vs 3.8 GHz
- CPU cores versus threads

Depends on fully refactoring the lua code to define and draw rings dynamically upon every refresh.

#### TODO: Memory rings could have option to render memory read and write utilisation

A ring showing the memory use is quite static and boring. That's easily reflected by a simple flat bar or percentage stat. Graphing memory read and write access would be more interesting.

#### TODO: Storage rings could have option to render device read and write

Similar to memory todo above, graphing the read and write per storage device in the ring would be interesting.

#### TODO: Logarithmic scale for rings

For storage, memory and network IO, often there's a low level of activity which means the rings or graph levels are under utilised. A logarithmic scale could help stretch out smaller values.

#### TODO: Add GPU rings

Currently, no GPU stats are utilisation is shown.

## Related Work

Click [here](http://www.deviantart.com/art/Conky-Seamod-v0-1-283461046) to see the original theme and screenshots.
Click [here](https://github.com/maxiwell/conky-seamod) for repo with previous version
