function serviceHeader(){return new ServiceHeader(1,"Google Translate",'<a href="https://translate.google.com/">https://translate.google.com/</a>'+Const.NL+"\u00a9 2014 Google. All rights reserved.",Capability.TRANSLATE|Capability.DETECT_LANGUAGE|Capability.LISTEN)}function serviceHost(a,c,b){return"https://translate.google.com"}
function serviceLink(a,c,b){var d="https://translate.google.com/";a&&(c=isLanguage(c)?codeFromLanguage(c):"auto",b=isLanguage(b)?codeFromLanguage(b):"auto",d+=format("#{0}/{1}/{2}",c,b,encodeGetParam(a)));return d}
SupportedLanguages=[-1,"","af","az","sq","ar","hy","eu","be","bg","ca","zh-CN","zh-TW","hr","cs","da","nl","en","et","fi","tl","fr","gl","de","el","ht","iw","hi","hu","is","id","it","ga","ja","ka","ko","lv","lt","mk","ms","mt","no","fa","pl","pt","ro","ru","sr","sk","sl","es","sw","sv","th","tr","uk","ur","vi","cy","yi","eo","hmn","la","lo"];function serviceDetectLanguageRequest(a){a=format("/translate_a/t?client=p&text={0}&sl=auto",encodeGetParam(a));return new RequestData(HttpMethod.GET,a)}
function serviceDetectLanguageResponse(a){eval("var res = "+a);return getSourceLanguage(res)}function serviceTranslateRequest(a,c,b){a=encodeUriParam(a);var d=a.length>Const.URI_MAX_LEN?HttpMethod.POST:HttpMethod.GET;c=format("/translate_a/t?client=p{0}&sl={1}&tl={2}&hl={3}",d==HttpMethod.POST?"":"&text="+a,codeFromLanguage(c),codeFromLanguage(b),Options.LanguageCode);return new RequestData(d,c,d==HttpMethod.POST?"text="+a:null)}
function serviceTranslateResponse(a,c,b,d){eval("var res = "+c);c=a="";if(res){if(res.sentences)for(b=0;b<res.sentences.length;b++){var e=res.sentences[b];a+=e.trans;c+=e.translit}if(res.dict)for(b=0;b<res.dict.length;b++)if(e=res.dict[b],e.pos){a+=Const.NL;a+=Const.NL;a+=e.pos+":";for(var h=0;h<e.entry.length;h++){var f=e.entry[h];a+=Const.NL;a+="\t";a+=f.word;if(f=f.reverse_translation){a+=" (";for(var g=0;g<f.length;g++)a+=f[g],g<f.length-1&&(a+=", ");a+=")"}}}b=getSourceLanguage(res)}return new ResponseData(a,
b,d,c)}function getSourceLanguage(a){return a?languageFromCode(a.src):UNKNOWN_LANGUAGE}function serviceListenRequest(a,c){var b=format("/translate_tts?ie=UTF-8&q={0}&tl={1}",encodeGetParam(a),codeFromLanguage(c));return new RequestData(HttpMethod.GET,b)};