-- TENDING THE WAVES
-- play radio Aporee on Norns
-- @maaark
-- after idea of @mlogger @Justmat @infinitedigits
-- !! Requires MPV installed, run 'sudo apt-get install mpv' once, might require 'sudo apt-get update' before!


-- require the `mods` module to gain access to hooks, menu, and other utility
-- functions.
--

local mod=require 'core/mods'

--
-- [optional] a mod is like any normal lua module. local variables can be used
-- to hold any state which needs to be accessible across hooks, the menu, and
-- any api provided by the mod itself.
--
-- here a single table is used to hold some x/y values
--

local state={
  x=0,
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
  print(s)
  if s=="" then 
	  print("installing icecast2")
	  toinstall=toinstall.."icecast2 "
  end
  local s=util.os_capture("which darkice")
  print(s)
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
  if not util.file_exists(_path.data.."broadcast") then
	  os.execute("mkdir -p ".._path.data.."broadcast")
  end
  local fname=_path.data.."broadcast/station"
  local station=""
  if util.file_exists(fname) then 
	  local f=assert(io.open(fname,"rb"))
	  if f~=nil then 
	  	local content=f:read("*all")
	  	f:close()
	  	if content~=nil then 
			  station=(content:gsub("^%s*(.-)%s*$", "%1"))
	  	end
	end
  end

  local is_running=string.find(util.os_capture("ps aux | grep broadcast0 | grep -v grep"),"broadcast0")
  params:add_group("BROADCAST",4)
  params:add_text("broadcast station","station name",station)
  params:set_action("broadcast station",function(x)
	  local f=io.open(_path.data.."broadcast/station","w")
	  f:write(x)
	  io.close(f)
  end)
  params:add_option("broadcast","broadcast",{"no","yes"},is_running and 2 or 1)
  params:add_text("broadcast url","",is_running and "broadcast.norns.online/" or "")
  params:add_text("broadcast url2","",is_running and station..".mp3" or "")
  params:set_action("broadcast",function(x)
	  local station=params:get("broadcast station")
	  if station=="" or station==nil or x==1 then 
	  params:hide("broadcast url")
	  params:hide("broadcast url2")
	  _menu.rebuild_params()
		  os.execute("pkill -f broadcast0")
		  os.execute("pkill -f broadcast2")
		  os.execute("pkill -f radio.mp3")
		  os.execute("pkill -f broadcast1")
		  os.execute("pkill -9 icecast2")
		  os.execute("pkill -9 darkice")
		  do return end
	  end
          os.execute("nohup /home/we/dust/code/broadcast/broadcast0.sh "..station.." &")
	  params:set("broadcast url","broadcast.norns.online/")
	  params:set("broadcast url2",station..".mp3")
	  params:show("broadcast url")
	  params:show("broadcast url2")
	  _menu.rebuild_params()
  end)
  if not is_running then 
	  params:hide("broadcast url")
	  params:hide("broadcast url2")
  end
end)


--
-- [optional] menu: extending the menu system is done by creating a table with
-- all the required menu functions defined.
--

local m={}

m.key=function(n,z)
  if n==2 and z==1 then
    -- return to the mod selection menu
    mod.menu.exit()
  end
end

m.enc=function(n,d)
  -- tell the menu system to redraw, which in turn calls the mod's menu redraw
  -- function
  mod.menu.redraw()
end

m.redraw=function()
  screen.clear()
--  screen.move(64,40)
--  screen.text_center("radio aporee  "..state.x)
  screen.update()
end

m.init=function()

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

