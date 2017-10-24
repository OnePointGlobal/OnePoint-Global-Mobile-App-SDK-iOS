var themeScript = {
	themeID : 0,
	theme : {},
    callback : null,
	applyTheme : function(panelData, panelID,callback) {
        this.callback = callback;
		this.createTheme(panelData, panelID);
	},
	insertThemeCss : function(theme) {
		var cssStyle = ".header, .button:active {background-color:"
				+ theme["Header-background"] + "; color:"
				+ theme["Header-front"] + "}";
		cssStyle += ".menuButton div{background-color:" + theme["Header-front"]
				+ "}";

		cssStyle += ".navigation li.active {border-left-color: "
				+ theme["Highlight-color"] + "}";
		cssStyle += " .pageHeader > li.active {color:"
				+ theme["Highlight-color"] + "; border-top-color: "
				+ theme["Highlight-color"] + "}";

		cssStyle += " .button, .notification{ background-color:" + theme["Highlight-color"]
				+ "}";

		cssStyle += " .navigation{background-color:" + theme["Nav-background"]
				+ "}";
		cssStyle += " .navigation li.active{background-color: "
				+ theme["Nav-highlight"] + "}";

		cssStyle += " .navigation {color:" + theme["Nav-color"] + "}";
		cssStyle += " .navPoint{background-color:" + theme["Nav-point"] + "}";
		cssStyle += " .navigation li.links {color:" + theme["Nav-link-color"]
				+ "}";

		cssStyle += " .loggedStatus.online {background-color:"
				+ theme["online"] + "}";
		cssStyle += " .loggedClass {background-color:" + theme["Header-right"]
				+ "}";
		
		cssStyle += ".notification:after{border-color:" + theme["Highlight-color"] + " transparent;}";
		
		cssStyle += ".surveyListDiv li .takeSurvey:before{border-color: " + theme["Highlight-color"] + " " +
						theme["Highlight-color"] + " " + theme["Highlight-color"] + " transparent}";
		
		cssStyle +=  ".surveyListDiv li .takeSurvey div{background-color:"+ theme["Highlight-color"]+"}";
		cssStyle +=  "#surveyHeader li  .surveyUploadCount{background-color:"+ theme["Highlight-color"]+"}";
		cssStyle +=  "ul.postList li#submitPost{background-color:"+ theme["Highlight-color"]+"}";
        	cssStyle +=  "ul.postList li#submitPost{color:#fff}";
		cssStyle += ".submitButton:before{background:" + theme["Highlight-color"] + "}";
		cssStyle += ".submitButton:after{background:" + theme["Highlight-color"] + "}";

		//console.log(cssStyle);
		var style = document.createElement('style');
		style.type = 'text/css';
		style.innerHTML = cssStyle;
		document.getElementsByTagName('head')[0].appendChild(style);

		if(theme["logoMediaID"] != 0 && theme["logoMediaID"]){
			var newsrc = theme["logoMediaID"] + "?" + new Date().getTime();
			$('.clientLogo').html('<img src="'+newsrc+'"/>');
		}else
			$('.clientLogo').text(theme["logoTxt"]);
        
        
        if(theme["surveyThumb"] != 0 && theme["surveyThumb"]){
            var newsurveyThumb = theme["surveyThumb"];
            $('img[alt="surveyimages"]').attr("src",newsurveyThumb);
        }else
            $('img[alt="surveyimages"]').attr("src","images/surveydefault.jpg");
        if(themeScript.callback)
            themeScript.callback();
		
	},
	createTheme : function(panelData, panelID) {

		var templateID = null, theme = {};
		themeScript.headerLogo = null;
		var elements = [ "Header-background", "Header-front", 
				"Highlight-color", "logoMediaID", "logoTxt", "Nav-background",
				"Nav-highlight", "online", "Header-right", "Nav-color",
				"Nav-link-color", "Nav-point", "surveyThumb", "surveyDetail","Splash-html"], 
		values = ["#0A5694", "#ffffff", "#FF6D27", 0, "", 
				"#374760", "#2A3950", "green", "#374760", "#ffffff", "#8994ab",
				"#6a7c98","images/surveydefault.jpg","images/takesurvey.jpg",""];

		panelData.Panels.forEach(function(key, value) {
			if (key.PanelID == panelID)
				templateID = key.ThemeTemplateID;
		});
		//console.log("theme panelID "+ panelID + " templateID "+templateID);
		
		themeScript.themeID = templateID;
		
		if (templateID > 0) {
			panelData.Themes.forEach(function(key, value) {
				panelData["Themes"][value].forEach(function(key1, value1) {
					if (key1.ThemeTemplateID == templateID) {
						if($.inArray( key1.Name,elements) != -1)
							theme[key1.Name] = key1.Value;
					}
				});
			});
		}
		themeScript.downloadImage(theme["logoMediaID"], function(data1) {
			theme["logoMediaID"] = data1;
			themeScript.downloadImage(theme["surveyThumb"], function(data2) {
				theme["surveyThumb"] = data2;
				themeScript.downloadImage(theme["surveyDetail"],function(data3) {
					theme["surveyDetail"] = data3;
					$.each(elements, function(index, value) {
						if (!theme[value])
							theme[value] = values[index];
						});
					themeScript.theme = theme;
					console.log('themedata : '+JSON.stringify(theme));
					themeScript.insertThemeCss(theme);
				});
			});
		});	
	},
	downloadImage : function(mediaID, callback){
		if(!mediaID){
			callback("");
            return;
        }
		var imageDataToSend = {
				"mediaType" : "Image",
				"mediaID" : mediaID
			};
		if(imageDataToSend.mediaID != '' || typeof(imageDataToSend.mediaID) != "undefined" ){
			cordovaFunction.downloadImage(imageDataToSend, function(data) {
				callback(data.path);
                return;
			}, function(data) {
				callback("");
                return;
			});				
		}		
	}
};
