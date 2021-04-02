MangaHub=Parser:new("MangaHub","https://mangahub.io","ENG","MANGAHUBEN",4)MangaHub.Filters={{Name="Genre",Type="radio",Tags={"All Genres","Action","Adventure","Comedy","Adult","Drama","Historical","Martial arts","Romance","Ecchi","Supernatural","Webtoons","Manhwa","Fantasy","Harem","Shounen","Manhua","Mature","Seinen","Sports","School life","Smut","Mystery","Psychological","Shounen ai","Slice of life","Shoujo ai","Cooking","Horror","Tragedy","Doujinshi","Sci fi","Yuri","Yaoi","Shoujo","Gender bender","Josei","Mecha","Medical","One shot","Magic","Shounenai","Shoujoai","4-Koma","Music","Webtoon","Isekai","[no chapters]","Game","Award Winning","Oneshot","Demons","Parody","Vampire","Military","Police","Super Power","Food","Kids","Magical Girls","Space","Shotacon","Wuxia","Superhero","Thriller","Crime","Philosophical"}}}MangaHub.Keys={["All Genres"]="all",["Action"]="action",["Adventure"]="adventure",["Comedy"]="comedy",["Adult"]="adult",["Drama"]="drama",["Historical"]="historical",["Martial arts"]="martial-arts",["Romance"]="romance",["Ecchi"]="ecchi",["Supernatural"]="supernatural",["Webtoons"]="webtoons",["Manhwa"]="manhwa",["Fantasy"]="fantasy",["Harem"]="harem",["Shounen"]="shounen",["Manhua"]="manhua",["Mature"]="mature",["Seinen"]="seinen",["Sports"]="sports",["School life"]="school-life",["Smut"]="smut",["Mystery"]="mystery",["Psychological"]="psychological",["Shounen ai"]="shounen-ai",["Slice of life"]="slice-of-life",["Shoujo ai"]="shoujo-ai",["Cooking"]="cooking",["Horror"]="horror",["Tragedy"]="tragedy",["Doujinshi"]="doujinshi",["Sci fi"]="sci-fi",["Yuri"]="yuri",["Yaoi"]="yaoi",["Shoujo"]="shoujo",["Gender bender"]="gender-bender",["Josei"]="josei",["Mecha"]="mecha",["Medical"]="medical",["One shot"]="one-shot",["Magic"]="magic",["Shounenai"]="shounenai",["Shoujoai"]="shoujoai",["4-Koma"]="4-koma",["Music"]="music",["Webtoon"]="webtoon",["Isekai"]="isekai",["[no chapters]"]="no-chapters",["Game"]="game",["Award Winning"]="award-winning",["Oneshot"]="oneshot",["Demons"]="demons",["Parody"]="parody",["Vampire"]="vampire",["Military"]="military",["Police"]="police",["Super Power"]="super-power",["Food"]="food",["Kids"]="kids",["Magical Girls"]="magical-girls",["Space"]="space",["Shotacon"]="shotacon",["Wuxia"]="wuxia",["Superhero"]="superhero",["Thriller"]="thriller",["Crime"]="crime",["Philosophical"]="philosophical"}local function a(string)if u8c then return string:gsub("&#([^;]-);",function(b)local c=tonumber("0"..b)or tonumber(b)return c and u8c(c)or"&#"..b..";"end):gsub("&([^;]-);",function(b)return HTML_entities and HTML_entities[b]and u8c(HTML_entities[b])or"&"..b..";"end)else return string end end;local function d(e)local f={}Threads.insertTask(f,{Type="StringRequest",Link=e,Table=f,Index="string"})while Threads.check(f)do coroutine.yield(false)end;return f.string or""end;function MangaHub:getManga(e,g)local h=d(e)local i=g;local j=true;for k,l,m in h:gmatch('media%-left">.-<a href="([^"]-/manga/[^"]-)">.-src="([^"]-)" alt="(.-)"')do local n=CreateManga(m:gsub("&#x27;","'"),k,l,self.ID,k)if n then i[#i+1]=n;j=false end;coroutine.yield(false)end;if j then i.NoPages=true end end;function MangaHub:getLatestManga(o,g)self:getManga(string.format("%s/updates/page/%s",self.Link,o),g)end;function MangaHub:getPopularManga(o,g)self:getManga(string.format("%s/popular/page/%s",self.Link,o),g)end;function MangaHub:searchManga(p,o,g,q)self:getManga(string.format("%s/search/page/%s?q=%s&order=POPULAR&genre="..(self.Keys[q and q["Genre"]]or"all"),self.Link,o,p),g)end;function MangaHub:getChapters(n,r)local h=d(n.Link)local s=h:match('<p class="ZyMp7">([^<]-)</p>')or""r.Description=s:gsub("\n+","\n")local i={}for k,m in h:gmatch('<li.-<a href="([^"]-/chapter.-chapter[^"]-)".-([^>]+)</span>')do i[#i+1]={Name=m,Link=k,Pages={},Manga=n}end;for t=#i,1,-1 do r[#r+1]=i[t]end end;MangaHub.query=[[
		{"query":"{chapter(x:m01,slug:\"%s\",number:%s){id,title,mangaID,number,slug,date,pages,noAd,manga{id,title,slug,mainSlug,author,isWebtoon,isYaoi,isPorn,isSoftPorn,unauthFile,isLicensed}}}"}
]]function MangaHub:prepareChapter(u,g)local h=d(u.Link)local v,w=u.Link:match(".-/chapter/(.-)/chapter%-([^/]+)")local i=g;local x=tonumber(h:match(">1/(%d+)</p>")or"0")for t=1,x do i[#i+1]="https://img.mghubcdn.com/file/imghub/"..v.."/"..w.."/"..t..".jpg"end end;function MangaHub:loadChapterPage(e,g)g.Link=e end