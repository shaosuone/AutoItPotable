function serviceHeader(){return new ServiceHeader(11,"Yandex",'<a href="http://translate.yandex.com/">http://translate.yandex.com/</a>'+Const.NL+"\u00a9 2011-2014 \u00abYandex\u00bb",Capability.TRANSLATE|Capability.DETECT_LANGUAGE|Capability.LISTEN)}function serviceHost(b,a,c){return b===Capability.LISTEN?"tts.voicetech.yandex.net":"translate.yandex.net"}function serviceLink(b,a,c){return"http://translate.yandex.com/"}
SupportedLanguages=[-1,-1,-1,"az","sq","ar","hy",-1,"be","bg","ca",-1,-1,"hr","cs","da","nl","en","et","fi",-1,"fr",-1,"de","el",-1,"he",-1,"hu","is","id","it",-1,-1,"ka",-1,"lv","lt","mk","ms","mt","no",-1,"pl","pt","ro","ru","sr","sk","sl","es",-1,"sv",-1,"tr","uk",-1,"vi",-1,-1,-1,-1,-1,-1];function serviceDetectLanguageRequest(b){b=format("/api/v1/tr.json/detect?srv=tr-text&text={0}",encodeGetParam(b));return new RequestData(HttpMethod.GET,b)}
function serviceDetectLanguageResponse(b){return(b=(new Function("return "+b))())&&b.code&&200==b.code?languageFromCode(b.lang):UNKNOWN_LANGUAGE}function serviceTranslateRequest(b,a,c){a=format("/api/v1/tr.json/translate?lang={0}-{1}&srv=tr-text&text=",codeFromLanguage(a),codeFromLanguage(c));a+=encodeGetParam(b).replace(/%0D/g,"%0A");return new RequestData(HttpMethod.GET,a)}
function serviceTranslateResponse(b,a,c,l){(a=(new Function("return "+a))())&&a.code&&200==a.code&&(a=a.text[0]);b=b&&!/[\n\r]/.test(b)&&3>=b.split(" ").length?"dictionaryRequest":null;return new ResponseData(a,c,l,null,b)}function dictionaryRequest(b,a,c){b=format("/dicservice.json/lookup?text={0}&lang={1}-{2}",encodeGetParam(b),codeFromLanguage(a),codeFromLanguage(c));return new RequestData(HttpMethod.GET,b,null,null,null,"dictionaryResponse")}
function dictionaryResponse(b,a,c,l){b=(new Function("return "+a))();a=Const.NL;if("object"==typeof b&&b.def)for(var m=0;m<b.def.length;m++){var h=b.def[m];if(h.tr){a+=Const.NL+"/"+h.tr[0].pos+"/"+Const.NL;for(var k=0;k<h.tr.length;k++){var e=h.tr[k];a+=k+1+". "+e.text;if(e.syn)for(var d=0;d<e.syn.length;d++)a+=", "+e.syn[d].text;a+=Const.NL;if(e.mean){a+="\t(";for(var f=!1,d=0;d<e.mean.length;d++){var g=e.mean[d];f&&(a+=", ");a+=g.text;f=!0}a+=")"+Const.NL}if(e.ex)for(d=0;d<e.ex.length;d++){g=e.ex[d];
a+="\t"+g.text+" - ";for(var f=!1,n=0;n<g.tr.length;n++)f&&(a+=", "),a+=g.tr[n].text,f=!0;a+=Const.NL}}}}return new ResponseData(a,c,l)}function serviceListenRequest(b,a){var c="en_GB";switch(codeFromLanguage(a)){case "ru":c="ru_RU"}c=format("/tts?format=mp3&quality=hi&platform=web&application=translate&lang={0}&text={1}",c,encodeGetParam(b));return new RequestData(HttpMethod.GET,c)};