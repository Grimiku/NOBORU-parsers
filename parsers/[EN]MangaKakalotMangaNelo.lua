MangaKakalot=Parser:new("MangaKakalot","https://mangakakalot.com","ENG","MANGAKAKALOT",2)local a={["https://manganelo.com"]={"a%-h",'class="container%-chapter%-reader">(.-)$'},["https://mangakakalot.com"]={"row",'class="vung%-doc" id="vungdoc">(.-)$'}}local function b(c)return c:gsub("&#([^;]-);",function(d)local e=tonumber("0"..d)or tonumber(d)return e and u8c(e)or"&#"..d..";"end):gsub("&(.-);",function(d)return HTML_entities and HTML_entities[d]and u8c(HTML_entities[d])or"&"..d..";"end)end;local function f(g)local h={}Threads.insertTask(h,{Type="StringRequest",Link=g,Table=h,Index="string"})while Threads.check(h)do coroutine.yield(false)end;return h.string or""end;function MangaKakalot:getManga(g,i,j)local k=f(g..i)for l,m,n in k:gmatch('class="list%-truyen%-item%-wrap".-href="(%S-)".-src="(%S-)".-title="[^>]-">([^<]-)<')do local o=CreateManga(b(n),l:match("manga/(.-)$"),m:gsub("%%","%%%%"),self.ID,l)if o then o.Data.Source=l:match("(https://%S-)/")j[#j+1]=o;coroutine.yield(false)end end;local p=k:match("Last%((.-)%)")or k:match("LAST%((.-)%)")j.NoPages=p==nil or p==i end;function MangaKakalot:getPopularManga(i,j)self:getManga(self.Link.."/manga_list?type=topview&category=all&state=all&page=",i,j)end;function MangaKakalot:getLatestManga(i,j)self:getManga(self.Link.."/manga_list?type=latest&category=all&state=all&page=",i,j)end;function MangaKakalot:searchManga(q,i,j)local k=f(self.Link.."/search/"..q.."?page="..i)for l,m,n in k:gmatch('class="story_item".-href="(%S-)".-src="(%S-)".-href="[^>]-">([^<]-)<')do local o=CreateManga(b(n),l:match("manga/(.-)$"),m:gsub("%%","%%%%"),self.ID,l)if o then o.Data.Source=l:match("(https://%S-)/")j[#j+1]=o end;coroutine.yield(false)end;local p=k:match("Last%((.-)%)")or k:match("LAST%((.-)%)")j.NoPages=p==nil or p==i end;function MangaKakalot:getChapters(o,j)local k=f(o.Data.Source.."/manga/"..o.Link)local r={}for l,n in k:gmatch('class="'..a[o.Data.Source][1]..'">.-href="(%S-)" title=".-">([^<]-)<')do r[#r+1]={Name=n,Link=l:match(".+/(.-)$"),Pages={},Manga=o}end;for s=#r,1,-1 do j[#j+1]=r[s]end end;function MangaKakalot:prepareChapter(t,j)local k=f(t.Manga.Data.Source.."/chapter/"..t.Manga.Link.."/"..t.Link):match(a[t.Manga.Data.Source][2])or""for l in k:gmatch('img src="(%S-)" alt')do j[#j+1]={Link=l:gsub("%%","%%%%"),Header1="referer: "..t.Manga.Data.Source.."/chapter/"..t.Manga.Link.."/"..t.Link}end end;function MangaKakalot:loadChapterPage(g,j)j.Link=g end;MangaNelo=MangaKakalot:new("MangaNelo","https://manganelo.com","ENG","MANGANELO",2)function MangaNelo:getManga(g,i,j)local k=f(g..i)for l,m,n in k:gmatch('class="content%-genres%-item".-href="(%S-)".-src="(%S-)".-title="[^>]-">([^<]-)<')do local o=CreateManga(b(n),l:match("manga/(.-)$"),m:gsub("%%","%%%%"),self.ID,l)if o then o.Data.Source=l:match("(https://%S-)/")j[#j+1]=o;coroutine.yield(false)end end;local p=k:match("Last%((.-)%)")or k:match("LAST%((.-)%)")j.NoPages=p==nil or p==i end;function MangaNelo:getPopularManga(i,j)self:getManga(self.Link.."/genre-all?type=topview&category=all&state=all&page=",i,j)end;function MangaNelo:getLatestManga(i,j)self:getManga(self.Link.."/genre-all?type=latest&category=all&state=all&page=",i,j)end;function MangaNelo:searchManga(q,i,j)local k=f(self.Link.."/search/"..q.."?page="..i)for l,m,n in k:gmatch('class="search%-story%-item".-href="(%S-)".-src="(%S-)".-title="[^>]-">([^<]-)<')do local o=CreateManga(b(n),l:match("manga/(.-)$"),m:gsub("%%","%%%%"),self.ID,l)if o then o.Data.Source=l:match("(https://%S-)/")j[#j+1]=o end;coroutine.yield(false)end;local p=k:match("Last%((.-)%)")or k:match("LAST%((.-)%)")j.NoPages=p==nil or p==i end