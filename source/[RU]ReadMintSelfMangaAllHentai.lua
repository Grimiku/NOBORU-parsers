ReadManga = Parser:new("ReadManga", "https://readmanga.live", "RUS", "READMANGARU", 7)

ReadManga.Filters = {
	{
		Name = "Жанр",
		Type = "checkcross",
		Tags = {
			"Арт",
			"Боевик",
			"Боевые искусства",
			"Вампиры",
			"Гарем",
			"Гендерная интрига",
			"Героическое фэнтези",
			"Детектив",
			"Дзёсэй",
			"Додзинси",
			"Драма",
			"Игра",
			"История",
			"Киберпанк",
			"Кодомо",
			"Комедия",
			"Махо-сёдзё",
			"Меха",
			"Научная фантастика",
			"Повседневность",
			"Постапокалиптика",
			"Приключения",
			"Психология",
			"Романтика",
			"Самурайский боевик",
			"Сверхъестественное",
			"Сёдзё",
			"Сёдзё-ай",
			"Сёнэн",
			"Сёнэн-ай",
			"Спорт",
			"Сэйнэн",
			"Трагедия",
			"Триллер",
			"Ужасы",
			"Фэнтези",
			"Школа",
			"Этти",
			"Юри"
		}
	},
	{
		Name = "Категории",
		Type = "checkcross",
		Tags = {
			"Ёнкома",
			"Комикс",
			"Манхва",
			"Маньхуа",
			"Ранобэ"
		}
	},
	{
		Name = "Возрастные рейтинги",
		Type = "checkcross",
		Tags = {
			"G",
			"PG",
			"PG-13"
		}
	},
	{
		Name = "Прочее",
		Type = "checkcross",
		Tags = {
			"В цвете",
			"Веб",
			"Выпуск приостановлен",
			"Сборник"
		}
	},
	{
		Name = "Фильтры",
		Type = "checkcross",
		Tags = {
			"Высокий рейтинг",
			"Сингл",
			"Для взрослых",
			"Завершенная",
			"Переведено",
			"Длинная",
			"Ожидает загрузки",
			"Продается"
		}
	}
}

ReadManga.Keys = {
	["Арт"] = "el_5685",
	["Боевик"] = "el_2155",
	["Боевые искусства"] = "el_2143",
	["Вампиры"] = "el_2148",
	["Гарем"] = "el_2142",
	["Гендерная интрига"] = "el_2156",
	["Героическое фэнтези"] = "el_2146",
	["Детектив"] = "el_2152",
	["Дзёсэй"] = "el_2158",
	["Додзинси"] = "el_2141",
	["Драма"] = "el_2118",
	["Игра"] = "el_2154",
	["История"] = "el_2119",
	["Киберпанк"] = "el_8032",
	["Кодомо"] = "el_2137",
	["Комедия"] = "el_2136",
	["Махо-сёдзё"] = "el_2147",
	["Меха"] = "el_2126",
	["Научная фантастика"] = "el_2133",
	["Повседневность"] = "el_2135",
	["Постапокалиптика"] = "el_2151",
	["Приключения"] = "el_2130",
	["Психология"] = "el_2144",
	["Романтика"] = "el_2121",
	["Самурайский боевик"] = "el_2124",
	["Сверхъестественное"] = "el_2159",
	["Сёдзё"] = "el_2122",
	["Сёдзё-ай"] = "el_2128",
	["Сёнэн"] = "el_2134",
	["Сёнэн-ай"] = "el_2139",
	["Спорт"] = "el_2129",
	["Сэйнэн"] = "el_2138",
	["Трагедия"] = "el_2153",
	["Триллер"] = "el_2150",
	["Ужасы"] = "el_2125",
	["Фэнтези"] = "el_2131",
	["Школа"] = "el_2127",
	["Этти"] = "el_2149",
	["Юри"] = "el_2123",
	["Ёнкома"] = "el_2161",
	["Комикс"] = "el_3515",
	["Манхва"] = "el_3001",
	["Маньхуа"] = "el_3002",
	["Ранобэ"] = "el_8575",
	["G"] = "el_6180",
	["PG"] = "el_6179",
	["PG-13"] = "el_6181",
	["В цвете"] = "el_7290",
	["Веб"] = "el_2160",
	["Выпуск приостановлен"] = "el_8033",
	["Сборник"] = "el_2157",
	["Высокий рейтинг"] = "s_high_rate",
	["Сингл"] = "s_single",
	["Для взрослых"] = "s_mature",
	["Завершенная"] = "s_completed",
	["Переведено"] = "s_translated",
	["Длинная"] = "s_many_chapters",
	["Ожидает загрузки"] = "s_wait_upload",
	["Продается"] = "s_sale"
}

local function stringify(string)
	return string:gsub(
		"&#([^;]-);",
		function(a)
			local number = tonumber("0" .. a) or tonumber(a)
			return number and u8c(number) or "&#" .. a .. ";"
		end
	):gsub(
		"&(.-);",
		function(a)
			return HTML_entities and HTML_entities[a] and u8c(HTML_entities[a]) or "&" .. a .. ";"
		end
	)
end

local function downloadContent(link)
	local f = {}
	Threads.insertTask(
		f,
		{
			Type = "StringRequest",
			Link = link,
			Table = f,
			Index = "text"
		}
	)
	while Threads.check(f) do
		coroutine.yield(false)
	end
	return f.text or ""
end

function ReadManga:getManga(link, dt)
	local content = downloadContent(link)
	dt.NoPages = true
	for Link, ImageLink, Name in content:gmatch('<a href="(/%S-)" class="non%-hover".-original=\'(%S-)\' title=\'(.-)\' alt') do
		if Link:find("^/[^/]-$") then
			dt[#dt + 1] = CreateManga(stringify(Name), Link, ImageLink, self.ID, self.Link .. Link, self.Link .. Link)
		end
		dt.NoPages = false
		coroutine.yield(false)
	end
end

function ReadManga:getLatestManga(page, dt)
	self:getManga(self.Link .. "/list?sortType=updated&offset=" .. ((page - 1) * 70), dt)
end

function ReadManga:getPopularManga(page, dt)
	self:getManga(self.Link .. "/list?sortType=rate&offset=" .. ((page - 1) * 70), dt)
end

function ReadManga:addQuery(table)
	local query = ""
	if table then
		for _, v in ipairs(table.include) do
			query = query .. "&" .. self.Keys[v] .. "=in"
		end
		for _, v in ipairs(table.exclude) do
			query = query .. "&" .. self.Keys[v] .. "=ex"
		end
	end
	return query
end

function ReadManga:searchManga(data, page, dt, tags)
	local postdata = "q=" .. data
	if tags then
		for _, f in ipairs(self.Filters) do
			postdata = postdata .. self:addQuery(tags[f.Name])
		end
	end
	self:getManga(
		{
			Link = self.Link .. "/search/advanced",
			HttpMethod = POST_METHOD,
			PostData = postdata
		},
		dt
	)
	dt.NoPages = true
end

function ReadManga:getChapters(manga, dt)
	local content = downloadContent(self.Link .. manga.Link)
	local description = (content:match('class="manga%-description.->(.-)<div class="clearfix"') or ""):gsub("<br>","\n"):gsub("<.->",""):gsub("\n+","\n")
	dt.Description = stringify(description):gsub("^%s+",""):gsub("%s+$","")
    local t = {}
    manga.NewImageLink = content:match('<img class="" src="(.-)"')
	for Link, Name in content:gmatch('<td class%=.-<a href%="/.-(/vol%S-)".->%s*(.-)</a>') do
		t[#t + 1] = {
			Name = stringify(Name:gsub("%s+", " "):gsub("<sup>.-</sup>", "")),
			Link = Link,
			Pages = {},
			Manga = manga
		}
	end
	for i = #t, 1, -1 do
		dt[#dt + 1] = t[i]
	end
end

function ReadManga:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. chapter.Manga.Link .. chapter.Link .. "?mtr=1")
	local text = content:match("rm_h.init%( %[%[(.-)%]%]")
	if text then
		local list = load("return {{" .. text:gsub("%],%[", "},{") .. "}}")()
		for i = 1, #list do
			dt[i] = list[i][1] .. list[i][3]
		end
	end
end

function ReadManga:loadChapterPage(link, dt)
	dt.Link = link
end

MintManga = ReadManga:new("MintManga", "https://mintmanga.live", "RUS", "MINTMANGARU", 4)

MintManga.Filters = {
	{
		Name = "Жанр",
		Type = "checkcross",
		Tags = {
			"Арт",
			"Бара",
			"Боевик",
			"Боевые искусства",
			"Вампиры",
			"Гарем",
			"Гендерная интрига",
			"Героическое фэнтези",
			"Детектив",
			"Дзёсэй",
			"Додзинси",
			"Драма",
			"Игра",
			"История",
			"Киберпанк",
			"Комедия",
			"Меха",
			"Научная фантастика",
			"Омегаверс",
			"Повседневность",
			"Постапокалиптика",
			"Приключения",
			"Психология",
			"Романтика",
			"Самурайский боевик",
			"Сверхъестественное",
			"Сёдзё",
			"Сёдзё-ай",
			"Сёнэн",
			"Сёнэн-ай",
			"Спорт",
			"Сэйнэн",
			"Трагедия",
			"Триллер",
			"Ужасы",
			"Фэнтези",
			"Школа",
			"Эротика",
			"Этти",
			"Юри",
			"Яой"
		}
	},
	{
		Name = "Категории",
		Type = "checkcross",
		Tags = {
			"Ёнкома",
			"Комикс",
			"Комикс русский",
			"Манхва",
			"Маньхуа",
			"Ранобэ"
		}
	},
	{
		Name = "Возрастная рекомендация",
		Type = "checkcross",
		Tags = {
			"NC-17",
			"R",
			"R18+"
		}
	},
	{
		Name = "Прочее",
		Type = "checkcross",
		Tags = {
			"В цвете",
			"Веб",
			"Выпуск приостановлен",
			"Не Яой",
			"Сборник"
		}
	},
	{
		Name = "Фильтры",
		Type = "checkcross",
		Tags = {
			"Высокий рейтинг",
			"Сингл",
			"Для взрослых",
			"Завершенная",
			"Переведено",
			"Длинная",
			"Ожидает загрузки"
		}
	}
}

MintManga.Keys = {
	["Арт"] = "el_2220",
	["Бара"] = "el_1353",
	["Боевик"] = "el_1346",
	["Боевые искусства"] = "el_1334",
	["Вампиры"] = "el_1339",
	["Гарем"] = "el_1333",
	["Гендерная интрига"] = "el_1347",
	["Героическое фэнтези"] = "el_1337",
	["Детектив"] = "el_1343",
	["Дзёсэй"] = "el_1349",
	["Додзинси"] = "el_1332",
	["Драма"] = "el_1310",
	["Игра"] = "el_5229",
	["История"] = "el_1311",
	["Киберпанк"] = "el_1351",
	["Комедия"] = "el_1328",
	["Меха"] = "el_1318",
	["Научная фантастика"] = "el_1325",
	["Омегаверс"] = "el_5676",
	["Повседневность"] = "el_1327",
	["Постапокалиптика"] = "el_1342",
	["Приключения"] = "el_1322",
	["Психология"] = "el_1335",
	["Романтика"] = "el_1313",
	["Самурайский боевик"] = "el_1316",
	["Сверхъестественное"] = "el_1350",
	["Сёдзё"] = "el_1314",
	["Сёдзё-ай"] = "el_1320",
	["Сёнэн"] = "el_1326",
	["Сёнэн-ай"] = "el_1330",
	["Спорт"] = "el_1321",
	["Сэйнэн"] = "el_1329",
	["Трагедия"] = "el_1344",
	["Триллер"] = "el_1341",
	["Ужасы"] = "el_1317",
	["Фэнтези"] = "el_1323",
	["Школа"] = "el_1319",
	["Эротика"] = "el_1340",
	["Этти"] = "el_1354",
	["Юри"] = "el_1315",
	["Яой"] = "el_1336",
	["Ёнкома"] = "el_2741",
	["Комикс"] = "el_1903",
	["Комикс русский"] = "el_2173",
	["Манхва"] = "el_1873",
	["Маньхуа"] = "el_1875",
	["Ранобэ"] = "el_5688",
	["NC-17"] = "el_3969",
	["R"] = "el_3968",
	["R18+"] = "el_3990",
	["В цвете"] = "el_4614",
	["Веб"] = "el_1355",
	["Выпуск приостановлен"] = "el_5232",
	["Не Яой"] = "el_1874",
	["Сборник"] = "el_1348",
	["Высокий рейтинг"] = "s_high_rate",
	["Сингл"] = "s_single",
	["Для взрослых"] = "s_mature",
	["Завершенная"] = "s_completed",
	["Переведено"] = "s_translated",
	["Длинная"] = "s_many_chapters",
	["Ожидает загрузки"] = "s_wait_upload"
}

SelfManga = ReadManga:new("SelfManga", "https://selfmanga.ru", "RUS", "SELFMANGARU", 4)

SelfManga.Filters = {
	{
		Name = "Жанр",
		Type = "checkcross",
		Tags = {
			"Боевик",
			"Боевые искусства",
			"Вампиры",
			"Гарем",
			"Гендерная интрига",
			"Героическое фэнтези",
			"Детектив",
			"Дзёсэй",
			"Додзинси",
			"Драма",
			"Ёнкома",
			"История",
			"Комедия",
			"Махо-сёдзё",
			"Мистика",
			"Научная фантастика",
			"Повседневность",
			"Постапокалиптика",
			"Приключения",
			"Психология",
			"Романтика",
			"Сверхъестественное",
			"Сёдзё",
			"Сёдзё-ай",
			"Сёнэн",
			"Сёнэн-ай",
			"Спорт",
			"Сэйнэн",
			"Трагедия",
			"Триллер",
			"Ужасы",
			"Фантастика",
			"Фэнтези",
			"Школа",
			"Этти"
		}
	},
	{
		Name = "Категории",
		Type = "checkcross",
		Tags = {
			"Артбук",
			"Веб",
			"Журнал",
			"Ранобэ",
			"Сборник"
		}
	},
	{
		Name = "Фильтры",
		Type = "checkcross",
		Tags = {
			"Высокий рейтинг",
			"Сингл",
			"Для взрослых",
			"Завершенная",
			"Длинная",
			"Ожидает загрузки",
			"Продается"
		}
	}
}

SelfManga.Keys = {
	["Боевик"] = "el_2155",
	["Боевые искусства"] = "el_2143",
	["Вампиры"] = "el_2148",
	["Гарем"] = "el_2142",
	["Гендерная интрига"] = "el_2156",
	["Героическое фэнтези"] = "el_2146",
	["Детектив"] = "el_2152",
	["Дзёсэй"] = "el_2158",
	["Додзинси"] = "el_2141",
	["Драма"] = "el_2118",
	["Ёнкома"] = "el_2161",
	["История"] = "el_2119",
	["Комедия"] = "el_2136",
	["Махо-сёдзё"] = "el_2147",
	["Мистика"] = "el_2132",
	["Научная фантастика"] = "el_2133",
	["Повседневность"] = "el_2135",
	["Постапокалиптика"] = "el_2151",
	["Приключения"] = "el_2130",
	["Психология"] = "el_2144",
	["Романтика"] = "el_2121",
	["Сверхъестественное"] = "el_2159",
	["Сёдзё"] = "el_2122",
	["Сёдзё-ай"] = "el_2128",
	["Сёнэн"] = "el_2134",
	["Сёнэн-ай"] = "el_2139",
	["Спорт"] = "el_2129",
	["Сэйнэн"] = "el_5838",
	["Трагедия"] = "el_2153",
	["Триллер"] = "el_2150",
	["Ужасы"] = "el_2125",
	["Фантастика"] = "el_2140",
	["Фэнтези"] = "el_2131",
	["Школа"] = "el_2127",
	["Этти"] = "el_4982",
	["Артбук"] = "el_5894",
	["Веб"] = "el_2160",
	["Журнал"] = "el_4983",
	["Ранобэ"] = "el_5215",
	["Сборник"] = "el_2157",
	["Высокий рейтинг"] = "s_high_rate",
	["Сингл"] = "s_single",
	["Для взрослых"] = "s_mature",
	["Завершенная"] = "s_completed",
	["Длинная"] = "s_many_chapters",
	["Ожидает загрузки"] = "s_wait_upload",
	["Продается"] = "s_sale"
}

AllHentai = ReadManga:new("AllHentai", "http://allhen.me", "RUS", "ALLHENTAIRU", 6)

AllHentai.NSFW = true

AllHentai.Filters = {
	{
		Name = "Жанр",
		Type = "checkcross",
		Tags = {
			"3D",
			"Ahegao",
			"Footjob",
			"Gender bender",
			"Handjob",
			"Megane",
			"Mind break",
			"Netori",
			"Paizuri (titsfuck)",
			"Scat",
			"Tomboy",
			"X-ray",
			"Алкоголь",
			"Анал",
			"Андроид",
			"Анилингус",
			"Арт",
			"Бакуню",
			"Бдсм",
			"Без текста",
			"Без трусиков",
			"Без цензуры",
			"Беременность",
			"Бикини",
			"Близнецы",
			"Боди-арт",
			"Больница",
			"Большая грудь",
			"Большая попка",
			"Борьба",
			"Буккакэ",
			"В бассейне",
			"В ванной",
			"В государственном учреждении",
			"В общественном месте",
			"В первый раз",
			"В транспорте",
			"В цвете",
			"Вампиры",
			"Веб",
			"Вибратор",
			"Втроем",
			"Гарем",
			"Гипноз",
			"Глубокий минет",
			"Горячий источник",
			"Групповой секс",
			"Гяру и гангуро",
			"Двойное проникновение",
			"Девочки волшебницы",
			"Девчонки",
			"Демоны",
			"Дилдо",
			"Додзинси",
			"Домохозяйка",
			"Драма",
			"Дыра в стене",
			"Жестокость",
			"Золотой дождь",
			"Зомби",
			"Зрелые женщины",
			"Измена",
			"Изнасилование",
			"Инопланетяне",
			"Инцест",
			"Исполнение желаний",
			"Исторический",
			"Камера",
			"Колготки",
			"Комикс",
			"Косплей",
			"Кремпай",
			"Куннилингус",
			"Купальники",
			"Латекс и кожа",
			"Магия",
			"Маленькая грудь",
			"Мастурбация",
			"Медсестра",
			"Мейдочки",
			"Мерзкий дядька",
			"Милф",
			"Много девушек",
			"Много спермы",
			"Молоко",
			"Монстрдевушки",
			"Монстры",
			"Мочеиспускание",
			"На природе",
			"Наблюдение",
			"Научная фантастика",
			"Не бритая киска",
			"Не бритые подмышки",
			"Нетораре",
			"Обмен телами",
			"Обычный секс",
			"Огромная грудь",
			"Огромный член",
			"Омораси",
			"Оральный секс",
			"Орки",
			"Пайзури",
			"Парень пассив",
			"Парни",
			"Переодевание",
			"Пляж",
			"Повседневность",
			"Подглядывание",
			"Подчинение",
			"Похищение",
			"Превозмогание",
			"Принуждение",
			"Прозрачная одежда",
			"Проституция",
			"Психические отклонения",
			"Публично",
			"Пьяные",
			"Рабыни",
			"Романтика",
			"Сверхестественное",
			"Секс игрушки",
			"Сексуально возбужденная",
			"Сибари",
			"Сильный",
			"Слабая",
			"Спортивная форма",
			"Спящие",
			"Страпон",
			"Суккуб",
			"Темнокожие",
			"Тентакли",
			"Толстушки",
			"Трагедия",
			"Трап",
			"Ужасы",
			"Униформа",
			"Ушастые",
			"Фантазии",
			"Фемдом",
			"Фестиваль",
			"Фетиш",
			"Фистинг",
			"Фурри",
			"Футанари",
			"Футанари имеет парня",
			"Фэнтези",
			"Цельный купальник",
			"Цундере",
			"Чикан",
			"Чулки",
			"Шлюха",
			"Эксгибиционизм",
			"Эльфы",
			"Эччи",
			"Юмор",
			"Юные",
			"Юри",
			"Яндере",
			"Яой"
		}
	},
	{
		Name = "Фильтры",
		Type = "checkcross",
		Tags = {
			"Высокий рейтинг",
			"Сингл",
			"Для взрослых",
			"Завершенная",
			"Переведено",
			"Длинная",
			"Ожидает загрузки",
			"Продается"
		}
	}
}

AllHentai.Keys = {
	["3D"] = "el_626",
	["Ahegao"] = "el_855",
	["Footjob"] = "el_912",
	["Gender bender"] = "el_89",
	["Handjob"] = "el_1254",
	["Megane"] = "el_962",
	["Mind break"] = "el_705",
	["Netori"] = "el_1356",
	["Paizuri (titsfuck)"] = "el_1027",
	["Scat"] = "el_1221",
	["Tomboy"] = "el_881",
	["X-ray"] = "el_1992",
	["Алкоголь"] = "el_1000",
	["Анал"] = "el_828",
	["Андроид"] = "el_1752",
	["Анилингус"] = "el_1037",
	["Арт"] = "el_1190",
	["Бакуню"] = "el_79",
	["Бдсм"] = "el_78",
	["Без текста"] = "el_3157",
	["Без трусиков"] = "el_993",
	["Без цензуры"] = "el_888",
	["Беременность"] = "el_922",
	["Бикини"] = "el_1126",
	["Близнецы"] = "el_1092",
	["Боди-арт"] = "el_1130",
	["Больница"] = "el_289",
	["Большая грудь"] = "el_837",
	["Большая попка"] = "el_3156",
	["Борьба"] = "el_72",
	["Буккакэ"] = "el_82",
	["В бассейне"] = "el_3599",
	["В ванной"] = "el_878",
	["В государственном учреждении"] = "el_86",
	["В общественном месте"] = "el_866",
	["В первый раз"] = "el_811",
	["В транспорте"] = "el_3246",
	["В цвете"] = "el_290",
	["Вампиры"] = "el_1250",
	["Веб"] = "el_1104",
	["Вибратор"] = "el_867",
	["Втроем"] = "el_3711",
	["Гарем"] = "el_87",
	["Гипноз"] = "el_1423",
	["Глубокий минет"] = "el_3555",
	["Горячий источник"] = "el_1209",
	["Групповой секс"] = "el_88",
	["Гяру и гангуро"] = "el_844",
	["Двойное проникновение"] = "el_911",
	["Девочки волшебницы"] = "el_292",
	["Девчонки"] = "el_875",
	["Демоны"] = "el_1139",
	["Дилдо"] = "el_868",
	["Додзинси"] = "el_92",
	["Домохозяйка"] = "el_300",
	["Драма"] = "el_95",
	["Дыра в стене"] = "el_1420",
	["Жестокость"] = "el_883",
	["Золотой дождь"] = "el_1007",
	["Зомби"] = "el_1099",
	["Зрелые женщины"] = "el_1441",
	["Измена"] = "el_291",
	["Изнасилование"] = "el_124",
	["Инопланетяне"] = "el_990",
	["Инцест"] = "el_85",
	["Исполнение желаний"] = "el_909",
	["Исторический"] = "el_93",
	["Камера"] = "el_869",
	["Колготки"] = "el_849",
	["Комикс"] = "el_1003",
	["Косплей"] = "el_1024",
	["Кремпай"] = "el_3709",
	["Куннилингус"] = "el_5383",
	["Купальники"] = "el_845",
	["Латекс и кожа"] = "el_1047",
	["Магия"] = "el_1128",
	["Маленькая грудь"] = "el_870",
	["Мастурбация"] = "el_882",
	["Медсестра"] = "el_5688",
	["Мейдочки"] = "el_994",
	["Мерзкий дядька"] = "el_2145",
	["Милф"] = "el_5679",
	["Много девушек"] = "el_860",
	["Много спермы"] = "el_1020",
	["Молоко"] = "el_1029",
	["Монстрдевушки"] = "el_1022",
	["Монстры"] = "el_917",
	["Мочеиспускание"] = "el_1193",
	["На природе"] = "el_842",
	["Наблюдение"] = "el_928",
	["Научная фантастика"] = "el_76",
	["Не бритая киска"] = "el_4237",
	["Не бритые подмышки"] = "el_4238",
	["Нетораре"] = "el_303",
	["Обмен телами"] = "el_5120",
	["Обычный секс"] = "el_1012",
	["Огромная грудь"] = "el_1207",
	["Огромный член"] = "el_884",
	["Омораси"] = "el_81",
	["Оральный секс"] = "el_853",
	["Орки"] = "el_3247",
	["Пайзури"] = "el_288",
	["Парень пассив"] = "el_861",
	["Парни"] = "el_874",
	["Переодевание"] = "el_1026",
	["Пляж"] = "el_846",
	["Повседневность"] = "el_90",
	["Подглядывание"] = "el_978",
	["Подчинение"] = "el_885",
	["Похищение"] = "el_1183",
	["Превозмогание"] = "el_71",
	["Принуждение"] = "el_929",
	["Прозрачная одежда"] = "el_924",
	["Проституция"] = "el_3563",
	["Психические отклонения"] = "el_886",
	["Публично"] = "el_1045",
	["Пьяные"] = "el_2055",
	["Рабыни"] = "el_1433",
	["Романтика"] = "el_74",
	["Сверхестественное"] = "el_634",
	["Секс игрушки"] = "el_871",
	["Сексуально возбужденная"] = "el_925",
	["Сибари"] = "el_80",
	["Сильный"] = "el_913",
	["Слабая"] = "el_455",
	["Спортивная форма"] = "el_891",
	["Спящие"] = "el_972",
	["Страпон"] = "el_872",
	["Суккуб"] = "el_677",
	["Темнокожие"] = "el_611",
	["Тентакли"] = "el_69",
	["Толстушки"] = "el_1036",
	["Трагедия"] = "el_1321",
	["Трап"] = "el_859",
	["Ужасы"] = "el_75",
	["Униформа"] = "el_1008",
	["Ушастые"] = "el_991",
	["Фантазии"] = "el_1124",
	["Фемдом"] = "el_873",
	["Фестиваль"] = "el_1269",
	["Фетиш"] = "el_1137",
	["Фистинг"] = "el_821",
	["Фурри"] = "el_91",
	["Футанари"] = "el_77",
	["Футанари имеет парня"] = "el_1426",
	["Фэнтези"] = "el_70",
	["Цельный купальник"] = "el_1257",
	["Цундере"] = "el_850",
	["Чикан"] = "el_1059",
	["Чулки"] = "el_889",
	["Шлюха"] = "el_763",
	["Эксгибиционизм"] = "el_813",
	["Эльфы"] = "el_286",
	["Эччи"] = "el_798",
	["Юмор"] = "el_73",
	["Юные"] = "el_1162",
	["Юри"] = "el_84",
	["Яндере"] = "el_823",
	["Яой"] = "el_83",
	["Высокий рейтинг"] = "s_high_rate",
	["Сингл"] = "s_single",
	["Для взрослых"] = "s_mature",
	["Завершенная"] = "s_completed",
	["Переведено"] = "s_translated",
	["Длинная"] = "s_many_chapters",
	["Ожидает загрузки"] = "s_wait_upload",
	["Продается"] = "s_sale"
}

function AllHentai:prepareChapter(chapter, dt)
	local content = downloadContent(self.Link .. chapter.Manga.Link .. chapter.Link .. "?mtr=1")
	local text = content:match("rm_h.init%( %[%[(.-)%]%]")
	if text then
		local list = load("return {{" .. text:gsub("%],%[", "},{") .. "}}")()
		for i = 1, #list do
			dt[i] = (list[i][1] .. list[i][3]):gsub("^//","http://")
		end
	end
end