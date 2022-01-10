-- TENDING THE WAVES
-- play radio Aporee on Norns
-- @maaark
-- after idea of @mlogger @Justmat @infinitedigits
-- !! Requires MPV installed, run 'sudo apt-get install mpv' once, might require 'sudo apt-get update' before!

-- require the `mods` module to gain access to hooks, menu, and other utility
-- functions.
--

local mod=require 'core/mods'
local textentry=require('textentry')

--
-- [optional] a mod is like any normal lua module. local variables can be used
-- to hold any state which needs to be accessible across hooks, the menu, and
-- any api provided by the mod itself.
--
-- here a single table is used to hold some x/y values
--

local state={
  x=1,
  is_running=false,
  advertise="false",
  archive="false",
  station="",
}

--
-- [optional] hooks are essentially callbacks which can be used by multiple mods
-- at the same time. each function registered with a hook must also include a
-- name. registering a new function with the name of an existing function will
-- replace the existing function. using descriptive names (which include the
-- name of the mod itself) can help debugging because the name of a callback
-- function will be printed out by matron (making it visible in mainden) before
-- the callback function is called.
--
-- here we have dummy functionality to help confirm things are getting called
-- and test out access to mod level state via mod supplied fuctions.
--

mod.hook.register("system_post_startup","broadcast mod setup",function()
  state.system_post_startup=true
  os.execute("chmod +x /home/we/dust/code/broadcast/broadcast0.sh")
  os.execute("chmod +x /home/we/dust/code/broadcast/broadcast1.sh")
  os.execute("chmod +x /home/we/dust/code/broadcast/broadcast2.sh")
  local toinstall=""
  local s=util.os_capture("which icecast2")
  if s=="" then
    print("installing icecast2")
    toinstall=toinstall.."icecast2 "
  end
  local s=util.os_capture("which darkice")
  if s=="" then
    print("installing darkice")
    toinstall=toinstall.."darkice "
  end
  if toinstall~="" then
    local cmd="DEBIAN_FRONTEND=noninteractive sudo apt-get install -q -y "..toinstall
    print('running '..cmd)
    os.execute("sudo apt-get update")
    os.execute(cmd)
  end
end)

mod.hook.register("script_pre_init","broadcast mod init",function()
end)

--
-- [optional] menu: extending the menu system is done by creating a table with
-- all the required menu functions defined.
--

local m={}

m.toggle_station=function(start)
  -- start/stop station
  os.execute("pkill -f broadcast0")
  os.execute("pkill -f broadcast2")
  os.execute("pkill -f radio.mp3")
  os.execute("pkill -f broadcast1")
  os.execute("pkill -9 icecast2")
  os.execute("pkill -9 darkice")
  if (state.is_running==false or start==true) and state.station~="" then
    os.execute("nohup /home/we/dust/code/broadcast/broadcast0.sh "..state.station.." "..state.advertise.." "..state.archive.." &")
    state.is_running=true
  else
    state.is_running=false
  end
end

m.key=function(n,z)
  if n==2 and z==1 then
    -- return to the mod selection menu
    mod.menu.exit()
  end
  if n==3 and z==1 then
    if state.x==3 then  
      state.advertise=state.advertise=="false" and "true" or "false"
      local f=io.open(_path.data.."broadcast/advertise","w")
      f:write(state.advertise)
      io.close(f)
      if state.is_running then 
        m.toggle_station(true)
      end
    elseif state.x==4 then  
      state.archive=state.archive=="false" and "true" or "false"
      local f=io.open(_path.data.."broadcast/archive","w")
      f:write(state.archive)
      io.close(f)
      if state.is_running then 
        m.toggle_station(true)
      end
    elseif state.x==2 then
      -- change station
      textentry.enter(function(x)
        if x==nil then
          do return end
        end
        print("new station: "..x)
        state.station=x:gsub("%s+","")
        local f=io.open(_path.data.."broadcast/station","w")
        f:write(state.station)
        io.close(f)
        if state.is_running then 
          m.toggle_station(true)
        end
        mod.menu.redraw()
      end,state.station,"enter a station name")
    elseif state.x==1 then
      m.toggle_station()
    end
  end
  mod.menu.redraw()
end

m.enc=function(n,d)
  if d>0 then 
    d=1 
  elseif d<0 then 
    d=-1 
  end
  state.x=util.clamp(state.x+d,1,4)
  mod.menu.redraw()
end

m.redraw=function()
  local yy=-8
  screen.clear()
  screen.level(state.x==1 and 15 or 5)
  screen.move(64,20+yy)
  screen.text_center(state.is_running and "online" or "offline")
  if state.station~="" then
    screen.level(5)
    screen.move(64,32+yy)
    screen.text_center("broadcast.norns.online/")
    screen.move(64,40+yy)
    screen.text_center(state.station..".mp3")
  end
  screen.level(state.x==2 and 15 or 5)
  screen.move(64,52+yy)
  screen.text_center("edit station name")
  screen.level(state.x==3 and 15 or 5)
  screen.move(35,62+yy)
  screen.text_center("advertise:"..state.advertise)
  screen.level(state.x==4 and 15 or 5)
  screen.move(36+64,62+yy)
  screen.text_center("archive:"..state.archive)
  screen.update()
end

m.init=function()
  print("menu init")
  state.is_running=false
  state.station=""
  if not util.file_exists(_path.data.."broadcast") then
    os.execute("mkdir -p ".._path.data.."broadcast")
  end
  local fname=_path.data.."broadcast/station"
  if util.file_exists(fname) then
    local f=assert(io.open(fname,"rb"))
    if f~=nil then
      local content=f:read("*all")
      f:close()
      if content~=nil then
        state.station=(content:gsub("^%s*(.-)%s*$","%1"))
        state.station=state.station:gsub("%s+","")
      end
    end
  end
  local fname=_path.data.."broadcast/advertise"
  if util.file_exists(fname) then
    local f=assert(io.open(fname,"rb"))
    if f~=nil then
      local content=f:read("*all")
      f:close()
      if content~=nil then
        state.advertise=(content:gsub("^%s*(.-)%s*$","%1"))
      end
    end
  end
  local fname=_path.data.."broadcast/archive"
  if util.file_exists(fname) then
    local f=assert(io.open(fname,"rb"))
    if f~=nil then
      local content=f:read("*all")
      f:close()
      if content~=nil then
        state.archive=(content:gsub("^%s*(.-)%s*$","%1"))
      end
    end
  end
  state.is_running=string.find(util.os_capture("ps aux | grep broadcast0 | grep -v grep"),"broadcast0")
  if state.is_running==nil then
    state.is_running=false
  end
end -- on menu entry, ie, if you wanted to start timers

m.deinit=function() end -- on menu exit

-- register the mod menu
--
-- NOTE: `mod.this_name` is a convienence variable which will be set to the name
-- of the mod which is being loaded. in order for the menu to work it must be
-- registered with a name which matches the name of the mod in the dust folder.
--
mod.menu.register(mod.this_name,m)

--
-- [optional] returning a value from the module allows the mod to provide
-- library functionality to scripts via the normal lua `require` function.
--
-- NOTE: it is important for scripts to use `require` to load mod functionality
-- instead of the norns specific `include` function. using `require` ensures
-- that only one copy of the mod is loaded. if a script were to use `include`
-- new copies of the menu, hook functions, and state would be loaded replacing
-- the previous registered functions/menu each time a script was run.
--
-- here we provide a single function which allows a script to get the mod's
-- state table. using this in a script would look like:
--
-- local mod = require 'name_of_mod/lib/mod'
-- local the_state = mod.get_state()
--
local api={}

api.get_state=function()
  return state
end

return api

