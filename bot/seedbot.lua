 package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua' 
2   ..';.luarocks/share/lua/5.2/?/init.lua' 
3 package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so' 
4 
 
5 require("./bot/utils") 
6 
 
7 local f = assert(io.popen('/usr/bin/git describe --tags', 'r')) 
8 VERSION = assert(f:read('*a')) 
9 f:close() 
10 
 
11 -- This function is called when tg receive a msg 
12 function on_msg_receive (msg) 
13   if not started then 
14     return 
15   end 
16 
 
17   msg = backward_msg_format(msg) 
18 
 
19   local receiver = get_receiver(msg) 
20   print(receiver) 
21   --vardump(msg) 
22   --vardump(msg) 
23   msg = pre_process_service_msg(msg) 
24   if msg_valid(msg) then 
25     msg = pre_process_msg(msg) 
26     if msg then 
27       match_plugins(msg) 
28       if redis:get("bot:markread") then 
29         if redis:get("bot:markread") == "on" then 
30           mark_read(receiver, ok_cb, false) 
31         end 
32       end 
33     end 
34   end 
35 end 
36 
 
37 function ok_cb(extra, success, result) 
38 
 
39 end 
40 
 
41 function on_binlog_replay_end() 
42   started = true 
43   postpone (cron_plugins, false, 60*5.0) 
44   -- See plugins/isup.lua as an example for cron 
45 
 
46   _config = load_config() 
47 
 
48   -- load plugins 
49   plugins = {} 
50   load_plugins() 
51 end 
52 
 
53 function msg_valid(msg) 
54   -- Don't process outgoing messages 
55   if msg.out then 
56     print('\27[36mNot valid: msg from us\27[39m') 
57     return false 
58   end 
59 
 
60   -- Before bot was started 
61   if msg.date < os.time() - 5 then 
62     print('\27[36mNot valid: old msg\27[39m') 
63     return false 
64   end 
65 
 
66   if msg.unread == 0 then 
67     print('\27[36mNot valid: readed\27[39m') 
68     return false 
69   end 
70 
 
71   if not msg.to.id then 
72     print('\27[36mNot valid: To id not provided\27[39m') 
73     return false 
74   end 
75 
 
76   if not msg.from.id then 
77     print('\27[36mNot valid: From id not provided\27[39m') 
78     return false 
79   end 
80 
 
81   if msg.from.id == our_id then 
82     print('\27[36mNot valid: Msg from our id\27[39m') 
83     return false 
84   end 
85 
 
86   if msg.to.type == 'encr_chat' then 
87     print('\27[36mNot valid: Encrypted chat\27[39m') 
88     return false 
89   end 
90 
 
91   if msg.from.id == 777000 then 
92     --send_large_msg(*group id*, msg.text) *login code will be sent to GroupID* 
93     return false 
94   end 
95 
 
96   return true 
97 end 
98 
 
99 -- 
100 function pre_process_service_msg(msg) 
101    if msg.service then 
102       local action = msg.action or {type=""} 
103       -- Double ! to discriminate of normal actions 
104       msg.text = "!!tgservice " .. action.type 
105 
 
106       -- wipe the data to allow the bot to read service messages 
107       if msg.out then 
108          msg.out = false 
109       end 
110       if msg.from.id == our_id then 
111          msg.from.id = 0 
112       end 
113    end 
114    return msg 
115 end 
116 
 
117 -- Apply plugin.pre_process function 
118 function pre_process_msg(msg) 
119   for name,plugin in pairs(plugins) do 
120     if plugin.pre_process and msg then 
121       print('Preprocess', name) 
122       msg = plugin.pre_process(msg) 
123     end 
124   end 
125   return msg 
126 end 
127 
 
128 -- Go over enabled plugins patterns. 
129 function match_plugins(msg) 
130   for name, plugin in pairs(plugins) do 
131     match_plugin(plugin, name, msg) 
132   end 
133 end 
134 
 
135 -- Check if plugin is on _config.disabled_plugin_on_chat table 
136 local function is_plugin_disabled_on_chat(plugin_name, receiver) 
137   local disabled_chats = _config.disabled_plugin_on_chat 
138   -- Table exists and chat has disabled plugins 
139   if disabled_chats and disabled_chats[receiver] then 
140     -- Checks if plugin is disabled on this chat 
141     for disabled_plugin,disabled in pairs(disabled_chats[receiver]) do 
142       if disabled_plugin == plugin_name and disabled then 
143         local warning = 'Plugin '..disabled_plugin..' is disabled on this chat' 
144         print(warning) 
145         send_msg(receiver, warning, ok_cb, false) 
146         return true 
147       end 
148     end 
149   end 
150   return false 
151 end 
152 
 
153 function match_plugin(plugin, plugin_name, msg) 
154   local receiver = get_receiver(msg) 
155 
 
156   -- Go over patterns. If one matches it's enough. 
157   for k, pattern in pairs(plugin.patterns) do 
158     local matches = match_pattern(pattern, msg.text) 
159     if matches then 
160       print("msg matches: ", pattern) 
161 
 
162       if is_plugin_disabled_on_chat(plugin_name, receiver) then 
163         return nil 
164       end 
165       -- Function exists 
166       if plugin.run then 
167         -- If plugin is for privileged users only 
168         if not warns_user_not_allowed(plugin, msg) then 
169           local result = plugin.run(msg, matches) 
170           if result then 
171             send_large_msg(receiver, result) 
172           end 
173         end 
174       end 
175       -- One patterns matches 
176       return 
177     end 
178   end 
179 end 
180 
 
181 -- DEPRECATED, use send_large_msg(destination, text) 
182 function _send_msg(destination, text) 
183   send_large_msg(destination, text) 
184 end 
185 
 
186 -- Save the content of _config to config.lua 
187 function save_config( ) 
188   serialize_to_file(_config, './data/config.lua') 
189   print ('saved config into ./data/config.lua') 
190 end 
191 
 
192 -- Returns the config from config.lua file. 
193 -- If file doesn't exist, create it. 
194 function load_config( ) 
195   local f = io.open('./data/config.lua', "r") 
196   -- If config.lua doesn't exist 
197   if not f then 
198     print ("Created new config file: data/config.lua") 
199     create_config() 
200   else 
201     f:close() 
202   end 
203   local config = loadfile ("./data/config.lua")() 
204   for v,user in pairs(config.sudo_users) do 
205     print("Sudo user: " .. user) 
206   end 
207   return config 
208 end 
209 
 
210 -- Create a basic config.json file and saves it. 
211 function create_config( ) 
212   -- A simple config with basic plugins and ourselves as privileged user 
213   config = { 
214     enabled_plugins = { 
215 	 "admin", 
216     "inrealm", 
217     "ingroup", 
218     "inpm", 
219     "banhammer", 
220     "anti_spam", 
221     "owners", 
222     "arabic_lock", 
223     "set", 
224     "get", 
225     "broadcast", 
226     "invite", 
227     "all", 
228     "leave_ban", 
229     "whitelist", 
230     "saveplug", 
231     "plug", 
232     "lock_username", 
233     "lock_tag", 
234     "lock_operator", 
235     "lock_media", 
236     "lock_join", 
237     "lock_fwd", 
238     "lock_fosh", 
239     "antiemoji", 
240     "lock_english", 
241     "cleandeleted", 
242     "muteall", 
243     "patterns", 
244     "kickme", 
245     "info", 
246     "expire", 
247     "filter", 
248     "filterfa", 
249     "msg_checks", 
250     "stats", 
251     "fun", 
252     "setlang", 
253     "setlangfa", 
254     "onservice", 
255     "supergroup", 
256     "TDhelps", 
257     "setwlc", 
258     "lock_edit", 
259     "lock_cmds", 
260     "uptime", 
261     "setsudo" 
262     }, 
263     sudo_users = {209333197,0,tonumber(our_id)},--Sudo users 
264     moderation = {data = 'data/moderation.json'}, 
265     about_text = [[》TeleWhite  v2 
266 》Creator :@ciltdt 
267 
270 Id Channel: 
271 @persianTDTch 
272  
273 ]], 
274     help_text_realm = [[ 
275 Realm Commands: 
276  
277 !creategroup [Name] 
278 Create a group 
279  
280 !createrealm [Name] 
281 Create a realm 
282  
283 !setname [Name] 
284 Set realm name 
285  
286 !setabout [group|sgroup] [GroupID] [Text] 
287 Set a group's about text 
288  
289 !setrules [GroupID] [Text] 
290 Set a group's rules 
291  
292 !lock [GroupID] [setting] 
293 Lock a group's setting 
294  
295 !unlock [GroupID] [setting] 
296 Unock a group's setting 
297  
298 !settings [group|sgroup] [GroupID] 
299 Set settings for GroupID 
300  
301 !wholist 
302 Get a list of members in group/realm 
303  
304 !who 
305 Get a file of members in group/realm 
306  
307 !type 
308 Get group type 
309  
310 !kill chat [GroupID] 
311 Kick all memebers and delete group 
312  
313 !kill realm [RealmID] 
314 Kick all members and delete realm 
315  
316 !addadmin [id|username] 
317 Promote an admin by id OR username *Sudo only 
318  
319 !removeadmin [id|username] 
320 Demote an admin by id OR username *Sudo only 
321  
322 !list groups 
323 Get a list of all groups 
324  
325 !list realms 
326 Get a list of all realms 
327  
328 !support 
329 Promote user to support 
330  
331 !-support 
332 Demote user from support 
333  
334 !log 
335 Get a logfile of current group or realm 
336  
337 !broadcast [text] 
338 !broadcast Hello ! 
339 Send text to all groups 
340 Only sudo users can run this command 
341  
342 !bc [group_id] [text] 
343 !bc 123456789 Hello ! 
344 This command will send text to [group_id] 
345  
346  
347 **You can use "#", "!", or "/" to begin all commands 
348  
349  
350 *Only admins and sudo can add bots in group 
351  
352  
353 *Only admins and sudo can use kick,ban,unban,newlink,setphoto,setname,lock,unlock,set rules,set about and settings commands 
354  
355 *Only admins and sudo can use res, setowner, commands 
356 ]], 
357     help_text = [[]], 
358 	help_text_super =[[]], 
359   } 
360   serialize_to_file(config, './data/config.lua') 
361   print('saved config into ./data/config.lua') 
362 end 
363 
 
364 function on_our_id (id) 
365   our_id = id 
366 end 
367 
 
368 function on_user_update (user, what) 
369   --vardump (user) 
370 end 
371 
 
372 function on_chat_update (chat, what) 
373   --vardump (chat) 
374 end 
375 
 
376 function on_secret_chat_update (schat, what) 
377   --vardump (schat) 
378 end 
379 
 
380 function on_get_difference_end () 
381 end 
382 
 
383 -- Enable plugins in config.json 
384 function load_plugins() 
385   for k, v in pairs(_config.enabled_plugins) do 
386     print("Loading plugin", v) 
387 
 
388     local ok, err =  pcall(function() 
389       local t = loadfile("plugins/"..v..'.lua')() 
390       plugins[v] = t 
391     end) 
392 
 
393     if not ok then 
394       print('\27[31mError loading plugin '..v..'\27[39m') 
395 	  print(tostring(io.popen("lua plugins/"..v..".lua"):read('*all'))) 
396       print('\27[31m'..err..'\27[39m') 
397     end 
398 
 
399   end 
400 end 
401 
 
402 -- custom add 
403 function load_data(filename) 
404 
 
405 	local f = io.open(filename) 
406 	if not f then 
407 		return {} 
408 	end 
409 	local s = f:read('*all') 
410 	f:close() 
411 	local data = JSON.decode(s) 
412 
 
413 	return data 
414 
 
415 end 
416 
 
417 function save_data(filename, data) 
418 
 
419 	local s = JSON.encode(data) 
420 	local f = io.open(filename, 'w') 
421 	f:write(s) 
422 	f:close() 
423 
 
424 end 
425 
 
426 
 
427 -- Call and postpone execution for cron plugins 
428 function cron_plugins() 
429 
 
430   for name, plugin in pairs(plugins) do 
431     -- Only plugins with cron function 
432     if plugin.cron ~= nil then 
433       plugin.cron() 
434     end 
435   end 
436 
 
437   -- Called again in 2 mins 
438   postpone (cron_plugins, false, 120) 
439 end 
440 
 
441 -- Start and load values 
442 our_id = 0 
443 now = os.time() 
444 math.randomseed(now) 
445 started = false 
