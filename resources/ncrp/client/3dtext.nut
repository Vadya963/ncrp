local _3Dtext_vectors = {};
local _3Dtext_objects = {};

addEventHandler("onClientFramePreRender", function() {
    foreach(i,obj in _3Dtext_objects) {
        local pos = obj.pos;
        _3Dtext_vectors[i] <- getScreenFromWorld(pos.x, pos.y, (pos.z + 1.0));
    }
});

addEventHandler("onClientFrameRender", function(post) {
    if (!post) {
        foreach(i,obj in _3Dtext_objects) {
            local pos = obj.pos;
            local lclPos;
            if (isPlayerInVehicle(getLocalPlayer())) {
                lclPos = getVehiclePosition(getPlayerVehicle(getLocalPlayer()));
            } else {
                lclPos = getPlayerPosition(getLocalPlayer());
            }

            if (typeof(lclPos) != "array") return;
            local fDistance = getDistanceBetweenPoints3D(pos.x, pos.y, pos.z, lclPos[0], lclPos[1], lclPos[2]);

            if (fDistance <= obj.distance && (i in _3Dtext_vectors) && _3Dtext_vectors[i][2] < 1) {
                local dims = dxGetTextDimensions(obj.name, 1.0, "tahoma-bold");

                // dxDrawText(obj.name, (_3Dtext_vectors[i][0] - (dims[0] / 2)) + 1, _3Dtext_vectors[i][1] + 1, 0xFF000000, false, "tahoma-bold");
                dxDrawText(obj.name, (_3Dtext_vectors[i][0] - (dims[0] / 2)), _3Dtext_vectors[i][1], obj.color, false, "tahoma-bold");
            }
        }
    }
});

addEventHandler("onServer3DTextAdd", function(uid, x, y, z, text, color, d) {
    local obj = {
        uid = uid,
        name = text.tostring(),
        pos = {
            x = x.tofloat(),
            y = y.tofloat(),
            z = z.tofloat()
        },
        color = color,
        distance = d.tofloat()
    };

    _3Dtext_objects[obj.uid] <- obj;
});

addEventHandler("onServer3DTextDelete", function(uid) {
    delete _3Dtext_objects[uid];
});


/**
 * JSON encoder
 *
 * @author Mikhail Yurasov <mikhail@electricimp.com>
 * @verion 0.7.0
 */
class JSONEncoder {

  static version = [1, 0, 0];

  // max structure depth
  // anything above probably has a cyclic ref
  static _maxDepth = 32;

  /**
   * Encode value to JSON
   * @param {table|array|*} value
   * @returns {string}
   */
  function encode(value) {
    return this._encode(value);
  }

  /**
   * @param {table|array} val
   * @param {integer=0} depth – current depth level
   * @private
   */
  function _encode(val, depth = 0) {

    // detect cyclic reference
    if (depth > this._maxDepth) {
      throw "Possible cyclic reference";
    }

    local
      r = "",
      s = "",
      i = 0;

    switch (typeof val) {

      case "table":
      case "class":
        s = "";

        // serialize properties, but not functions
        foreach (k, v in val) {
          if (typeof v != "function") {
            s += ",\"" + k + "\":" + this._encode(v, depth + 1);
          }
        }

        s = s.len() > 0 ? s.slice(1) : s;
        r += "{" + s + "}";
        break;

      case "array":
        s = "";

        for (i = 0; i < val.len(); i++) {
          s += "," + this._encode(val[i], depth + 1);
        }

        s = (i > 0) ? s.slice(1) : s;
        r += "[" + s + "]";
        break;

      case "integer":
      case "float":
      case "bool":
        r += val;
        break;

      case "null":
        r += "null";
        break;

      case "instance":

        if ("_serializeRaw" in val && typeof val._serializeRaw == "function") {

            // include value produced by _serializeRaw()
            r += val._serializeRaw().tostring();

        } else if ("_serialize" in val && typeof val._serialize == "function") {

          // serialize instances by calling _serialize method
          r += this._encode(val._serialize(), depth + 1);

        } else {

          s = "";

          try {

            // iterate through instances which implement _nexti meta-method
            foreach (k, v in val) {
              s += ",\"" + k + "\":" + this._encode(v, depth + 1);
            }

          } catch (e) {

            // iterate through instances w/o _nexti
            // serialize properties, but not functions
            foreach (k, v in val.getclass()) {
              if (typeof v != "function") {
                s += ",\"" + k + "\":" + this._encode(val[k], depth + 1);
              }
            }

          }

          s = s.len() > 0 ? s.slice(1) : s;
          r += "{" + s + "}";
        }

        break;

      // strings and all other
      default:
        r += "\"" + this._escape(val.tostring()) + "\"";
        break;
    }

    return r;
  }

  /**
   * Escape strings according to http://www.json.org/ spec
   * @param {string} str
   */
  function _escape(str) {
    local res = "";

    for (local i = 0; i < str.len(); i++) {

      local ch1 = (str[i] & 0xFF);

      if ((ch1 & 0x80) == 0x00) {
        // 7-bit Ascii

        ch1 = format("%c", ch1);

        if (ch1 == "\"") {
          res += "\\\"";
        } else if (ch1 == "\\") {
          res += "\\\\";
        } else if (ch1 == "/") {
          res += "\\/";
        } else if (ch1 == "\b") {
          res += "\\b";
        } else if (ch1 == "\f") {
          res += "\\f";
        } else if (ch1 == "\n") {
          res += "\\n";
        } else if (ch1 == "\r") {
          res += "\\r";
        } else if (ch1 == "\t") {
          res += "\\t";
        } else if (ch1 == "\0") {
          res += "\\u0000";
        } else {
          res += ch1;
        }

      } else {

        if ((ch1 & 0xE0) == 0xC0) {
          // 110xxxxx = 2-byte unicode
          local ch2 = (str[++i] & 0xFF);
          res += format("%c%c", ch1, ch2);
        } else if ((ch1 & 0xF0) == 0xE0) {
          // 1110xxxx = 3-byte unicode
          local ch2 = (str[++i] & 0xFF);
          local ch3 = (str[++i] & 0xFF);
          res += format("%c%c%c", ch1, ch2, ch3);
        } else if ((ch1 & 0xF8) == 0xF0) {
          // 11110xxx = 4 byte unicode
          local ch2 = (str[++i] & 0xFF);
          local ch3 = (str[++i] & 0xFF);
          local ch4 = (str[++i] & 0xFF);
          res += format("%c%c%c%c", ch1, ch2, ch3, ch4);
        }

      }
    }

    return res;
  }
}

function dbg(...) {
    return ::print("[debug] " + JSONEncoder.encode(vargv));
}
