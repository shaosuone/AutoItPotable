function serviceHeader(){return new ServiceHeader(19,"WordReference",'<a href="http://wordreference.com/">http://wordreference.com/</a>'+Const.NL+"Copyright \u00a9 2013 WordReference.com. All rights reserved.",Capability.DICTIONARY)}function serviceHost(b,a,c){return"wordreference.com"}function serviceLink(b,a,c){return"http://www.wordreference.com/"}
SupportedLanguages=[-1,"",-1,-1,-1,"ar",-1,-1,-1,-1,-1,"zh","zh",-1,"cz",-1,-1,"en",-1,-1,-1,"fr",-1,"de","gr",-1,-1,-1,-1,-1,-1,"it",-1,"ja",-1,"ko",-1,-1,-1,-1,-1,-1,-1,"pl","pt","ro","ru",-1,-1,-1,"es",-1,-1,-1,"tr",-1,-1,-1,-1,-1,-1,-1,-1,-1];function serviceDictionaryRequest(b,a,c){b=buildUri(b,a,c);return new RequestData(HttpMethod.GET,b)}
function serviceDictionaryResponse(b,a,c,e){var d;if(a=midString(a,'<div id="article">','<div id="postArticle">',!1))a=removeAttributes("<div>"+a,["id","name","class","onclick"]),d=serviceHost(Capability.DICTIONARY,c,e),a=updateHtmlLinks(a,d),b=buildUri(b,c,e),d="http://"+d+b;return new ResponseData(a,c,e,d)}function buildUri(b,a,c){return format("/{0}{1}/{2}",codeFromLanguage(a),codeFromLanguage(c),encodeGetParam(b))};