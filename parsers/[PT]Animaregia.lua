Animeregia=Parser:new("Animeregia","https://animaregia.net","PRT","ANIMEREGIAPTG",2)Animeregia.Letters={"#","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}Animeregia.Tags={"Action","Adventure","Comedy","Doujinshi","Drama","Ecchi","Fantasy","Gender Bender","Harem","Historical","Horror","Josei","Martial Arts","Mature","Mecha","Mystery","One Shot","Psychological","Romance","School Life","Sci-fi","Seinen","Shoujo","Shoujo Ai","Shounen","Shounen Ai","Slice of Life","Sports","Supernatural","Tragedy","Yaoi","Yuri"}Animeregia.TagValues={["Action"]="1",["Adventure"]="2",["Comedy"]="3",["Doujinshi"]="4",["Drama"]="5",["Ecchi"]="6",["Fantasy"]="7",["Gender Bender"]="8",["Harem"]="9",["Historical"]="10",["Horror"]="11",["Josei"]="12",["Martial Arts"]="13",["Mature"]="14",["Mecha"]="15",["Mystery"]="16",["One Shot"]="17",["Psychological"]="18",["Romance"]="19",["School Life"]="20",["Sci-fi"]="21",["Seinen"]="22",["Shoujo"]="23",["Shoujo Ai"]="24",["Shounen"]="25",["Shounen Ai"]="26",["Slice of Life"]="27",["Sports"]="28",["Supernatural"]="29",["Tragedy"]="30",["Yaoi"]="31",["Yuri"]="32"}local function a(b)return b:gsub("&#([^;]-);",function(c)local d=tonumber("0"..c)or tonumber(c)return d and u8c(d)or"&#"..c..";"end):gsub("&(.-);",function(c)return HTML_entities and HTML_entities[c]and u8c(HTML_entities[c])or"&"..c..";"end)end;local function e(f)local g={}Threads.insertTask(g,{Type="StringRequest",Link=f,Table=g,Index="text"})while Threads.check(g)do coroutine.yield(false)end;return g.text or""end;function Animeregia:getManga(f,h)local i=e(f)h.NoPages=true;for j,k,l in i:gmatch("<a href=\"([^\"]-)\" class=\"thumbnail\">[^>]-src='([^']-)' alt='([^']-)'>[^<]-</a>")do h[#h+1]=CreateManga(a(l),j,self.Link..k,self.ID,j)h.NoPages=false;coroutine.yield(false)end end;function Animeregia:getPopularManga(m,h)self:getManga(self.Link.."/filterList?sortBy=views&asc=false&page="..m,h)end;function Animeregia:getLetterManga(m,h,n)self:getManga(self.Link.."/filterList?alpha="..n:gsub("#","Other").."&sortBy=name&asc=true&page="..m,h)end;function Animeregia:getTagManga(m,h,o)self:getManga(self.Link.."/filterList?alpha=&cat="..(self.TagValues[o]or"0").."&sortBy=name&asc=true&page="..m,h)end;function Animeregia:getLatestManga(m,h)local i=e(self.Link.."/latest-release?page="..m)h.NoPages=true;for j,l in i:gmatch('manga%-item.-href="([^"]-)">(.-)</a>')do local p=j:match("manga/(.*)/?")or""h[#h+1]=CreateManga(a(l),j,self.Link.."/uploads/manga/"..p.."/cover/cover_250x350.jpg",self.ID,j)h.NoPages=false;coroutine.yield(false)end end;function Animeregia:searchManga(q,m,h)self:getManga(self.Link.."/filterList?alpha="..q.."&sortBy=views&asc=false&page="..m,h)end;function Animeregia:getChapters(r,h)local i=e(r.Link)local s={}for j,l in i:gmatch("chapter%-title%-rtl\">[^<]-<a href=\"([^\"]-)\">([^<]-)</a>")do s[#s+1]={Name=a(l),Link=j,Pages={},Manga=r}end;for t=#s,1,-1 do h[#h+1]=s[t]end end;function Animeregia:prepareChapter(u,h)local i=e(u.Link)for j in i:gmatch("img%-responsive\"[^>]-data%-src=' ([^']-) '")do h[#h+1]=j end end;function Animeregia:loadChapterPage(f,h)h.Link=f end