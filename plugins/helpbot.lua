local function run(msg, matches)
local telediamondsudo = [[
➖➖➖➖➖➖➖
》<code> Sudo Help </code>
》<code> for </code>  <b> TeleWhite </b>
➖➖➖➖➖➖➖
💢!add
❔نصب ربات در گروه
💢!rem
❔حذف ربات از گروه
💢!leave
❔خروج ربات از گروه
💢!creategroup (GPname)
❔ساختن گروه
💢!createsuper (GPname)
❔ساختن سوپر گروه
💢!banall @username
❔بن از لیست گروهای ربات
💢!unbanall @username
❔خارج کردن از بن لیست
💢!tosuper
❔تبدیل گپ به سوپر گپ
💢!support @username
❔افزودن کاربر به تیم پشتیبانی
(ربات در همه گروها به دستورات کاربر جواب خواهد داد)
💢!-support @username
❔حذف کاربر از تیم پشتیبانی
💢!import (link)
❔وارد شدن ربات به گروه با لینک
💢!setexpire (day)
❔تنظیم تاریخ انقضای گروه
💢!pattern (plugname)
❔نمایش پترن پلاگین ها
💢!get (plugname)
❔دریافت پلاگین در تلگرام
💢!p + plugname
❔فعال کردن پلاگین
💢!p - plugname
❔غیرفعال کردن پلاگین
💢!save plugname
❔افزودن پلاگین با ریپلی
💢!delplugin plugname
❔حذف پلاگین
(قبلا حذف پلاگین را غیرفعال کنید)
💢!reload
❔ریلود پلاگین ها
💢!broadcast (text)
❔ارسال پیام به همه گروها
💢!addcontact
❔افزودن مخاطب به اکانت ربات
💢!remcontact
❔حذف مخاطب
💢!markread (on/off)
❔تنظیم رید شدن پیام ها توسط ربات
💢!uptime
❔اپتایم انلاین بودن ربات
💢!setsudo
❔ارتقای مقام کاربری به عنوان سودو
💢!remsudo
❔تنزل مقام کاربر از مقام سودو
]]
local telediamond = [[

]]
local telediamond2 = [[

]]
local telediamond3 = [[

]]
local telediamond4 = [[
✔️لیست دستورات مدیریتی سوپر گروه:
🔱#info
〽️نمایش اطلاعات کلی در مورد سوپر گروه
🔱#setlang (fa,en)
〽️تعیین زبان گروه(fa=فارسی-en=انگلیسی)
🔱#who
〽️لیست کاربران گروه
🔱#me
〽️اطلاعاتی در باره شما در گروه 
🔱#admins
〽️لیست مدیران گروه
🔱#modlist
〽️لیست مدیران ربات
🔱#kick @username
〽️اخراج کاربر از گروه با آیدی یا ریپلی
🔱#invite @username
〽️دعوت کاربر به گروه
🔱#ban @username
〽️بن کردن کاربر با آیدی یا ریپلی
🔱#unban
〽️خارج کردن کاربر از بن لیست با آیدی یا ریپلی
🔱#id
〽️نمایش آیدی شما و آیدی سوپر گروه
🔱#id from
〽️گرفتن آیدی از پیام فوروارد شده با ریپلی
🔱#promote @username
〽️ترفیع رتبه کاربر به عنوان مدیر گروه با آیدی یا ریپلی
🔱#demote @username
〽️تنزل‌ رتبه مدیر به ممبر معمولی گروه با آیدی یا ریپلی
🔱#setname (groupname)
〽️تعیین نام گروه
🔱#setphoto
〽️تعیین عکس گروه
🔱#newlink
〽️ساخت لینک جدید برای گروه
🔱#setlink
〽️نشاندن لینک برای گروه
(بعد از زدن دستور لینک گروه را ارسال کنید.)
🔱#link
〽️گرفتن لینک گروه
🔱#rules
〽️نمایش قوانین گروه
🔱#setrules text
〽️تعیین قوانین گروه
🔱#mute [all|audio|gifs|photo|video|service]
〽️صامت کردن 🔅همه 🔅صداها 🔅گیف ها 🔅عکس 🔅ویدیو 🔅سرویس
🔱#muteall Xh Ym Zs
〽️صامت کردن همه کاربران تا زمانی مشخص
مانند:!muteall 2h 12m 56s
🔱#unmute [all|audio|gifs|photo|video|service]
〽️خارج کردن از صامت
🔱#setflood [value]
〽️تنظیم حساسیت اسپم(جای [value] عددی بین 1-20قراردهید)
🔱#settings
〽️تنظیمات گروه
🔱#silent @username
〽️ساکت کردن کاربری با آیدی یا ریپلی
🔱#unsilent @username
〽️خارج کردن کاربر از لیست صامت با آیدی یا ریپلی
🔱#silentlist
〽️لیست افراد صامت شده
🔱#mutelist
〽️لیست افراد صامت
🔱#banlist
〽️لیست افراد بن شده
🔱#filterlist
〽️لیست کلمات فیلتر
🔱#mutelist
〽️لیست افراد صامت
🔱#clean [rules|about|modlist|silentlist|filterlist]
〽️پاک کردن 🔅قوانین 🔅اطلاعات 🔅لیست مدیران 🔅لیست کاربران صامت 🔅لیست کلمات فیلتر
🔱#clean msg [value]
〽️حذف پیام های اخیر گروه (جای value عددی بین 1-200)

✨توضیحات:

➰جای @username آیدی کاربر را قرار بدید.

➰با ریپلی یعنی بر روی پیام کاربر ریپلی(جواب دادن)کرده و دستور را وارد کنید.

➰در صامت کردن زمان دار بجای X ساعت بجای Y دقیقه و بجای Z ثانیه را قرار بدید.
]]
local telediamond5 = [[
:| 
]]
local telediamond6 = [[
✔️لیست دستورات قفلی سوپر گروه:
🔱#lock text 
🔱#unlock text
1)✖️links
2)✖️flood
3)✖️spam
4)✖️Arabic
5)✖️member
6)✖️rtl
7)✖️sticker
8)✖️contacts
9)✖️strict
10)✖️tag
11)✖️username
12)✖️fwd
13)✖️cmd
14)✖️fosh
15)✖️tgservice
16)✖️leave
17)✖️join
18)✖️emoji
19)✖️english
20)✖️media
21)✖️operator
22)✖️bots
23)✖️edit
 〽️قفل کردن
〽️باز کردن قفل
1)✖️لینک
2)✖️پی ام تکراری
3)✖️اسپم
4)✖️عربی
5)✖️عضو
6)✖️اسم های بلند
7)✖️استیکر
8)✖️مخاطب ها
9)✖️سخت گیری
10)✖️تگ
11)✖️آیدی (@username)
12)✖️فوروراد
13)✖️دستورات
14)✖️فوش
15)✖️نمایش ورود و خروج
16)✖️ترک کردن گروه
17)✖️ورود به گروه
18)✖️شکلک
19)✖️انگلیسی
20)✖️رسانه(عکس و فیلم و...)
21)✖️اپراتور(تبلیغ شارژ رایگان)
22)✖️ربات ها
23)✖️ویرایش پیام
🌟بجای text گزینه مورد نظرتان را قرار بدین(گزینه های انگلیسی)
 با قفل هر کدام انجام یا فرستادن آن در گروه ممنوع میشود.

]]
local telediamond7 = [[
̴

✔️برای دیدن دستورات مورد نظر خود مورد دلخواه را ارسال کنید :

➰<b> English Commands </b> :

☆دستورات قفلی
🎗》#lockhelp
☆دستورات فان
🎗》#funhelp
☆دستورات مدیریتی
🎗》#modhelp


channel : @persianTDTch
]]
    if matches[1] == 'راهنمای مدیریتی' and is_momod(msg) then
        return telediamond  
  elseif matches[1] == 'sudohelp' and is_sudo(msg) or matches[1] == 'راهنمای سودو' and is_sudo(msg) then
    return telediamondsudo
  elseif matches[1] == 'راهنمای قفلی' and is_momod(msg) then
    return telediamond2
  elseif matches[1] == 'راهنمای فان' and is_momod(msg) then
    return telediamond3
  elseif matches[1] == 'modhelp' and is_momod(msg) then
    return telediamond4
  elseif matches[1] == 'funhelp' and is_momod(msg) then
    return telediamond5
  elseif matches[1] == 'lockhelp' and is_momod(msg) then
    return telediamond6
  elseif matches[1] == 'help' and is_momod(msg) or matches[1] == 'راهنما' and is_momod(msg) then
    return telediamond7
  end
end

return {
      description = '',
      usage = '',
      patterns = {
    '^[!#/](modhelp)$',
    '^[!#/](lockhelp)$',
    '^[!#/](help)$',
    '^[!#/](sudohelp)$',
      },
      run = run,
}

-- by @mrr619
-- ch @persianTDTch
