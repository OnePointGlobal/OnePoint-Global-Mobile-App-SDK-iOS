var languageScript = {
	phoneLanguage : "default",
	languageFile : {},
	callback : null,
	localize : function(){
		var langJson = languageScript.languageFile;
		// apply localisation to the span elements
		$('span').each(function(){
			
			var langAttr = $(this).attr('data-lang');
			if(langAttr){
				$(this).html(langJson[langAttr]);
			}
		});
		
		// apply localisation to placeholders of input boxes
		$('input').each(function(){
			var langAttr = $(this).attr('data-lang');
			if(langAttr){
				$(this).attr('placeholder',langJson[langAttr]);
			}
		});

		// apply localisation to the select boxes
		$('select').each(function(){
			var langAttr = $(this).attr('data-lang');
			var langOption;
			if(langAttr){
				// apply localisation to placeholders of select boxes
				$(this).find('option:first').text(langJson[langAttr]);
				// apply localisation to placeholders of select boxes options
				$(this).children("option").each(function() {
					langOption = this.value;
				    $(this).text(langJson[langAttr+"Opt"+langOption]);
				});
			}
		});
		if(languageScript.callback)
			languageScript.callback();
	},
	translate : function(elm){
		return languageScript.languageFile[elm];
	},
	// apply mobile preferred language to the application
	applyLocalization : function(callback) {
		this.callback = callback;
		if(jQuery.isEmptyObject(this.languageFile))
			languageScript.getLanguage();
		else this.localize();
	},
	// get phone language on app start
	getLanguage : function() {
		platformSpecific.checkLocale(languageScript.checkLanguageFile);
	},
	checkLanguageFile : function(data){
	
			languageScript.phoneLanguage = data;
			if (!languageScript.phoneLanguage) {
				languageScript.phoneLanguage = 'default';
			}
			// get address of language resource file
			var languageURL = 'data/language_' +languageScript.phoneLanguage
					+ '.json';
			languageScript.checkIndex(languageURL).fail(function() {
				languageScript.phoneLanguage = 'default';
				languageScript.getLanguageFile();
			}).done(function(){
				languageScript.getLanguageFile();
			});
		
	},
	getLanguageFile : function() {
		// get address of language resource file
		var languageURL = 'data/language_' + languageScript.phoneLanguage + '.json';
		$.ajax({
			dataType : "json",
			url : languageURL,
			success : function(json) {
				languageScript.languageFile = json;
				languageScript.localize();
			},
			// JSON error
			error : function(err) {
				console.log('Error in getting language file : ' + JSON.stringify(err));
			}
		});
	},
	// check if content file exists
	checkIndex : function(file) {
		return $.ajax({
			url : file,
			type : 'Head'
		});
	}
};