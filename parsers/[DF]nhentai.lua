nhentai=Parser:new("nhentai","https://nhentai.net","DIF","NHENTAI",2)nhentai.NSFW=true;local function a(b)return b:gsub("&#([^;]-);",function(c)local d=tonumber("0"..c)or tonumber(c)return d and u8c(d)or"&#"..c..";"end):gsub("&(.-);",function(c)return HTML_entities and HTML_entities[c]and u8c(HTML_entities[c])or"&"..c..";"end)end;local function e(f)local g={}Threads.insertTask(g,{Type="StringRequest",Link=f,Table=g,Index="text"})while Threads.check(g)do coroutine.yield(false)end;return g.text or""end;function nhentai:getManga(f,h)local i=e(f)h.NoPages=true;for j,k,l in i:gmatch('class="gallery".-href="(%S-)".-data%-src="(%S-)".->([^<]-)</div>')do h[#h+1]=CreateManga(a(l),j,k,self.ID,self.Link..j)h.NoPages=false;coroutine.yield(false)end end;function nhentai:getPopularManga(m,h)self:getManga(self.Link.."/?page="..m,h)end;function nhentai:searchManga(n,m,h)self:getManga(self.Link.."/search/?q="..n.."&page="..m,h)end;function nhentai:getChapters(o,h)h[#h+1]={Name="Read chapter",Link=o.Link,Pages={},Manga=o}end;function nhentai:prepareChapter(p,h)local i=e(self.Link..p.Link)for f in i:gmatch('class="gallerythumb".-href="(%S-)"')do h[#h+1]=self.Link..f end end;function nhentai:loadChapterPage(f,h)h.Link=e(f):match('image%-container".-src="(%S-)"')end