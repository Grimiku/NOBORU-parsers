XoXoComics=Parser:new("XoXoComics","https://www.xoxocomics.com","ENG","XOXOCEN",1)local function a(b)return b:gsub("&#([^;]-);",function(c)local d=tonumber("0"..c)or tonumber(c)return d and u8c(d)or"&#"..c..";"end):gsub("&(.-);",function(c)return HTML_entities and HTML_entities[c]and u8c(HTML_entities[c])or"&"..c..";"end)end;local function e(f)local g={}Threads.insertTask(g,{Type="StringRequest",Link=f,Table=g,Index="text"})while Threads.check(g)do coroutine.yield(false)end;return g.text or""end;function XoXoComics:getManga(f,h)local i=e(f)h.NoPages=true;for j,k,l in i:gmatch('item">.-"image">[\r\n]<a title="(.-)" href=".-/comic/(.-)".-original="(%S-)" alt')do h[#h+1]=CreateManga(a(j),k,l,self.ID,self.Link.."/comic/"..k)h.NoPages=false;coroutine.yield(false)end end;function XoXoComics:getPopularManga(m,h)self:getManga(self.Link.."/hot?page="..m,h)end;function XoXoComics:getLatestManga(m,h)self:getManga(self.Link.."/",h)h.NoPages=true end;function XoXoComics:searchManga(n,m,h)self:getManga(self.Link.."/search?keyword="..n.."&page="..m,h)end;function XoXoComics:getChapters(o,h)local p={}local m=1;while true do local i=e(self.Link.."/comic/"..o.Link.."?page="..m)for k,j in i:gmatch('chapter">[\r\n]+<a href=".-/comic/.-/(.-)">(.-)</a>')do p[#p+1]={Name=a(j:gsub("[\r\n]"," ")),Link=k,Pages={},Manga=o}end;if i:find('rel="next">')then m=m+1 else break end;coroutine.yield(true)end;for q=#p,1,-1 do h[#h+1]=p[q]end end;function XoXoComics:prepareChapter(r,h)local i=e(self.Link.."/comic/"..r.Manga.Link.."/"..r.Link)h[#h+1]=self.Link.."/comic/"..r.Manga.Link.."/"..r.Link;for k in(i:match('id="selectPage"(.-)</select>')or""):gmatch('<option value="([^"]-)">%d-</option>')do h[#h+1]=k end end;function XoXoComics:loadChapterPage(f,h)local i=e(f)h.Link=i:match('class=\'page%-chapter\'><[^>]-src=\'([^\']-)\'')or i:match('class=\'page%-chapter\'><[^>]-src="([^\"]-)"')or""end