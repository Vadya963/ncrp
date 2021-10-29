include("controllers/help/map.nut");

function msgt(playerid, text) {
    msg(playerid, "");
    msg(playerid, ".:: %s ::.", text, CL_HELP);
}

function msgo(playerid, text) {
    msg(playerid, text, CL_JORDYBLUE);
}
function msge(playerid, text) {
    msg(playerid, text, CL_SILVERSAND);
}

function msgh(playerid, title, list){
    delayedFunction(0, function() {
        msgt(playerid, title);;
    });

    foreach (idx, line in list) {
        local text = localize(line, [], getPlayerLocale(playerid))
        if ((idx % 2) == 0) {
            delayedFunction(idx, function() {
                msgo(playerid, text);
            });
        } else {
            delayedFunction(idx, function() {
                msge(playerid, text);
            });
        }
    }
}

cmd(["help", "h", "halp", "info"], function(playerid) {
    msgh(playerid, "Помощь", [
        "/general - основная информация",
        "/chat - чат",
        "/places - места",
        "/char - персонаж",
        "/money - деньги",
        "/transport - транспорт",
        "/job - работа",
        "/biz - бизнес",
        "/fractions - фракции",
        "/world - погода, время, сезон",
        "/donate - донат"
    ]);
});


cmd("general", function(playerid) {
    msgh(playerid, "Основная информация", [
        "Открыть карту: M англ.",
        "Открыть инвентарь: Tab",
        "Открыть чат: Enter",
        "Показать/скрыть курсор: F4",
        "Показать/скрыть элементы интерфейса: P англ. и F10",
        "Часто вылетает игра? Пиши /crash",
        "Видишь нарушителя? Пиши /report id причина",
        "Потерял личный автомобиль? Провалился под текстуры? Пиши админам.",
        "Нашёл баг? Пиши /bug   Есть идея? Пиши /idea",
    ]);
});

cmd("crash", function(playerid) {
    msgh(playerid, "Часто вылетает игра", [
        "Переведи игру в режим окна:",
        " В настройках лончера сними галочку Полноэкранный режим",
        "Больше решений смотри на нашем сайте:",
        "mafia2online.ru"
    ]);
});

cmd("chat", function(playerid) {
    msgh(playerid, "Чаты", [
        "Команды чата: /chat cmd",
        "Команды речи персонажа: /chat char",
        "Слоты чата:",
        "F1 - общий нонРП-чат",
        "F2 - слова персонажа",
        "F3 - локальный нонРП-чат",
        "При открытой строке ввода, клавиши стрелок вверх и вниз позволяют выбирать из ранее введённых команд."
    ]);
});

cmd("chat", "cmd", function(playerid) {
    msgh(playerid, "Команды чата", [
        "/clearchat - очистить окно чата",
        "/togooc - включить/выключить отображение ooc-чата",
        "/togpm - включить/выключить получение личных сообщений"
        "/tips - включить/выключить получение подсказок"
    ]);
});

cmd("chat", "char", function(playerid) {
    msgh(playerid, "Команды речи персонажа", [
        "/ic текст - сказать от имени персонажа",
        "/s текст - крикнуть от имени персонажа",
        "/w текст - прошептать ближайшему игроку",
        "/b текст - отправить сообщение в локальный нон-РП чат",
        "/pm id текст - отправить личное сообщение другому игроку",
        "/re текст - ответить на последнее личное сообщение",
        "/me текст - сообщить о действии персонажа",
        "/do текст - сообщить о происходящем вокруг в данный момент",
        "/todo речь * действие - совмещение /ic и /me",
        "/try текст - попытка действия со случайным результатом"
    ]);
});

cmd("money", function(playerid) {
    msgh(playerid, "Деньги", [
        "Наличные деньги отображаются внизу справа под мини-картой.",
        "Заработать деньги можно:",
        "- на работах: /job",
        "- занимаясь бизнесом: /biz",
        "- другими способами, какие сами придумаете.",
        "Передать деньги другому человеку: /pay",
        "Также можно хранить деньги на счёте в банке: /bank"
    ]);
});

cmd("places", function(playerid) {
    msgh(playerid, "Места", [
        "Здание мэрии - красный пятиугольник с белой звездой",
        "Полицейский участок - оранжевый пятиугольник",
        "Дилер - розовый пятиугольник",
        "Банк - значок доллара",
        "Автосалон - бирюзовый пятугольник с автомобилем",
        "Штрафстоянка - белый круг с красным крестиком",
        "Ищешь другое место? Используй /map"
    ]);
});

cmd("transport", function(playerid) {
    msgh(playerid, "Передвижение по городу", [
        "1. На арендованном автомобиле: /rentcar",
        "2. На метро: /subway",
        "3. На автобусе: /bus",
        "4. На личном автомобиле: /car",
        "Такси на данный момент нет."
    ]);
});

cmd("rentcar", function(playerid) {
    msgh(playerid, "Аренда автомобиля", [
        "Автомобили для аренды доступны в разных частях города.",
        "Их отличительная черта - жёлтый цвет.",
        "Они находятся около мест работ и важных мест города (вокзал, порт, госпиталь).",
        "Стоимость аренды автомобиля можно узнать, если сесть в него.",
        "Оплата производится за каждые 10 минут игрового времени.",
        "Отказаться от аренды: /unrent"
    ]);
});

cmd("subway", function(playerid) {
    msgh(playerid, "Метро", [
        "В Empire-Bay есть кольцевая линия метро из 7 станций, проходящая через весь город.",
        "Чтобы воспользоваться метро, следует найти ближайшую станцию: /find subway",
        "Стоимость проезда $0.15",
    ]);
});

cmd("bus", function(playerid) {
    msgh(playerid, "Автобус", [
        "В Empire-Bay есть несколько автобусных маршрутов, охватывающих весь город.",
        "Отличительной особенностью является то, что автобусы водят реальные игроки по заранее заданному маршруту.",
        "Чтобы поехать на автобусе, следует найти остановку.",
        "Когда автобус подъедет и остановится, нажмите E англ.",
        "Если вы доехали до нужного места, нажмите E англ., чтобы выйти.",
        "Стоимость проезда $0.40"
    ]);
});

cmd("car", function(playerid) {
    msgh(playerid, "Личный автомобиль", [
        "В таком городе, как Эмпайр-Бэй, без автомобиля сложно.",
        "На ваш выбор представлено несколько десятков автомобилей разного класса и стоимости.",
        "Не забывайте заправлять топливо на автозаправках.",
        "Перекрасить личный автомобиль можно в мастерской Чарли.",
        "Как обзавестись личным автомобилем: /car buy",
        "Клавишы управления автомобилем: /car controls"
    ]);
});

cmd("car", "buy", function(playerid) {
    msgh(playerid, "Купить личный автомобиль", [
        "Вы можете приобрести автомобиль:",
        "- в автосалоне Diamond Motors в Маленькой Италии;",
        "- у автодилера на северо-западе Кингстона;",
        "- напрямую у владельца продаваемого автомобиля путём обмена ключей на деньги."
    ]);
});

cmd("car", "controls", function(playerid) {
    msgh(playerid, "Клавиши управления автомобилем", [
        "W, S, A, D - клавиши движения",
        "Q - завести/заглушить двигатель",
        "R - включить/выключить фары",
        "E - подать звуковой сигнал (гудок)",
        "X - левый поворотник",
        "C - правый поворотник",
        "H - аварийная сигнализация (аварийка)",
        "L - ограничитель скорости",
        "< и > - смена радиостанции",
        "V, находясь у автомобиля - меню управления дверьми и багажником",
        "Z, находясь в автомобиле - инвентарь салона (бардачок)",
        "E, находясь у багажника - открыть/закрыть багажник",
        "Z, находясь у багажника - инвентарь багажника"
    ]);
});

cmd("char", function(playerid) {
    msgh(playerid, "Персонаж", [
        "Информация о персонаже и статистика: /stats",
        "Здоровье: /health",
        "Питание: /food",
        "Одежда: /clothes",
        "Система знакомств: /dating",
    ]);
});

cmd("health", function(playerid) {
    msgh(playerid, "Здоровье (хп)", [
        "Самый важный показатель персонажа.",
        "Здоровье уменьшается:",
        "- при нехватке питания;",
        "- при травмах и огнестрельных ранениях;",
        "- при падениях с высоты;",
        "- при автомобильных авариях и ДТП;",
        "Если здоровье заканчивается, персонаж погибает.",
        "Здоровье постепенно увеличивается автоматически при заполненности шкал сытости и достатка жидкости больше 3/4 части."
    ]);
});

cmd("food", function(playerid) {
    msgh(playerid, "Питание и еда", [
        "Чтобы не умереть, персонажу нужно питаться.",
        "Шкалы в правом нижнем углу - сытость и достаток жидкости.",
        "Купить еду и напитки можно в закусочных, барах и ресторанах,",
        "либо у жителей города в обмен на деньги или другие товары.",
        "После покупки, товар попадает в инвентарь.",
        "Чтобы скушать еду или выпить напиток нужно выбрать предмет в инвентаре и нажать кнопку Использовать.",
        "Один предмет можно применить только один раз.",
        "Каждый продукт питания оказывает разное влияние."
    ]);
});

cmd(["clothes", "cloths"], function(playerid) {
    msgh(playerid, "Одежда", [
        "Приобрести одежду вы можете:",
        "- в магазинах сети Dipton Apparel;",
        "- в ателье Венджела в Мидтауне;",
        "- у жителей города путём обмена одежды на деньги.",
        "Асссортимент зависит:",
        "- от конкретного магазина;",
        "- от текущего времени года (зима/лето).",
    ]);
});

cmd("dating", function(playerid) {
    msgh(playerid, "Система знакомств", [
        "/dating rules - правила",
        "Обязательно для прочтения перед использованием!",
        "/hi id имя - представиться вымышленным именем",
        "handshake.shake.example",
        "/hi id me - представиться настоящим именем",
        "handshake.shake.real-name.example",
        "/remember id имя - запомнить имя",
        "handshake.remember.example",
        "/forget id - забыть имя",
        "handshake.forget.example"
    ]);
});

cmd("world", function(playerid) {
    msgh(playerid, "Погода, время, сезон", [
        "Игровое время идёт в 1,5 раза быстрее реального.",
        "В каждом месяце ровно 30 дней.",
        "Зима и лето чередуются согласно игровому календарю.",
        "Осадки пока не влияют на состояние персонажа.",
    ]);
});

cmd("job", function(playerid) {
    msgh(playerid, "Работа", [
        "В Эмпайр-Бэй найти работу не сложно.",
        "Места работ отмечены на карте серыми звёздами.",
        "Текущая работа указана справа внизу под деньгами.",
        "Если на карте только одна серая звезда - вы там работаете.",
        "Грузчик в порту: /job docker",
        "Грузчик на вокзале: /job porter",
        "Водитель автобуса: /job bus",
        "Водитель снегоуборочной машины (зимой): /job snow",
        "Развозчик рыбы: /job fish",
        // "Развозчик грузов: /job truck",
        "Развозчик топлива: /job fuel",
        "Развозчик молока: /job milk"
        "Cотрудник полиции: /job police"
    ]);
});

cmd("job", "docker", function(playerid) {
    msgh(playerid, "Грузчик в порту", [
        "Одна из низкооплачивамых работ.",
        "Позволяет заработать первые деньги.",
        "Работа заключается в переносе ящиков.",
        "Не требует навыков."
    ]);
});

cmd("job", "porter", function(playerid) {
    msgh(playerid, "Грузчик на вокзале", [
        "Одна из низкооплачивамых работ.",
        "Позволяет заработать первые деньги.",
        "Работа заключается в переносе ящиков.",
        "Не требует навыков."
    ]);
});

cmd("job", "bus", function(playerid) {
    msgh(playerid, "Водитель автобуса", [
        "Государственная хорошо оплачиваемая работа.",
        "Место трудоустройства: автобусное депо в Аптаун."
        "Работа заключается в перемещении на автобусе по заранее известному маршруту.",
        "Требуется останавливаться на указанных остановках, аккуратно подъезжая к ним.",
        "Если вы правильно подъехали, под названием остановки появится надпись «Нажми Е»."
    ]);
});

cmd("job", "fish", function(playerid) {
    msgh(playerid, "Развозчик рыбы", [
        "Средне оплачиваемая работа на китайскую диаспору.",
        "Место трудоустройства: склад Дары моря (Seagift) в Чайнатаун.",
        "Работа заключается в погрузке пустых ящиков, перевозке их в Порт, возвращению обратно и разгрузке на склад.",
        "Можно работать коллективно."
    ]);
});

// cmd("job", "truck", function(playerid) {
//     msgh(playerid, "Развозчик грузов", [
//         "Средне оплачиваемая работа.",
//         "Место трудоустройства: площадка около моста в Диптоне."
//     ]);
// });

cmd("job", "fuel", function(playerid) {
    msgh(playerid, "Развозчик топлива", [
        "Размер заработка зависит от вас.",
        "Вы самостоятельно берёте заказы на поставку топлива.",
        "Арендуете бензовоз, закупаете топливо в топливном хранилище и развозите.",
        "Место аренды бензовоза: штаб-квартира Trago Oil в Ойстер-Бэй.",
        "Место расположения топливного хранилища: Порт",
        "Посмотреть список заказов на топливо: /fuel orders",
        "Проверить заполненность цистерны бензовоза: клавиша Z",
    ]);
});

cmd("job", "milk", function(playerid) {
    msgh(playerid, "Развозчик молока", [
        "Хорошо оплачиваемая работа.",
        "Место трудоустройства: молочный завод в Чайнатаун.",
        "Работа заключается в доставке молока по разным заведениям города.",
        "Проверить заполненность молоковоза: /milk check",
        "Посмотреть маршрутный лист: /milk list"
    ]);
});

cmd("job", "snow", function(playerid) {
    msgh(playerid, "Водитель снегоуборочной машины", [
        "Государственная средне оплачиваемая работа.",
        "Место трудоустройства: Аптаун (напротив ПД)."
        "Работа заключается в очистке снега по заранее проложенным маршрутам.",
        "Доступна только в зимнее время года."
    ]);
});

cmd("job", "police", function(playerid) {
    msgh(playerid, "Сотрудник полиции", [
        "Государственная хорошо оплачиваемая работа.",
        "Трудоустройство: по заявлению шефу полиции.",
        "Требует навыков:",
        "- отличное знание города, его районов;",
        "- хорошее знание РП;",
        "- высокие навыки вождения;",
        "- грамотная письменная речь;",
        "- адекватность;",
        "- наличие действительного паспорта;",
        "- возраст персонажа не более 60 лет;",
        "- суммарное время в игре не менее 25 часов.",
    ]);
});


cmd("biz", function(playerid) {
    msgh(playerid, "Бизнес", [
        "Вы можете заниматься бизнесом:",
        "- сдавать свой автомобиль в аренду: /lease",
        "- заниматься поставками топлива: /job fuel",
        "- приобрести автозаправочный бизнес"
    ]);
})

cmd("fractions", function(playerid) {
    msgh(playerid, "Фракции", [
        "На сервере нет фракций в их привычном понимании.",
        "Но государственные и криминальные структуры есть.",
        "Лидерки не выдаются администрацией.",
        "Фракционного транспорта и недвижимости нет.",
        "Вы самостоятельно развиваетесь и расширяетесь.",
        "Подробнее про разные структуры:",
        "/mafia - информация про мафии",
        "/gang - информация про банды",
        "/govt - информация про государственные структуры",
    ]);
})

cmd("mafia", function(playerid) {
    msgh(playerid, "Мафия", [
        "Мафии - тайные организации.",
        "ФБР и полиция того времени до последнего отрицали и не признавали существование мафий.",
        "Занять пост босса мафии можно, если вас назначит текущий босс вместо себя.",
        "Прийти и объявить себя боссом новой семьи можно, но к вам никто не примкнёт, т.к. вы сами никто и звать вас никак. Это объективно.",
    ]);
})

cmd("gang", function(playerid) {
    msgh(playerid, "Банда", [
        "В городе есть банды. Какие именно вы можете узнать самостоятельно в РП-общении с другими игроками.",
        "Для организации своей банды просто собираете вокруг себя людей.",
        "Вместе зарабатываете на автомобили, недвижимость, оружие, ведёте деятельность.",
        "То есть самостоятельно развиваете свою банду."
    ]);
})

cmd("govt", function(playerid) {
    msgh(playerid, "Государственные структуры", [
        "Есть две официальные действующие гос. структуры:",
        "",
        "Правительство",
        "Законодательный орган управления. Издаёт постановления, регулирует всё, что происходит в городе.",
        "Во главе - мэр города, переизбираемый 1 раз в игровой год.",
        "",
        "Полиция",
        "Структура, отвечающая за порядок и безопасность в городе.",
        "Во главе - шеф департамента, назначаемый мэром города.",
    ]);
})

cmd("bank", function(playerid) {
    msgh(playerid, "Grand Imperial Bank", [
        "bank.letsgo1",
        "bank.letsgo2"
        "Банк не выплачивает проценты по вкладам."
    ]);
});

cmd(["idea", "bug"], function(playerid) {
    msgh(playerid, "Обратная связь", [
        "Идеи, предложения, сообщения о багах принимаются в Discord:",
        "https://bit.ly/m2ncrp"
    ]);
});

cmd("start", function(playerid, num = "1") {

    if(num == "1") {
        return msgh(playerid, "Привет, друг!", [
            "Мы ради видеть тебя на RolePlay-сервере NCRP.",
            "",
            "Команда этого сервера - небольшая группа людей, которая работает на энтузиазме в свободное от работы, учёбы, отдыха, сна и личных хобби время.",
            "Сервер - некоммерческий проект и мы не зарабатываем на нём. У нас есть донат, но играть можно и без него.",
            "Этот мультиплеер - далеко не самая стабильная штука. Есть проблемы, есть вылеты. Нам тоже это неприятно, но от нас это сейчас никак не зависит.",
            "А также сервер ещё находится в разработке. Возможности расширяются, недостатки устраняются.",
            "",
            "Далее: /start 2"
        ]);
    }

    if(num == "2") {
        return msgh(playerid, "Приветствие", [
            "Поэтому мы просим отнестись с пониманием к некоторым проблемам и возможной нехватке функционала.",
            "Мы работаем над этим и стараемся сделать по максимуму уютный, атмосферный и ламповый мир мафии.",
            "И также приглашаем тебя в Discord: bit.ly/m2ncrp"
            "Там ты можешь общаться с другими игроками, делиться идеями и узнавать информацию о новом функционале."
            "А так же подписывайся на нас в VK: vk.com/m2ncrp",
            "",
            "Тебе наверняка интересно чем можно здесь заняться, да?",
            "Тогда смело переходи на следующую страницу: /start 3",
            "",
            "Назад: /start 1 | Далее: /start 3"
        ]);
    }

    if(num == "3") {
        return msgh(playerid, "А что делать?", [
            "Это RolePlay-сервер, и здесь основная суть - погрузиться в эпоху Америки 40х-50х годов.",
            "И, конечно же, взаимодействовать с другими игроками.",
            "Твой путь покорения Эмпайр-Бэй начинается с низов.",
            "Кем быть, чем заниматься, как развиваться, где зарабатывать и как тратить деньги решаешь ты сам.",
            "Игровой мир ничего тебе не навязывает, кроме соблюдения простых общих правил. Они нужны для того, чтобы всем было комфортно здесь играть.",
            "Переходи на следующую страницу: /start 4",
            "",
            "Назад: /start 2 | Далее: /start 4"
        ]);
    }

    if(num == "4") {
        return msgh(playerid, "Коротко о правилах", [
            "Мат, оскорбления, флуд, капс - наказываются мутом.",
            "Использование модов, читов, трейнеров - запрещено. Античит-система отлавливает нарушителей довольно неплохо."
            "Неадекватное поведение, попытки задавить других игроков или всячески мешать без достоверной РП-причины - является грубым нарушением и наказывается от предупреждения до бана.",
            "Подробные правила размещены на нашем сайте:",
            "mafia2online.ru/rules",
            "Продолжая играть, ты автоматически соглашаешься с ними."
            "",
            "С правилами понятно. Но с чего же начать? /start 5",
            "",
            "Назад: /start 3 | Далее: /start 5"
        ]);
    }

    if(num == "5") {
        return msgh(playerid, "Куда отправиться прямо сейчас?", [
            "Как мы говорили ранее, игра ничего не навязывает. Поэтому мы лишь дадим несколько полезных советов.",
            "Твоему персонажу нужно питаться, обрати на это внимание. Шкалы голода и жажды находятся в правом нижнем углу."
            "Без денег в городе крайне сложно, поищи способы заработать."
            "Перемещаться пешком - уныло и долго. Пользуйся транспортом."
            "Не забывай соблюдать правила дорожного движения, иначе тебя могут сбить, или у тебя появятся ненужные на раннем этапе игры проблемы с законом."
            "Узнать другую полезную информацию ты можешь тут: /help",
            "",
            "Назад: /start 4"
        ]);
    }
});
