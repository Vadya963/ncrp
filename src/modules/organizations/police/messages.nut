local phrases = {
    "1": { "text": "Нахожусь в патрулировании", "marker": true },
    "2": { "text": "Ухожу на перерыв" },
    "3": { "text": "Запрашиваю напарника. Прибыть без сирен и мигалок", "marker": true},
    "4": { "text": "Нужна помощь. Прибыть с мигалками", "marker": true },
    "5": { "text": "Срочно требуется поддержка. Прибыть с сиреной и мигалками", "marker": true },
    "6": { "text": "Доложите обстановку" },
    "7": { "text": "Запрашиваю информацию по активным патрулям" },
    "8": { "text": "Принял, выезжаю" },
    "9": { "text": "Не могу выполнить" },
}

local timers = {};

function policeCarRadioBinder(playerid) {
    if (!isCopInPoliceCarOnDuty(playerid) || (playerid in timers && timers[playerid].IsActive() )) return;

    local vehicleid = getPlayerVehicle(playerid);

    if(vehicleid == false) {
        return;
    }

    if(getVehicleRadioChannel(vehicleid) == false) {
        return msg(playerid, "vehicle.options.radio.not-installed");
    }

    setPlayerBinderState(playerid, "v_policecar");

    msg(playerid, "===========================================", CL_HELP_LINE);
    msg(playerid, "РАЦИЯ", CL_HELP_TITLE);

    for (local i = 1; i <= phrases.len(); i++) {

        local text = format("%d. %s", i, phrases[i.tostring()].text);

        if ((i % 2) == 0) {
            msg(playerid, text, CL_HELP);
        } else {
            msg(playerid, text);
        }
    }

    trigger(playerid, "hudCreateTimer", 3.0, true, true);
    timers[playerid] <- delayedFunction(3000, function () {
        clearPlayerBinderState(playerid);
        msg(playerid, "Действие отменено");
    });

}

/**
 * Create private bindings for playerid
 */
function policeCarRadioBinderCreator(playerid) {
    for (local i = 1; i <= phrases.len(); i++) {
        local keyButton = i.tostring();
        privateKey(playerid, keyButton, "policeCarRadioBinder"+keyButton, function(playerid) {
            if(getPlayerBinderState(playerid) != "v_policecar") return;
            sendRadioMsg(playerid, format("%s: %s", getPlayerName(playerid), phrases[keyButton].text));
            if("marker" in phrases[keyButton]) {
                createCrimePoint(playerid)
            }
            clearPlayerBinderState(playerid);
            trigger(playerid, "hudDestroyTimer");
            if( timers[playerid].IsActive() ) {
                timers[playerid].Kill()
            }
        });
    }
}

/**
 * Remove private bindings for playerid
 */
function policeCarRadioBinderRemover(playerid) {
    for (local i = 1; i <= phrases.len(); i++) {
        local keyButton = i.tostring();
        removePrivateKey(playerid, keyButton, "policeCarRadioBinder"+keyButton);
    }
}

function createCrimePoint(playerid) {
    local pos = getPlayerPositionObj(playerid);
    foreach (player in players) {
        local id = player.playerid;
        if (isCopInPoliceCarOnDuty(id)) {
            local crime_hash = createPrivateBlip(id, pos.x, pos.y, ICON_YELLOW, 4000.0);

            delayedFunction(60000, function() {
                removeBlip( crime_hash );
            });
        }
    }
}


/*
translation("ru", {
    "organizations.police.tencode.10-1"    : "10-1 ((Вышел в патруль))"
    "organizations.police.tencode.10-2"    : "10-2 ((Ушел на перерыв))"
    "organizations.police.tencode.10-3"    : "10-3 ((Запрашиваю напарника)) Прием."
    "organizations.police.tencode.10-4"    : "10-4 ((Запрашиваю информацию по активным патрулям)) Прием."
    "organizations.police.tencode.10-5"    : "10-5 ((Информация о человеке)) %s"
    "organizations.police.tencode.10-6"    : "10-6 ((Информация об автомобиле)) %s"
    "organizations.police.tencode.10-7"    : "10-7 ((Запрашиваю ордер)) на %s."
    "organizations.police.tencode.10-8"    : "10-8 ((Принято)) %s"
    "organizations.police.tencode.10-9"    : "10-9 ((Доложите обстановку)) Прием."
    "organizations.police.tencode.10-10"   : "10-10 ((Вызов принял))"
    "organizations.police.tencode.10-11"   : "10-11 ((Не могу выполнить))"
    "organizations.police.tencode.10-12"   : "10-12 ((Вижу нарушителя))" // show blip
    "organizations.police.tencode.10-13"   : "10-13 ((Веду преследование за автомобилем)) %s"
    "organizations.police.tencode.10-14"   : "10-14 ((Веду пешую погоню)) Конец связи."
    "organizations.police.tencode.10-15"   : "10-15 ((Требуется поддержка))" // show blip
    "organizations.police.tencode.10-16"   : "10-16 ((Офицер ранен))"
    "organizations.police.tencode.10-17"   : "10-17 ((Офицер убит))"

    "organizations.police.tencode.code0"  : "код 0 ((Требуется срочная помощь. Всем экипажам без исключения ответить на code 0 как можно быстрее))"
    "organizations.police.tencode.code1"  : "код 1 ((Опасная ситуация. Всем экипажам, находящимся на дежурстве, прибыть))"
    "organizations.police.tencode.code2"  : "код 2 ((Мало приоритетный вызов. Прибыть без сирен и мигалок))"
    "organizations.police.tencode.code3"  : "код 3 ((Высоко приоритетный вызов. Прибыть с сиреной и мигалками))"
    "organizations.police.tencode.code4"  : "код 4 ((По офицерам открыт огонь!))"
});


translation("en", {
    "organizations.police.tencode.10-1"    : "10-1 ((On duty, responding to calls))"
    "organizations.police.tencode.10-2"    : "10-2 ((Meal break))"
    "organizations.police.tencode.10-3"    : "10-3 ((Request cover unit)) Over."
    "organizations.police.tencode.10-4"    : "10-4 ((Request information about patrols on duty)) Over."
    "organizations.police.tencode.10-5"    : "10-5 ((Information about citizen)) %s"
    "organizations.police.tencode.10-6"    : "10-6 ((Information about vehice)) %s"
    "organizations.police.tencode.10-7"    : "10-7 ((Request for order)) on %s."
    "organizations.police.tencode.10-8"    : "10-8 ((Roger)) %s"
    "organizations.police.tencode.10-9"    : "10-9 ((Report the situation)) Over."
    "organizations.police.tencode.10-10"   : "10-10 ((Take call))"
    "organizations.police.tencode.10-11"   : "10-11 ((Can't perform order))"
    "organizations.police.tencode.10-12"   : "10-12 ((See the suspect))" // show blip
    "organizations.police.tencode.10-13"   : "10-13 ((Chaise in progress)) %s"
    "organizations.police.tencode.10-14"   : "10-14 ((Pursuit in progress)) Over."
    "organizations.police.tencode.10-15"   : "10-15 ((Need backup))" // show blip
    "organizations.police.tencode.10-16"   : "10-16 ((Officer injured))"
    "organizations.police.tencode.10-17"   : "10-17 ((Officer killed))"

    "organizations.police.tencode.code0"  : "code 0 ((Need backup. All unit, take order on code 0 as fast as you can))"
    "organizations.police.tencode.code1"  : "code 1 ((Urgent Response Type. All units, lights and sirens at Intersections))"
    "organizations.police.tencode.code2"  : "code 2 ((Routine Response Type. No lights or sirens))"
    "organizations.police.tencode.code3"  : "code 3 ((High Response Type. All units, lights and sirens))"
    "organizations.police.tencode.code4"  : "code 4 ((Officer under the fire!))"
});


// Fix: send message in player locale, not only sender locale
function sendLocalizedPoliceRadioMsgToAll(sender, phrase_key, ...) {
    local players = playerList.getPlayers();
    local message = concat(vargv);

    foreach(playerid, player in players) {
        if ( isPlayerInPoliceVehicle(playerid) ) {
            if ( isOfficer(playerid) ) {
                msg(playerid, "[POLICE RADIO] " + getAuthor(sender) + ": " + plocalize(playerid, "organizations.police.tencode." + phrase_key, [message]), CL_ROYALBLUE);
            } else {
                msg(playerid, "[POLICE RADIO] " + getAuthor(sender) + ": " + phrase_key + " " + message, CL_ROYALBLUE);
            }
        }
    }
}
*/

//     ["10-41", "organizations.police.tencode.10-41"], // Офицер заступил на смену
//     ["10-41", "organizations.police.tencode.10-41"], // Офицер закончил смену

//     ["10-1", "organizations.police.tencode.10-1"],  // Код 1 » Возможны человеческие жертвы, прибыть как можно скорее, действовать аккуратно
//     ["10-2", "organizations.police.tencode.10-2"],  // Код 2 » Отбой по вызову, ситуация под контролем, преступник нейтрализован
//     ["10-3", "organizations.police.tencode.10-3"], // Тишина в эфире / Stop transmitting
//     ["10-4", "organizations.police.tencode.10-4"], // Сообщение получено / Affirmative
//     ["10-5", "organizations.police.tencode.10-5"], // Передача сообщения от кого-то кому-то / Relay To/From
//     ["10-6", "organizations.police.tencode.10-6"], // Нет ответа от экипажа / Out of service; Код 6 » Держаться по периметру оцепления, не стрелять
//     ["10-7", "organizations.police.tencode.10-7"], // Есть ответ от экипажа / In service
//     ["10-8", "organizations.police.tencode.10-8"], // Повторите сообщение / Repeat last message
//     ["10-9", "organizations.police.tencode.10-9"], // Прибыл на место происшествия / Arrived at Scene
//     ["10-10", "organizations.police.tencode.10-10"], // Идет перестрелка / Fight in progress
//     ["10-11", "organizations.police.tencode.10-11"], // Код 11 » Приготовиться к штурму/операции/захвату
//     ["10-12", "organizations.police.tencode.10-12"], // Погоня / Dog chase
//     ["10-13", "organizations.police.tencode.10-13"], // Ожидайте / stand by
//     ["10-14", "organizations.police.tencode.10-14"], // Вандализм / Vandalism
//     ["10-15", "organizations.police.tencode.10-15"], // Опасные погодные условия / Dangerous weather conditions
//     ["10-16", "organizations.police.tencode.10-16"], // 10-16 _место_ » Передача местонахождения <в точке/место> / Location <place>
//     ["10-17", "organizations.police.tencode.10-17"], // Возможен взлом/угон / Investigate possible Break in
//     ["10-18", "organizations.police.tencode.10-18"], // Ожидаемое время пребытия / Estimated Arrival Time (ETA)
//     ["10-19", "organizations.police.tencode.10-19"], // 10-17 Срочное сообщение
//     ["10-20", "organizations.police.tencode.10-20"], // 10-26 Последняя информация отменяется (отставить!)
//     ["10-21", "organizations.police.tencode.10-21"], // 10-34 (место) » Офицер запрашивает подмогу (место)
//     ["10-22", "organizations.police.tencode.10-22"], // Мятеж / Riot
//     ["10-23", "organizations.police.tencode.10-23"], // Происшествие / Caution
//     ["10-24", "organizations.police.tencode.10-24"], // Подозрительный автомобиль / Suspicius vehicle
//     ["10-25", "organizations.police.tencode.10-25"], // Использовать мигалку и сирены / Use light and siren
//     ["10-26", "organizations.police.tencode.10-26"], // Не использовать мигалку, только сирену / No light, siren
//     ["10-27", "organizations.police.tencode.10-27"], // Ведется погоня / In pursuit
//     ["10-28", "organizations.police.tencode.10-28"], // Запрос покинуть (место) для (причина) / Permission to leave (place) for (reason)
//     ["10-29", "organizations.police.tencode.10-29"], // Сработала охранная сигнализация банка / Bank alarm
//     ["10-30", "organizations.police.tencode.10-30"], // Дорожные работы в (место) / Road repair at (place)
//     ["10-31", "organizations.police.tencode.10-31"], // Требуется таран / Dispatch wrecker
//     ["10-32", "organizations.police.tencode.10-32"], // Перекрытие дороги / Road blocked
//     ["10-33", "organizations.police.tencode.10-33"], // Пьяный водитель / Intoxicated driver
//     ["10-34", "organizations.police.tencode.10-34"], // Пьяный гражданин / Intoxicated pedestrian
//     ["10-35", "organizations.police.tencode.10-35"], // Сопровождение / Escort
//     ["10-36", "organizations.police.tencode.10-36"], // Вооруженное ограбление / armed robbety
//     ["10-37", "organizations.police.tencode.10-37"], // Есть пострадавшие / Report of injury
//     ["10-38", "organizations.police.tencode.10-38"], // Побег из тюрьмы / Jail break
//     ["10-39", "organizations.police.tencode.10-39"], // Розыскивается или украден / Wanted or Stolen
//     ["10-40", "organizations.police.tencode.10-40"], // Не использовать мигалку и сирену / No lights or siren

//     ["10-42", "organizations.police.tencode.10-42"], // Превышение скорости / Drag racing
//     ["10-43", "organizations.police.tencode.10-43"], // Подозреваемый (имя) под охраной / Subject (name) in custody
//     ["10-44", "organizations.police.tencode.10-44"], // Проверка связи / Check signal
//     ["10-45", "organizations.police.tencode.10-45"], // Доложите ваш статус / What is your status
//     ["10-46", "organizations.police.tencode.10-46"], //
//     ["10-200", "organizations.police.tencode.10-200"], // 10-200 место » Нужна полиция туда то тудато
// ];
