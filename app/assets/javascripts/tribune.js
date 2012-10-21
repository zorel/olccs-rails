var highlight_div, form, current_highlight;
var horloges = {};
var lastHorlogeInit;
var canfix;
var tribune;
var skip_update = 0;
var post_template = "<li id='p{{id}}'><span class='horloge'>{{time}}</span> <span class='{{class_display}}' title='{{&info}}'>{{&ua_or_login}}</span> <span class='message'>{{&message}}</span></li>";
var first_load = true;

var myrules = {
    'a.smiley:mouseover':function (el, ev) {
        return overlib('<img src="' + el.href + '"/>', FULLHTML);
        /*(el.href,ev);*/
    },
    'a.smiley:mouseout':function (el) {
        return nd();
    },
    '#tribune span':function (el) {
        initSpan(el);
    }
};

function removeHorlogeChild(array, hh) {
    delete array.child[hh];
    var child;
    for (child in array.child)
        break;
    if (!child) {
        delete array.child;
        if (typeof array.objs == 'undefined')
            removeHorlogeChild(array.parent, array.hh);
    }
}

function removeHorloge(array, obj) {
    for (var i = 0; i < array.objs.length; i++)
        if (array.objs[i] == obj)
            break;
    array.objs.splice(i, 1);
    if (array.objs.length == 0) {
        delete array.objs;
        if (typeof array.child == 'undefined')
            removeHorlogeChild(array.parent, array.hh);
    }
}


function getSelectionRange(field) {
    if (field.setSelectionRange)
        return [field.selectionStart, field.selectionEnd];
    else if (field.createTextRange) {
        var range = document.selection.createRange();
        if (range.parentElement() == field) {
            var range2 = field.createTextRange();
            range2.collapse(true);
            range2.setEndPoint('EndToEnd', range);
            return [range2.text.length - range.text.length, range2.text.length];
        }
    }
    return [field.value.length, field.value.length];
}

function setSelectionRange(field, start, end) {
    if (field.setSelectionRange)
        field.setSelectionRange(start, end);
    else if (field.createTextRange) {
        var range = field.createTextRange();
        range.collapse(true);
        range.moveStart('character', start);
        range.moveEnd('character', end - start);
        range.select();
    }
}

function appendHorlogeToMessage(text) {
    var missive = form.message;
    var temp = missive.value;
    var range = getSelectionRange(missive);
    missive.focus();
    missive.value = temp.substring(0, range[0]) + text + temp.substring(range[1], temp.length);
    setSelectionRange(missive, range[0] + text.length, range[0] + text.length);
    return true;
}

/*
 * RÃ©cupÃ©re la position d'un objet
 * TestÃ© avec konquy, et mozilla
 */
function getYPosition(obj) {
    if (!obj) return;
    // récupère la position d'un objet selon les méthodes alloués par le browser
    if (obj.offsetParent) {
        for (var posY = 0; obj.offsetParent; obj = obj.offsetParent) {
            posY += obj.offsetTop;
        }
        return posY;
    } else {
        return obj.y;
    }
}

function getScrollY() {
    if (document.documentElement && document.documentElement.scrollTop) {
        return document.documentElement.scrollTop;
    } else if (document.body && document.body.scrollTop) {
        return document.body.scrollTop;
    }
    return 0;
}

function textContent(element) {
    try {
        if (element.textContent)
            return element.textContent;
    } catch (e) {
    }
    if (element.text)
        return element.text;

    var children = element.childNodes;
    var result = "";
    for (var i = 0; i < children.length; i++) {
        var node = children[i];
        if ((node.nodeType >= 3) && (node.nodeType <= 6)) {
            result += node.nodeValue;
        } else if (node.nodeType == 1) {
            result += textContent(node);
        }
    }
    // Workaround for konqueror : it can't set element.textContent for some reason, while it doesn't support it... so we use element.text...
    element.text = result;
    return result;
}

function addClass(obj, className) {
    if (obj.className) {
        if (obj.className.indexOf(className) != -1) return;
        obj.className += ' ' + className;
    } else
        obj.className = className;
}

function removeClass(obj, className) {
    var index;
    if ((index = obj.className.indexOf(className)) != -1) {
        var length = className.length;
        if ((index > 0) && (obj.className[index - 1] == ' ')) {
            index--;
            length++;
        } else if ((index == 0) && (obj.className[length] == ' '))
            length++;
        obj.className = obj.className.substring(0, index) + obj.className.substring(index + length);
    }
}

var RECURSE_PARENT_HORLOGES = 1;
var RECURSE_CHILD_HORLOGES = 2;

function recurseHorloges(array, callback, recurse_type) {
    if (!array) return;
    if (array.objs)
        for (i = 0; i < array.objs.length; i++)
            if (callback.call(array.objs[i])) return true;
    if ((typeof recurse_type == 'undefined') || (recurse_type == RECURSE_PARENT_HORLOGES))
        if (array.parent)
            if (recurseHorloges(array.parent, callback, RECURSE_PARENT_HORLOGES)) return true;
    if ((typeof recurse_type == 'undefined') || (recurse_type == RECURSE_CHILD_HORLOGES))
        for (l in array.child)
            if (recurseHorloges(array.child[l], callback, RECURSE_CHILD_HORLOGES)) return true;
    return false;
}

function highlight(event) {
    if (current_highlight) this.onmouseout(); // Pour konqueror, qui a de droles de maniÃ¨res de gÃ©rer onmouseover/onmouseout avec le rafraichissement de la page.
    current_highlight = this.highlight;
    var show = false;
    recurseHorloges(this.highlight, function () {
        if ((this.nodeName.toLowerCase() == 'li') && (!this.parentNode || (getYPosition(this) < getScrollY()))) {
            show = true;
            var clone = this.cloneNode(true);
            for (node in clone.getElementsByTagName('span'))
                node.onmouseover = node.onmouseout = null;
            highlight_div.appendChild(clone);
        }
        addClass(this, 'highlight');
    });
    if (show) {
        if (!canfix) highlight_div.style.top = (getScrollY() + highlight_div.top_position) + 'px';
        highlight_div.style.visibility = 'visible';
    }
}

function kill_highlight_div() {
    highlight_div.style.visibility = 'hidden';
    while (highlight_div.firstChild) {
        highlight_div.removeChild(highlight_div.firstChild);
    }
}

function unhighlight(event) {
    if (highlight_div.offsetTop || highlight_div.offsetHeight) {
        event = event || window.event;
        var offsetTop = highlight_div.offsetTop + canfix ? 0 : getScrollY();
        if (event && event.clientX >= highlight_div.offsetLeft &&
            event.clientX <= highlight_div.offsetLeft + highlight_div.offsetWidth &&
            event.clientY >= offsetTop &&
            event.clientY <= offsetTop + highlight_div.offsetHeight) {
            return;
        }
    }
    if (this.highlight)
        recurseHorloges(this.highlight, function () {
            removeClass(this, 'highlight');
        });
    current_highlight = null;
    kill_highlight_div();
}

function pushHorloge(h, obj) {
    return pushHorlogeRecurse(horloges, h, obj);
}

function pushHorlogeRecurse(array, h, obj) {
    if (!h) {
        if (!array.objs)
            array.objs = new Array;
        array.objs.push(obj);
        return array;
    } else {
        var hh = h.substring(0, 2);
        if (!array.child)
            array.child = new Array;
        if (!array.child[hh]) {
            array.child[hh] = {};
            array.child[hh].parent = array;
            array.child[hh].hh = hh;
        }
        return pushHorlogeRecurse(array.child[hh], h.substring(2), obj);
    }
}
//var re_horloge = new RegExp("((?:1[0-2]|0[1-9])/(?:3[0-1]|[1-2][0-9]|0[1-9])#)?((?:2[0-3]|[0-1][0-9])):([0-5][0-9])(:[0-5][0-9])?([¹²³]|[:\^][1-9]|[:\^][1-9][0-9])?(@[A-Za-z0-9_]+)?", "");
//var re_horloge2 = new RegExp("(?:(?:([0-2]?[0-9])\:([0-5][0-9])\:([0-5][0-9])|([0-2]?[0-9])([0-5][0-9])([0-5][0-9]))(?:[\:\^]([0-9]{1,2})|([¹²³]))?)|([0-2]?[0-9])\:([0-5][0-9])(?=\s|$|<)", "g");
var re_horloge = new RegExp("(?:(?:([0-2]?[0-9])\:([0-5][0-9])\:([0-5][0-9])|([0-2]?[0-9])([0-5][0-9])([0-5][0-9]))(?:[\:\^]([0-9]{1,2})|([¹²³]))?)|([0-2]?[0-9])\:([0-5][0-9])");

function getHorloge(span) {
    if (span.horloge) return span.horloge;
    var match = re_horloge.exec(textContent(span));
    match.shift();
    if ((typeof match[6] != 'undefined') && (match[6] != '')) {
        if (match[6].length == 1)
            match[6] = '0' + match[6];
    } else if ((typeof match[7] != 'undefined') && (match[7] != '')) {
        switch (match[7]) {
            case '¹':
                match[7] = '01';
                break;
            case '²':
                match[7] = '02';
                break;
            case '³':
                match[7] = '03';
                break;
        }
    }
    var horloge = match.join('');
    if (horloge.length % 2) horloge = '0' + horloge;

    span.horloge = horloge;
    return horloge;
}

function writeClocks(message) {
    //             0             1         2     3      4     5     6
    //["11/01#22:10:25^1@dlfp", "11/01#", "22", "10", ":25", "^1", "@dlfp"]
    var offset = 0;
    var indexes = new Array();

    // On recherche les indices des horloges
    var h = re_horloge.exec(message);
    while (h && h.length > 0) {
        var hpos = offset + h.index;
        indexes.push([hpos, '<span class="horloge_ref">']);
        offset = hpos + h[0].length
        indexes.push([offset, '</span>']);

        // Recherche de la prochaine occurrence de norloge
        h = re_horloge.exec(message.substr(offset));
    }

    // Insertion des balises
    for (var i = indexes.length - 1; i >= 0; i--) {
        var pos_str = indexes[i];
        message = message.substr(0, pos_str[0]) + pos_str[1] + message.substr(pos_str[0]);
    }
    return message;
}

function initSpan(span) {
    if (span.className.substring(0, 7) == "horloge") {
        span.onmouseover = highlight;
        span.onmouseout = unhighlight;
        if (span.className == "horloge") {
            var currentHorloge = getHorloge(span);
            if (currentHorloge.length == 6) {
                var num = 1;
                if (lastHorlogeInit) {
                    var lastHorloge = getHorloge(lastHorlogeInit);
                    if ((lastHorloge.length > 6) && (lastHorloge.substring(0, 6) == currentHorloge)) {
                        num = Number(lastHorloge.substring(6)) + 1;
                    }
                }
                currentHorloge = currentHorloge + ((num < 10) ? '0' + num : num);
                span.horloge = currentHorloge;
            } else {
                num = Number(currentHorloge.substring(6, 8));
            }
            span.highlight = pushHorloge(currentHorloge, span.parentNode);
            span.horlogeText = currentHorloge.substring(0, 2) + ':' + currentHorloge.substring(2, 4) + ':' + currentHorloge.substring(4, 6);
            switch (num) {
                case 1:
                    break;
                case 2:
                    span.horlogeText += '²';
                    if (lastHorlogeInit) lastHorlogeInit.horlogeText += 'Â¹';
                    break;
                case 3:
                    span.horlogeText += '³';
                    break;
                default:
                    span.horlogeText += '^' + num;
                    break;
            }
            span.onclick = function () {
                appendHorlogeToMessage(this.horlogeText + ' ');
            }
            lastHorlogeInit = span;
        } else if (span.className.substring(0, 11) == "horloge_ref") {
            var currentHorloge = getHorloge(span);
            span.onclick = function () {
                var scrollY = getScrollY();
                recurseHorloges(this.highlight, function () {
                    var PosY = getYPosition(this);
                    if (scrollY > PosY)
                        scrollY = PosY;
                });
                kill_highlight_div();
                window.scrollTo(0, scrollY);
            }
            span.highlight = pushHorloge(currentHorloge, span);
            if (current_highlight && recurseHorloges(span.highlight, function () {
                if (this.className.indexOf('highlight') != -1) return true;
            }))
                addClass(span, 'highlight');
        }
    }
}

function initTribune() {
    tribune = document.getElementById('tribune');
    /* On old mozilla, in xhtml mode, document.body doesn't exist */
    if (!document.body)
        document.body = document.documentElement.getElementsByTagName('body')[0];

    /* Find out if position: fixed is supported */
    var tmpNode = document.createElement('div');
    tmpNode.style.width = '1px';
    tmpNode.style.height = '1px';
    tmpNode.style.right = '-1px';
    tmpNode.style.position = 'fixed';
    document.body.appendChild(tmpNode);
    var offset = tmpNode.offsetLeft;
    tmpNode.style.position = 'absolute';
    canfix = tmpNode.offsetLeft == offset;
    document.body.removeChild(tmpNode);

    // Création du div pour le highlight
    highlight_div = document.createElement('div');
    highlight_div.id = 'highlight';
    highlight_div.style.visibility = 'hidden';
    highlight_div.onmouseout = function () {
        this.highlight = current_highlight;
        unhighlight.call(this);
    };
    tribune.appendChild(highlight_div);

    if (!canfix) {
        highlight_div.style.position = 'absolute';
        highlight_div.top_position = highlight_div.offsetTop;
    }

    // Machins pour l'initialisation du input
    form = tribune.getElementsByTagName('form')[0];

//    dicalExecuter(function () {
//        if (skip_update == 0) {
//            tribune_update();
//        }
//    }, 10);
//    EventSelectors.start(myrules);

    var input = form.getElementsByTagName('input')[0];
    check = document.createElement('input');
    check.setAttribute('type', 'checkbox');
    check.setAttribute('title', 'auto-refresh');
    check.setAttribute('checked', 'checked'); // Pour Konqueror qui n'aime pas si c'est fait aprÃ¨s.
    $('postDiv').insertBefore(check, input);
    check.setAttribute('checked', 'checked'); // Pour IE qui n'aime pas si c'est fait avant.

    /*	new Form.Element.Observer('missive', 2, function(element, value) {new Ajax.Request('/tribune/preview', {asynchronous:true, evalScripts:true, parameters:'hack=true&'+Form.Element.serialize('missive')})});*/
//    Ext.get("missive").focus()
    /*   Element.observe(document, "keydown", keyHandler);*/


}

/* TRibUnE 2.0 */
function tribune_update() {
    var list_tribune = $("#list_tribune");
    var all = $("#list_tribune li");
    var last, first, scroll;
    if (all.length > 0) {
        last = all.last()[0].id;
        scroll = true;
    } else {
        last = first = "p-1073741824";
    }

    var last_id = parseInt(last.substring(1, last.length));

    $.ajax({
        statusCode:{
            404:function () {
                alert("404 not found on ajax refresh o_O");
            }
        },
        dataType:'json',
        data:{id:last_id},
        success:function (remote) {
            posts = remote['posts'].reverse();
            if (posts.size == 0) {
                return true;
            }
            var numposts = all.length;

            $.each(posts, (function (i, p) {
                a = $("#p" + p['id']);

                if (a.length == 0 && p['id'] > last_id) {
                    r = $(Mustache.render(post_template, p));
                    list_tribune.append(r);

                    $("span", r).each(function (i, span) {
                        initSpan(span);
                    });

                    if (++numposts > 150) {
                        var first = $("#tribune li").first();
                        var spans = $("span", first).each(function (i, span) {
                            if (span.className.indexOf('horloge_ref') != -1) {
                                removeHorloge(span.highlight, span);
                            } else if (span.className.indexOf('horloge') != -1) {
                                removeHorloge(span.highlight, span.parentNode);
                            }
                        });
                        first.remove();
                    }
                }
            }));

            if (first_load) {
                point_to_anchor();
            }
        }

    });

    return true;
}

function point_to_anchor() {
    var url = $.url();
    var a = url.attr('anchor');

    if (a != '') {
        $.scrollTo("#"+a, 0, { offset: {left: 0, top:-40 }});
        $("#"+a).prepend('<i class="icon-arrow-right"></i>');
    } else {
        $.scrollTo("#message");
    }

    first_load = false;

}
/**
 * create an image tooltip and insert it at mouse coordinates.
 * @param imgSource the url to the image
 * @param currentId id of the tooltip
 * @param event the browser event object
 */
function createImageToolTip(imgSource, event) {
    var newDiv = getTooltipObject("hfrtooltip");
    if (newDiv == null) {
        var image = document.createElement("img");
        image.setAttribute("style", "opacity: 0.8");
        image.setAttribute("src", imgSource);
        newDiv = document.createElement("div");
        newDiv.appendChild(image);
        var x = 0;
        var y = 0;
        if (event != null) {
            x = event.clientX + 15;
            y = event.clientY + 15;
        }
        else {
            x = window.event.clientX + 15;
            y = window.event.clientY + 15;
        }
        if ((navigator.userAgent.toLowerCase().indexOf("opera") == -1) &&
            (document.all)) {
            if (document.documentElement && document.documentElement.scrollTop) {
                var temp_y = y + document.documentElement.scrollTop;
                newDiv.style.position = "absolute";
                newDiv.style.top = temp_y + "px";
                newDiv.style.left = x + "px";
            }
            else if (document.body.scrollTop) {
                var temp_y = y + document.body.scrollTop;
                newDiv.style.position = "absolute";
                newDiv.style.top = temp_y + "px";
                newDiv.style.left = x + "px";
            }
        }
        else if (navigator.userAgent.toLowerCase().indexOf("safari" != -1)) {
            realy = y - document.body.scrollTop;
            newDiv.setAttribute("style",
                "position: fixed;" +
                    "top: " + realy + "px; left: " + x + "px;");
        }
        else {
            if (window.console) {
                window.console.log("top: " + y + "px; left: " + x + "px;");
            }
            newDiv.setAttribute("style",
                "position: fixed;" +
                    "top: " + y + "px; left: " + x + "px;");
        }
        newDiv.setAttribute("id", "hfrtooltip");
        document.getElementsByTagName("body")[0].appendChild(newDiv);
    }
}

/**
 * Return the tooltip object with the given id
 * currentId the id of the tooltip
 */
function getTooltipObject(currentId) {
    return document.getElementById(currentId);
}

/**
 * Remove the tooltip with the given id from the page
 * @param idToRemove the id of the tooltip
 */
function removeMe(idToRemove) {
    try {
        var tagToRemove = document.getElementById(idToRemove);
        if (tagToRemove != null)
            document.getElementsByTagName("body")[0].removeChild(tagToRemove);
    }
    catch (Exception) {
    }
}

$(document).ready(function () {
    if ($("#tribune").length == 0){
        return true;
    }
    initTribune();

    $("#tribune span").each(function(i, span) {
        initSpan(span);
    });

//    $("#tribune span.totoz").live("mouseover", function() {
//        $("#tribune span.totoz").each(function(i, span) {
//            if( $(this).data('qtip') ) { return true; }
//            var totoz_name=$(span).text();
//            totoz_name = totoz_name.substring(2,totoz_name.length-1);
//            $(this).qtip({
//                content:"<img src='http://sfw.totoz.eu/" + encodeURI(totoz_name) + ".gif'/>",
//                delay: 0,
//                show: { effect: { type: 'none', length: 0 } }
//            })
//        })
//    });

    $("#form_post")
        .live("ajax:beforeSend", function() {
            $("#submit").attr('disabled','disabled');
        })
        .live("ajax:success", function() {
            tribune_update();
        })
        .live("ajax:complete", function() {
            $("#submit").removeAttr('disabled');
            $("#message").val("");
        })
    ;

    tribune_update();

    var x = setInterval(function() {tribune_update()}, 30000);

});


