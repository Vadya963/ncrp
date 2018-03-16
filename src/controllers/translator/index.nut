include("controllers/translator/commands.nut");
include("controllers/translator/alternativeFormat.nut");

__translations <- {};

/**
 * Register transaltion table
 * Can me used for multiple languages
 * Can be used multiple times for signle language
 *
 * @param  {String} language - 2 letter code representing language ["en", "ru"]
 * @param  {Table}  data - table containint pairs of key : value,
 *          where key is string value that should be replaced,
 *          and value is result of replacing
 *
 * @return {Boolean} true
 */
function translation(language, data) {
    if (!(language in __translations)) {
        __translations[language] <- {};
    }

    // maybe its a function, then call it !
    if (typeof data == "function") {
        data = data();
    }

    // save new translation data
    foreach (idx, value in data) {
        __translations[language][idx] <- value;
    }

    return true;
}

translator <- translation;
translate  <- translation;

/**
 * Compare 2 language translations
 * and print differences
 * @param  {String} from
 * @param  {String} to
 */
function compareTranslations(from, to) {
    if (!(from in __translations) || !(to in __translations)) {
        return dbg("unknown pair: ", [from, to]);
    }

    foreach (idx, value in __translations[from]) {
        if (!(idx in __translations[to])) {
            print(idx);
        }
    }
}

/**
 * Dump tranlsation for provided language
 * @param  {String} lang
 * @return {Boolean}
 */
function dumpTranslation(lang) {
    if (!(lang in __translations)) {
        return dbg("unknown language", lang);
    }

    local keys = tableKeys(__translations[lang]);
    local dt = DataFile("logs/" + lang + ".dump.json", "w");

    dt.write("{");
    keys.sort();

    while (keys.len()) {
        local name  = keys.pop();
        local value = __translations[lang][name];
        local comma = keys.len() ? "," : "";
        dt.write("    \"" + name + "\": \"" + value + "\"" + comma);
    }

    dt.write("}");
    dt.close();

    return dbg("successfuly dumped", lang, "to logs/ dir");
}

/**
 * Try to localize passed value
 * First of all, check if provided language exists
 * And then check if value is registered via `translation` functions
 * If value is found, `format` function will be applied, taking `params` as argument
 *
 * @param  {String} value
 * @param  {Array}  params - array of parameters that will be passed to `format` function
 * @param  {String} language - language to try translate to
 * @return {String} translated (or not) value
 */
function localize(value, params = [], language = "en") {
    if (language in __translations && value in __translations[language]) {
        local args = clone(params);

        // insert params
        args.insert(0, getroottable());
        args.insert(1, __translations[language][value]);

        // format and return
        try {
            return format.acall(args);
        } catch (e) {
            ::print("[error][translation] cannot format output value by tag: " + value + "\n");
            return value;
        }
    }

    local args = clone(params);

    // insert params
    args.insert(0, getroottable());
    args.insert(1, value);

    // format `value` if replaces are not found
    try {
        return format.acall(args);
    }
    catch (e) {
        return str_replace("%", "$", value);
    }
}

function plocalize(playerid, value, params = []) {
    return localize(value, params, getPlayerLocale(playerid));
}

function partLocalize(playerid, values, template) {
    local lang = getPlayerLocale(playerid);
    local phrases = values.map(function(value) {
        return localize(value, [], lang);
    })

    local args = clone(phrases);

    // insert params
    args.insert(0, getroottable());
    args.insert(1, template);

    // format `value` if replaces are not found
    try {
        return format.acall(args);
    }
    catch (e) {
        return str_replace("%", "$", template);
    }
}

/**
 * Testing
 */
// translation("en", {
//     "bus.entry" : "Enter the bus",
//     "only.eng"  : "Only english"
// });

// translation("en", {
//     "say.hello" : "Say hello to my little fried %s!",
//     "say.elllo2"  : "U %d's motherfucker for today, jezuz %s, shut the fuck up!"
// });

// translation("ru", {
//     "bus.entry" : "Войти в автобус"
// });

// print( localize("test") + "\n" );
// print( localize("bus.entry")+ "\n" );
// print( localize("only.eng")+ "\n" );
// print( localize("bus.entry", [], "ru")+ "\n" );

// print( localize("say.hello", ["Inlife"])+ "\n" );
// print( localize("say.elllo2", [4, "BITCH"])+ "\n" );
