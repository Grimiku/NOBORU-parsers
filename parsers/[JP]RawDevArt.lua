RawDevArt=Parser:new("RawDevArt","https://rawdevart.com","JAP","RAWDEVARTJP",2)RawDevArt.Filters={{Name="Types",Type="checkcross",Tags={"Manga","Webtoon - Korean","Webtoon - Chinese","Webtoon - Japanese","Manhwa - Korean","Manhua - Chinese","Comic","Doujinshi"}},{Name="Status",Type="checkcross",Tags={"Ongoing","Haitus","Axed","Unknown","Finished"}},{Name="Genre",Type="checkcross",Tags={"4-koma","Action","Adult","Adventure","Comedy","Cooking","Crime","Drama","Ecchi","Fantasy","Gender Bender","Gore","Harem","Historical","Horror","Isekai","Josei","Lolicon","Martial Arts","Mature","Mecha","Medical","Music","Mystery","Philosophical","Psychological","Romance","School Life","Sci-Fi","Seinen","Shotacon","Shoujo","Shoujo Ai","Shounen","Shounen Ai","Slice of Life","Smut","Sports","Supernatural","Super Powers","Thriller","Tragedy","Wuxia","Yaoi","Yuri"}}}RawDevArt.Keys={["Manga"]="0",["Webtoon - Korean"]="1",["Webtoon - Chinese"]="6",["Webtoon - Japanese"]="7",["Manhwa - Korean"]="2",["Manhua - Chinese"]="3",["Comic"]="4",["Doujinshi"]="5",["Ongoing"]="0",["Haitus"]="1",["Axed"]="2",["Unknown"]="3",["Finished"]="4",["4-koma"]="29",["Action"]="1",["Adult"]="37",["Adventure"]="2",["Comedy"]="3",["Cooking"]="33",["Crime"]="4",["Drama"]="5",["Ecchi"]="30",["Fantasy"]="6",["Gender Bender"]="34",["Gore"]="31",["Harem"]="39",["Historical"]="7",["Horror"]="8",["Isekai"]="9",["Josei"]="42",["Lolicon"]="48",["Martial Arts"]="35",["Mature"]="36",["Mecha"]="10",["Medical"]="11",["Music"]="38",["Mystery"]="12",["Philosophical"]="13",["Psychological"]="14",["Romance"]="15",["School Life"]="40",["Sci-Fi"]="16",["Seinen"]="41",["Shotacon"]="49",["Shoujo"]="28",["Shoujo Ai"]="17",["Shounen"]="27",["Shounen Ai"]="18",["Slice of Life"]="19",["Smut"]="32",["Sports"]="20",["Supernatural"]="43",["Super Powers"]="21",["Thriller"]="22",["Tragedy"]="23",["Wuxia"]="24",["Yaoi"]="25",["Yuri"]="26"}RawDevArt.NSFW=false;local function a(b)return b:gsub("&#([^;]-);",function(c)local d=tonumber("0"..c)or tonumber(c)return d and u8c(d)or"&#"..c..";"end):gsub("&(.-);",function(c)return HTML_entities and HTML_entities[c]and u8c(HTML_entities[c])or"&"..c..";"end)end;local function e(f)local g={}Threads.insertTask(g,{Type="StringRequest",Link=f,Table=g,Index="string"})while Threads.check(g)do coroutine.yield(false)end;return g.string or""end;function RawDevArt:getManga(f,h,i)local j=e(f.."&page="..h)for k,l,m in j:gmatch('hovereffect.-img%-fluid" src="(%S-)".-d%-block">\n(.-)\n.-href="(%S-)"')do if not k:find("^http")then k=self.Link..k end;i[#i+1]=CreateManga(a(l),m,k:gsub("%%","%%%%"),self.ID,self.Link..m)coroutine.yield(false)end;local n=tonumber(j:match(" of (%d+) Pages"))if n then i.NoPages=n==h else i.NoPages=true end end;function RawDevArt:getPopularManga(h,i)self:getManga(self.Link.."/comic/?lister=5",h,i)end;function RawDevArt:getLatestManga(h,i)self:getManga(self.Link.."/comic/?lister=0",h,i)end;function RawDevArt:searchManga(o,h,i,p)local q=""if p then for r,s in ipairs({p[1],p[2],p[3]})do local t=""if r==1 then t="ctype"elseif r==2 then t="status"elseif r==3 then t="genre"end;if#s.exclude>0 then q=q.."&"..t.."_exc="local u={}for v,w in ipairs(s.exclude)do u[#u+1]=self.Keys[w]end;q=q..table.concat(u,",")end;if#s.include>0 then q=q.."&"..t.."_inc="local u={}for v,w in ipairs(s.include)do u[#u+1]=self.Keys[w]end;q=q..table.concat(u,",")end end end;self:getManga(self.Link.."/search/?title="..o..q,h,i)end;function RawDevArt:getChapters(x,i)local h=1;local w={}while true do local j=e(self.Link..x.Link.."?page="..h)for m,l in j:gmatch('rounded%-0".-<a href="(/comic/%S-)".-text%-truncate">(.-)</span>')do w[#w+1]={Name=a(l),Link=m,Pages={},Manga=x}end;local y=j:match("of (%d+) Pages")if not y or y==tostring(h)then break else h=h+1 end end;table.reverse(w)for r,z in pairs(w)do i[r]=z end end;function RawDevArt:prepareChapter(A,i)local j=e(self.Link..A.Link)for f in j:gmatch('not%-lazy"[^>]-data%-src="([^"]-)"')do i[#i+1]=f end end;function RawDevArt:loadChapterPage(f,i)i.Link=f end