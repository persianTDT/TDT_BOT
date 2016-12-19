 local function pre_process(msg) 
4 	local timetoexpire = 'unknown' 
5 	local expiretime = redis:hget ('expiretime', get_receiver(msg)) 
6 	local now = tonumber(os.time()) 
7 	if expiretime then     
8 		timetoexpire = math.floor((tonumber(expiretime) - tonumber(now)) / 86400) + 1 
9 		if tonumber("0") > tonumber(timetoexpire) and not is_sudo(msg) then 
10 		if msg.text:match('/') then 
11 			return send_large_msg(get_receiver(msg), '<code> توجه!توجه! </code>\n<i> تاریخ انقضای ربات به پایان رسید!') 
12 		else 
13 			return 
14 		end 
15 	end 
16 	if tonumber(timetoexpire) == 0 then 
17 		if redis:hget('expires0',msg.to.id) then return msg end 
18 		send_large_msg(get_receiver(msg), '<i> تاریخ انقضایی ربات به پایان رسیده </i>\n<code> جهت تمدید به ایدی زیر مراجعه کنید! </code>\n@cilTDT ') 
19 		redis:hset('expires0',msg.to.id,'5') 
20 	end 
21 	if tonumber(timetoexpire) == 1 then 
22 		if redis:hget('expires1',msg.to.id) then return msg end 
23 		send_large_msg(get_receiver(msg), '1 روز تا پایان تاریخ انقضای گروه باقی مانده است\nنسبت به تمدید اقدام کنید.') 
24 		redis:hset('expires1',msg.to.id,'5') 
25 	end 
26 	if tonumber(timetoexpire) == 2 then 
27 		if redis:hget('expires2',msg.to.id) then return msg end 
28 		send_large_msg(get_receiver(msg), '2 روز تا پایان تاریخ انقضای گروه باقی مانده است\nنسبت به تمدید اقدام کنید.') 
29 		redis:hset('expires2',msg.to.id,'5') 
30 	end 
31 	if tonumber(timetoexpire) == 3 then 
32 		if redis:hget('expires3',msg.to.id) then return msg end 
33 		send_large_msg(get_receiver(msg), '3 روز تا پایان تاریخ انقضای گروه باقی مانده است\nنسبت به تمدید اقدام کنید.') 
34 		redis:hset('expires3',msg.to.id,'5') 
35 	end 
36 	if tonumber(timetoexpire) == 4 then 
37 		if redis:hget('expires4',msg.to.id) then return msg end 
38 		send_large_msg(get_receiver(msg), '4 روز تا پایان تاریخ انقضای گروه باقی مانده است\nنسبت به تمدید اقدام کنید.') 
39 		redis:hset('expires4',msg.to.id,'5') 
40 	end 
41 	if tonumber(timetoexpire) == 5 then 
42 		if redis:hget('expires5',msg.to.id) then return msg end 
43 		send_large_msg(get_receiver(msg), '5 روز تا پایان تاریخ انقضای گروه باقی مانده است\nنسبت به تمدید اقدام کنید.') 
44 		redis:hset('expires5',msg.to.id,'5') 
45 	end 
46 end 
47 return msg 
48 end 
49 function run(msg, matches) 
50 	if matches[1]:lower() == 'setexpire' then 
51 		if not is_sudo(msg) then return end 
52 		local time = os.time() 
53 		local buytime = tonumber(os.time()) 
54 		local timeexpire = tonumber(buytime) + (tonumber(matches[2]) * 86400) 
55 		redis:hset('expiretime',get_receiver(msg),timeexpire) 
56 		return "تاریخ انقضای گروه:\nبه "..matches[2].. " روز دیگر تنظیم شد." 
57 	end 
58 	if matches[1]:lower() == 'expire' then 
59 		local expiretime = redis:hget ('expiretime', get_receiver(msg)) 
60 		if not expiretime then return '<i> تاریخ ست نشده است </i>' else 
61 			local now = tonumber(os.time()) 
62 			return (math.floor((tonumber(expiretime) - tonumber(now)) / 86400) + 1) .. " روز دیگر" 
63 		end 
64 	end 
65 
 
66 end 
67 return { 
68   patterns = { 
69     "^[!#/]([Ss]etexpire) (.*)$", 
70 	"^[!/#]([Ee]xpire)$", 
71   }, 
72   run = run, 
73   pre_process = pre_process 
74 } 

--@ciltdt
