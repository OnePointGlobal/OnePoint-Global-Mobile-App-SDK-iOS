// if DOM loaded, proceed to bind the Cordova's deviceready event
$(function() {
	app.init('applicationPage');
	//applicationPage.init();
});

var applicationPage = {
	old_url : "",
	navscroll : null,
    postSurveyList : [],
	dragging : false,
    scriptAdd : "",
    surveyJsOnce : 'js/subPageScripts/survey.js',
    loadedArray : [],
    //len : null,
	// Application Constructor
	init : function() {
		var initFunc = function() {
			applicationPage.bindEvents();
			applicationPage.initializePage();
			utils.styleBody();
            $('.pageWrapper').css('opacity', '1');
			if (!isMobile.iOS() && window.innerHeight < 460)
				applicationPage.initializeNavScroll();
		};
      	languageScript.applyLocalization(function(){utils.appstatus(initFunc)});
	},
	// Bind Event Listeners
	bindEvents : function() {
      		$('.menuButton').on('click', function(e) {
            applicationPage.toggleNavigation(true);
                                var ntfCount = 0;
                                cordovaFunction.fetchPushNotificationList([],
                                            function(data){
                                                   if(data.length == 0){
                                                            $("li.setNotification .notificationCount").remove();
                                                   }else{
                                                             $.each(data,function(i, val){
                                                                //alert(val['IsRead']);
                                                                if(val['IsRead'] == false || val['IsRead'] == 0){
                                                                    ++ntfCount ;
                                                                 }
                                                              });
                                                                          
                                                              $("li.setNotification .notificationCount").remove();
                                                                          if(ntfCount > 0){
                                                                                      $("li.setNotification").append("<span class='notificationCount'>"+ntfCount+"</span>");
                                                                          }
                                                    }
                                 },function(data){});
			e.stopPropagation();
		});

		$(".navigation li").on('click',function(e) {
            e.stopPropagation();
                               
			if(applicationPage.dragging == true)
				return;
			var pageName = $(this).attr("data-attr");
                               if(pageName != "signout"){
                               app.popUpStatus = true;
                               app.geofencingPopToggle();
                               }
			//for the separation list item
			if(pageName == null)
				return;
			//to signout
			else if(pageName == "signout"){
                applicationPage.toggleNavigation();
                utils.signOut();
			}
			//if page has class link, load content fron recruitment app website
			else if($(this).hasClass('links'))
				applicationPage.loadpage(pageName,'link');
			//else for others, load pages from local
			else applicationPage.loadpage($(this).attr("data-attr"),'appPage');
		});
		
	/*	$('#notificationPage').on('click', function(e) {
			$(".notification_bubble").hide();
			$('.addSneezeGuard').hide();
			applicationPage.loadpage('notification','appPage');
			e.stopPropagation();
		});*/
		
		$(".notification").on('click', function(e) {
			if($('.notification_bubble').is(':visible')) 
				$('.notification_bubble').slideUp(100);
			else {
				$('.addSneezeGuard').show();
				$('.notification_bubble').slideDown(100);
			}
			e.stopPropagation();
		});
		
		$('body').on('click',function(e){
			var $target = $(e.target);
			/*if(!$target.is(".notification_bubble") && !$target.parents().is(".notification_bubble") && !$target.is(".notification")) 
					if($('.notification_bubble').is(':visible')){
						$(".notification_bubble").slideUp(100);
						$('.addSneezeGuard').hide();
						e.stopPropagation();
			}*/
			if(!$target.is(".navigation") && !$target.parents().is(".navigation") && $('.pageWrapper').css('margin-left') == '0px'){
		      applicationPage.toggleNavigation(false);
		      e.stopPropagation();
			}
			if(!$target.is('input') && $('input').is(':focus') && !utils.dragging)
				$('input:focus').blur();
        });

		$(window).on('resize', function() {
			utils.styleBody();
			if(!isMobile.iOS() && window.innerHeight < 460)
				applicationPage.initializeNavScroll();
		});
		
		$('img').on('dragstart', function(event) { event.preventDefault(); });
        
        $('body').on('touchmove','iframe',function(event){
            event.preventDefault();
        });

	},
	toggleNavigation : function(toggleOption){		
		if($('.pageWrapper').css('margin-left') == '0px'){
            if($(window).width() <= 480){
				$('.pageWrapper').animate({"margin-left" : "-240px"}, { duration: "fast"});
            }
            else{
				$('.pageWrapper').animate({"margin-left" : "-290px"}, { duration: "fast"});
            }
			$('.addSneezeGuard').hide();
		}else if(toggleOption){
            
			$('.addSneezeGuard').show();
			$('.pageWrapper').animate({"margin-left" : "0px"}, { duration: "fast"});
		}
	},
	//set language file and proceed with next step
	initializePage : function() {
        
     applicationPage.getSurveyID('surveyID', function(data) {
			utils.surveyID = data;
            if (utils.surveyID == 0){
                   applicationPage.loadpage('splashScreen', 'appPage');
            }else{
				applicationPage.loadpage('survey', 'appPage');
                                 //alert("its comig");
                                 app.popUpStatus = true;
                                 app.geofencingPopToggle();
            }
                                 
                                
                                 
                                 
                             
		});
       
	},
	// load selected page in the body container
	loadpage : function(url,type) {
		applicationPage.toggleNavigation(false);
		$('.navigation li[data-attr=' + applicationPage.old_url + ']').removeClass("active");
		$('.navigation li[data-attr=' + url + ']').addClass("active");
		applicationPage.old_url = url;
		$('.body_container').empty();
       
        if(type == "link")
        {
            $('.body_container').css({"overflow-y":"scroll","-webkit-overflow-scrolling":"touch"});
            navigator.globalization.getLocaleName(function(loc) {
                                                  //console.log("Locale fetched: " + loc.value);
                                                  var locale = loc.value.replace("_", "-");
                                                  if(locale == "pt"){
                                                  locale = "pt-BR";
                                                  }
                                                  if(locale.indexOf("en") != -1){
                                                  locale = "en-US";
                                                  }
                                                  var link = 'http://framework.onepointglobal.com/appwebsite/' + url + '?location=mobile&culture='+locale;
                                                  
                                                  $(".bodyWrapper").show();
                                                  try {
                                                  if (platformSpecific.checkConnection() != Connection.NONE) {
                                                  var iFramesSupported = true;
                                                  var e = document.createElement("iframe");
                                                  if(!e)
                                                  iFramesSupported = false;
                                                  if(!iFramesSupported)
                                                  window.open(link,'_blank','location=no');
                                                  else{
                                                  $('iframe').css('height',$(".body_container").height());
                                                  $(".body_container").html('<iframe src="'+link+'" onload="applicationPage.hideWrapper()"><p>Your browser does not support iframes.</p></iframe>');
                                                  
                                                  $('iframe').css('height',$(".body_container").height());
                                                  }
                                                  } else {
                                                  $('.bodyWrapper').hide();
                                                  utils.displayAlert(languageScript.translate('networkError'));
                                                  }
                                                  } catch (err) {
                                                  $('.bodyWrapper').hide();
                                                  utils.displayAlert(languageScript.translate('genericError'));
                                                  }
                                                  }, function(err) {						
                                                  //console.log("Check locale Error: " + err);
                                                  });
            
        }
		else if(type == "appPage")
		{
            $(".body_container").removeAttr("style");
			var file_url = 'content/' + url + '.html';
			var js_url = 'js/subPageScripts/' + url + '.js';
			applicationPage.checkIndex(file_url).done(function() {
				$(window).off('resize');
				$(window).on('resize', function() {
					utils.styleBody();
				});
				$('.body_container').removeClass('surveyBorder');
				$('.body_container').load(file_url,function(){
                                         $.getScript(js_url).fail(function() {
                                                                           var fileref=document.createElement('script');
                                                                           fileref.setAttribute("type","text/javascript");
                                                                           fileref.setAttribute("src", js_url);
                                                                           document.body.appendChild(fileref);
                                                                           });
                                       
                                          
                                          
//                                          if(url == "notification"){
//                                          applicationPage.notificationPageLoad();
//                                          }
					languageScript.applyLocalization(function(){});
					utils.styleBody();
				});	
			}).fail(function() {
				$('.body_container').html(languageScript.translate('errorPage'));
			});
		}
	},
	hideWrapper : function(){
		$(".bodyWrapper").hide();
        $('iframe').contents().find(".globalLink").on('click', function(event) {
                                                      event.preventDefault();
                                                      var link = $(this).attr("href");
                                                      var dataTosend = {"url":link};
                                                      window.open(link, '_system', 'location=no');
                                                     
         });

	},
	// check if content file exists
	checkIndex : function(file) {
		return $.ajax({
			url : file,
			type : 'Head'
		});
	},
	getSurveyID : function(name,callback) {
		var results = "";
		var returnFunc = function(){
			cordovaFunction.storeData("surveyID", "", function(data) {}, function(data) {});
			callback(results == ""? 0 : parseInt(results));
		};
		cordovaFunction.getData("surveyID", function(data) {
			results = data.value;
			returnFunc();
		}, function(data) {
			returnFunc();
		});
	},
	notificationPageLoad: function(){
        utils.IScrollRefresh('#wrapper');
        $("#notificationScroll").css("margin-left",$(window).width());
        $(".notificationDetails").css("height",$(window).height()-120);

	
	},
    
	initializeNavScroll : function(){
		try {
			if (applicationPage.navscroll)
				applicationPage.navscroll.destroy();
			applicationPage.navscroll = new IScroll('#navigationWrapper', 
					{	hScrollbar : false,
						hScroll : false,
						mouseWheel : true});
			applicationPage.navscroll.on('scrollStart', function () {
						applicationPage.dragging = true;
			        	});
			applicationPage.navscroll.on('scrollEnd',function () {
			                //had to use a timeout here because without it it would fire on links at the end of the drag / dragging slowly
			                setTimeout(function () { 
			                	applicationPage.dragging = false;
			                }, 1000);
			            });
			setTimeout(function() {
				applicationPage.navscroll.refresh();
			}, 500);
			setTimeout(function() {
				applicationPage.navscroll.refresh();
			}, 1000);
		} catch (e) {
		}
	}
};
