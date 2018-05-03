//# sourceURL=survey.js
var Survey = {
	scroll : null,
    geoImageTags : '',
    disableSurvey : '',
    geoSurveyList : [],
    alertPopup : true,
	surveyResponse : [],
	surveyList : [],
	postSurveyList : [],
	surveyType : {
		1 : "new",
		2 : "existing",
		3 : "incomplete",
		4 : "complete"
	},
	pullDownOffset : 0,
	fullWindow : null,
	listLength : [ 0, 0, 0, 0 ],
	surveyLength : 0,
	pullRefresh : false,
	showPostOffline : false,
	init : function() {
        
       
		//append survey list to dom
		Survey.getSurveys();
		//results upload option
        Survey.uploadOfflineSurveyList();
        //add dom events for survey
        Survey.bindListners();
    	Survey.ScrollList();
        //$(".body_container").removeAttr("style");
   
	},
    uploadOfflineSurveyList : function(){
        cordovaFunction.getData("OfflineSurveyResultsList", function(data) {
                                results = data.value;
                                if(results.length >= 1){
                                   //$(".surveyUploadCount").html(sum);
                                var sum=0;
                                //var count_val=parseFloat($('.count_list').text());
                                    $.each(results,function(i,value){
                                           var text= languageScript.translate('surveys');
                                           if(value['SurveyCount'] == 1){
                                              text= languageScript.translate('survey');
                                           }
                                           sum += parseFloat(value['SurveyCount']);

                                       $("#surveyHeader li .custom-select ul").append("<li class='normalfont resultList'><label for="+value['id']+" class='normalfont'><input type='checkbox' name="+value['id']+" id="+value['id']+" class='checkbox' /><span class='name_align'>"+value['Name']+"</span><p class='totalcount'><span class='count_list'>"+value['SurveyCount']+"</span><span class='count_label'>&nbsp;"+text+"</span></label></li>");
                                       });
                                $(".surveyUploadCount").html(sum);
                                
                                }else if(results.length == 0){
                                        $("#surveyHeader").find(".custom-select").hide();
                                        $("#surveyHeader").find(" span:nth-child(3)").text("0");
                                        $("#surveyHeader").find("span:nth-child(2)").text(languageScript.languageFile['All_Surveys_Uploaded_Successfully']);
                                                                     
                                }
                                $('input#upload_all').on('change',function(e) {
                                         $('.checkbox').prop('checked', $(this).prop('checked'));
                                });
                                
                                $('.checkbox').on('change',function(e) {
                                                  e.stopPropagation();
                                                  var checklen=$('.checkbox:checked').length;
                                                  var checkbox=$('.checkbox').length;
                                                  if (checklen == checkbox ) {
                                                    $('input#upload_all').prop('checked', true);
                                                  }else{
                                                    $('input#upload_all').prop('checked', false);
                                                  }
                               });
                           }, function(data) {
                                $("#uploadSuccessTxt").hide();
                                $("#surveyUploadCount").hide(); //console.log("No surveys To upload Fetched");
                         });
        
    },
	bindListners : function() {
	$('#surveyHeader li').click(function(e) {
				$('.surveyListDiv').show();
				$('.surveyListDiv ul').hide();
				$(".surveyListDiv ." + $(this).attr('data-attr')).show();
				$('#surveyHeader li').removeClass('active');
				$('#surveyHeader li').css('border-left','none');
				$(this).addClass('active');
				$(this).next().css('border-left','2px solid #D0DADC');
				Survey.scroll.refresh();
				if(!$('#pullDown').hasClass('loading'))
					Survey.scroll.scrollTo(0,-Survey.pullDownOffset);
			});
	
      
     
     
		$('#surveyHeader li  .surveyUploadCount').on('click',function(e){
             e.stopPropagation();
             if($(this).parent().find('.custom-select ul li').length > 0){
                       $(this).parent().find('.custom-select').toggle();
             }
		});
        $(document).on('click',function(e) {
                       if($('.pageHeader').has(e.target).length > 0 && $('.custom-select ul li').length >0 && ($(e.target).hasClass('pageName') == false) || ($(e.target).hasClass('checkbox') == true)){
                             $('.custom-select').show();
                       }else{
                            $('.custom-select').hide();
                       }
                       
                       });
        $('#surveyHeader li .custom-select div#uplaodNow').on('click',function(e){
                                                              e.stopPropagation();
                                                              var uploadSurveyArray = [];var uploadAll = false;
                                                              $('#surveyHeader li .custom-select li label input[type="checkbox"]:checked').each(function(i, val){
                                                                     if($('input#upload_all').is(':checked')){
                                                                                uploadAll = true;// return false;
                                                                     }else{
                                                                                uploadAll = false;
                                                                     }
                                                                        uploadSurveyArray.push($(val).attr('name'));
                                                             });
                                                              if(uploadSurveyArray.length > 0){
                                                              var dataToSend = {'uploadAll':uploadAll,'surveyUploadArray':uploadSurveyArray} ;
                                                              cordovaFunction.uploadOfflineResults(dataToSend,function(data){
                                                                                                   
                                                                                                   if(uploadAll == true){
                                                                                                   $('#surveyHeader').find('.custom-select').hide();
                                                                                                   $('#surveyHeader').find(' span:nth-child(3)').text('0');
                                                                                                   $('#surveyHeader').find('span:nth-child(2)').text(languageScript.languageFile['All_Surveys_Uploaded_Successfully']);
                                                                                                   $('#surveyHeader  li.active .custom-select > ul li').remove();
                                                                                                   uploadSurveyArray = [];
                                                                                                   }else{
                                                                                                   $('#surveyHeader').find('.custom-select').hide();
                                                                                                   $('#surveyHeader  li.active .custom-select > ul li').remove();
                                                                                                   //$('#surveyHeader').find('span:nth-child(2)').text(data.uploadedSurveyCount+' '+languageScript.languageFile['Surveys_Uploaded_Successfully']);
                                                                        $('#surveyHeader').find('span:nth-child(2)').text(languageScript.languageFile['Surveys_Uploaded_Successfully']);
                                                                                                   Survey.uploadOfflineSurveyList();
                                                                                                   }
                                                                                                   },function(error){
                                                                                                   utils.displayAlert(error);
                                                                                                   //alert(error);
                                                                                                   });
                                                              }else{
                                                                  utils.displayAlert(languageScript.languageFile['Select_Any_one_Survey_To_Upload']);
                                                              }
                                                              //$(this).parent().hide();
         });
        
        
      	$('.backButton').on('click', function(e) {
            $('div.upgradeNotify').show();
           // $('.surveyListDiv').height($('.surveyListDiv').height()+$('#refershNotify").height()+10) ;
   			Survey.goToSurveyList($(this));
                            app.popUpStatus = true;
                            app.geofencingPopToggle();
                            
		});

        $('body').on('click', '.takeSurvey', function(e) {
                    e.stopImmediatePropagation();
                     if($(this).parent().parent().attr("id") != "surveyBgDisable"){
                            $('div.upgradeNotify').hide();
                            Survey.setSelectedSurveys($(this).attr('data-attr'));
                     }
                     else{
                     
                     navigator.notification.alert(
                                                  languageScript.translate('AlertSorryMsg'),
                                                  function(){},
                                                  languageScript.translate('sorry'),
                                                  languageScript.translate('close'));
                     
                     }
		});
		
		$('.submitButton').on('click',function(e){
			e.stopImmediatePropagation();
				var id = $(this).attr('data-id');
				var callbackPage = "applicationPage.html";
				cordovaFunction.storeData("surveyID", id, function(data) {}, function(data) {});
				var dataToSend = {"surveyID":id,"panelID":utils.panelID, "callbackPage":callbackPage};
				if($(this).hasClass('offline')){
					var surveyToBeUploaded = $(this).data("offlineSurveyName");
					var dataToSend = {"surveyID":id,"panelID":utils.panelID,"surveyName":surveyToBeUploaded, "callbackPage":callbackPage};
					
					                $('.bodyWrapper').show();
					cordovaFunction.startofflineSurvey(dataToSend,function(data){
						window.open(data);
					},Survey.displayError);
				}
				else if (platformSpecific.checkConnection() == Connection.NONE) {
					Survey.displayError(languageScript.translate('networkError'));
					return false;
				}else{
					cordovaFunction.startOnlineSurvey(dataToSend,function(data){
                                                      
						var ref = window.open(data.url);
						$('.bodyWrapper').show();
                                                      
                                                      
					},Survey.displayError);
                              
				}		 
			
		});

		$(window).on('resize',function() {
                        Survey.scroll.refresh();
			Survey.styleBody();
		});

	},
	goToSurveyList : function(elm){
		$('.selectedSurveywrapo').hide();
		var type = Survey.surveyType[elm.attr('type-attr')];
		$('#surveyHeader').show();
		$('#surveyHeader li[data-attr =incomplete]').addClass('active');
		$('#surveyHeader li[data-attr =incomplete]').next().css('border-left','2px solid #D0DADC');			
		if(window.innerWidth > 480)
            $('.body_container').addClass('surveyBorder');
		$('.surveyListDiv').show();
		$('.surveyListDiv ul').hide();
		$(".surveyListDiv .incomplete").show();
       
        
	},
    
	handleListType : function() {
		//toggle the survey tab
		Survey.surveyLength = 0;
		$.each(Survey.listLength, function(key, value) {
			if (value != 0) {
				$('#surveyHeader li:nth-child(' + (key + 1) + ')').attr(
					'data-index', Survey.surveyLength);
				$('#surveyHeader li:nth-child(' + (key + 1) + ') .surveyCount').text(value);
                $('#surveyHeader li:nth-child(' + (key + 1) + ')').css("display","table");
				$('#surveyHeader li:nth-child(' + (key + 1) + ')').show();
				Survey.surveyLength++;
			}
		});
		if (Survey.surveyLength == 0)
			return;
		$('.surveyListDiv ul').hide();
		var index = $('#surveyHeader li[data-index = 0]').index();
       
		$('.surveyListDiv ul.incomplete').show(); 
		$('#surveyHeader li').css('border-left','none');
		$('#surveyHeader li[data-attr = incomplete]').addClass('active');	
	},
	
	setSelectedSurveys : function(surveyId) {
		//set the selected survey details
		var list;
		for (var i = 0; i < Survey.surveyList.length; i++) {
	        if (Survey.surveyList[i].SurveyID == surveyId) {
                
	        	list = Survey.surveyList[i];
                $('#refershNotify').hide();
	        	$('.submitButton').attr('data-id',list.SurveyID);
	    		$('.surveyListDiv,#surveyHeader').hide();
	    		$('.launchedTime').text(list.timeElapsed);
	    		$('.surveyAvailabity').text(list.IsOffline+" "+languageScript.translate('survey'));
	    		$('.surveyText').text(Survey.surveyList[i].Description);
	    		$('.deadline').text(list.deadline);
	    		$('.estimatedTime').text(list.estimatedTime);
	    		$('.occurance').text(list.occurance);
	    		$('.submitButton').removeClass('offline');
                if(Survey.surveyList[i].offlineSurvey == true){
		        	$('.submitButton').addClass('offline');
                    $('.submitButton').data("offlineSurveyName",list.Name);
                }
                if(Survey.surveyList[i].Geofence==1){
                    $('ul.otherDetails li:nth-child(1)').css("display","block");
                }
                else $('ul.otherDetails li:nth-child(1)').css("display","none");
	    		$('.backButton').attr('type-attr',list.Type);
	    		$('.surveyImagewrapo').css("background","url('"+themeScript.theme["surveyDetail"]+"') no-repeat transparent");
	    		$('.surveyImagewrapo').css("background-size","cover");
	        }
            
	    }	
		$('.body_container').removeClass('surveyBorder');
		$('.selectedSurveywrapo').show();
		utils.styleBody();
		Survey.styleBody();
		utils.IScrollRefresh('.selectedSurveyScroll');
	},
	getSurveys : function() {
		//utils.panelID = null;
		var dataToSend = {"panelID" : utils.panelID};
		if(utils.panelID)
			cordovaFunction.getSurveyList(dataToSend,Survey.setSurveyList,Survey.displayError);
		else /*$.ajax({
				dataType: "json",
				url: 'data/survey.json',
				success: function(json) {
					Survey.setSurveyList(json);
				},
			    //JSON error
			    error : function(err){
			    	console.log('Error in getting data : '+err);
			    }
			});*/
            
		Survey.setSurveyList(null);
	},
	/*downloadImage : function(index) {
		var imageDataToSend = {
			"mediaType" : "Image",
			"mediaID" : Survey.surveyList[index].mediaID
		};
		var indexFunc = function(){
			index++;
			if (index == Survey.surveyList.length) {
				Survey.displayList();
			}else{
				Survey.downloadImage(index);
			}
		};
		if(Survey.surveyList[index].MediaIDSpecified == true && Survey.surveyList[index].mediaID > 1){
			cordovaFunction.downloadImage(imageDataToSend, function(data) {
				Survey.surveyList[index].imgSrc = data.path;
				indexFunc();
			}, function(data) {
				Survey.surveyList[index].imgSrc = "images/surveydefault.png";
				indexFunc();
			});
		}else{
			Survey.surveyList[index].imgSrc = "images/surveydefault.png";
			indexFunc();
		}
	},*/
    setSurveyList : function(data) {
        
        if(!data || data.length == 0){
            Survey.completeDisplayList();
            return;
        }
        Survey.surveyResponse = data.Surveys;
        Survey.surveyList = [];
        Survey.listLength = [ 0, 0, 0, 0 ];
        
        Survey.surveyResponse.forEach(function(obj, index) {
                                      
                                      if(obj){
                                      var surveyDetails = {};
                                      surveyDetails.Type = obj.Type;
                                      surveyDetails.SurveyID = obj.SurveyID;
                                      surveyDetails.Name = obj.Name;
                                      surveyDetails.timeElapsed = platformSpecific.formatSurveyDate(obj.CreatedDate);
                                      surveyDetails.CreatedDate = obj.CreatedDate;
                                      surveyDetails.mediaID = obj.MediaID;
                                      surveyDetails.imgSrc = themeScript.theme["surveyThumb"];
                                      surveyDetails.Description = obj.Description;
                                      surveyDetails.Geofence = obj.IsGeofencing;
                                      surveyDetails.offlineSurvey = (obj.IsOffline)? true : false;
                                      surveyDetails.IsOffline = (obj.IsOffline)?languageScript.translate('offlineStatus'):languageScript.translate('onlineStatus');
                                      surveyDetails.MediaIDSpecified = obj.MediaIDSpecified;
                                      surveyDetails.estimatedTime = obj.EstimatedTime + " " + languageScript.translate('minutes');
                                      surveyDetails.occurance = obj.Occurences + " " + languageScript.translate('times');;
                                      surveyDetails.deadline = ""; //platformSpecific.getDiff(obj.DeadLine, true);
                                      Survey.listLength[surveyDetails.Type - 1]++;
                                      Survey.surveyList.push(surveyDetails);
                                      console.log(Survey.surveyList); 
                                      
                                      }
                                      
                                      });
        //Survey.downloadImage(0);
        /*for(i=0;i<Survey.surveyList.length;i++){
         if(Survey.surveyList[i].offlineSurvey == false)
         console.log("ITS DONE");
         }*/
        $('#surveyHeader,#refershNotify,.pullDownLabel').show();
        Survey.displayList();
        
        if(localStorage.getItem('popupsurveyid') && app.surveyIdlist){
            
            Survey.setSelectedSurveys(localStorage.getItem('popupsurveyid'));
            app.surveyIdlist = false;
       }
        
    },
	displayList : function(){
		$(".surveyListDiv ul").empty();
        //alert(JSON.stringify(Survey.surveyList));
        
         Survey.surveyList.forEach(function(obj, index) {
                                  //alert(Survey.offStatus);
                                  if(app.offStatus == 'off'){
                                    if(obj.Geofence==1){
                                        Survey.geoImageTags = "<div class='geoImage'><img src='images/geofence.png' ></div>";
                                        Survey.disableSurvey = 'surveyBgDisable';
                                   
                                    }
                                  
                                    else{
                                        Survey.geoImageTags = "";
                                        Survey.disableSurvey = '';
                                     }
                                  }
                                  else{
                                    if(obj.Geofence==1){
                                        Survey.geoImageTags = "<div class='geoImage'><img src='images/geofence.png' ></div>";
                                        Survey.disableSurvey = 'surveyBgDisable';
                                         $(".takeSurvey").attr("disabled", true).off('click');
                                    }
                                  
                                    else{
                                        Survey.geoImageTags = "";
                                        Survey.disableSurvey = '';
                                   
                                  }
                                }
             //alert( Survey.disableSurvey );
                                  
                                  
			$(".surveyListDiv .incomplete").append("<li id='"+Survey.disableSurvey+"'><div class='listWrapper'><div class=imgWrapo><div class='timeElapsed smallfont' data-time='"
				+ obj.CreatedDate
				+ "'>"
				+ obj.timeElapsed
				+ "</div><img alt='surveyimages' src='"+ obj.imgSrc
				+ "' /></div><div class=surverDetailsWrapo><div class='surveyName normalfont'>"
				+ obj.Name
				+ "</div><div class='surveyDescription smallfont'><span>"
				+ obj.Description
				+ "</span></div><div class='timeElapsed smallfont' data-time='"
				+ obj.CreatedDate
				+ "'>"
				+ obj.timeElapsed
				+ "</div>"+Survey.geoImageTags+"</div><div class='takeSurvey' data-attr = '"
				+ obj.SurveyID
				+ "'><div class='extrasmallfont'>"
				+ languageScript.translate('takeSurvey')
				+ "</div></div></div></li>");
					$('.bodyWrapper').hide();
		$('.addSneezeGuard').hide();
			var p=$('.surveyDescription span');
			var divh=$('.surveyDescription').height();
			while ($('.surveyDescription span').outerHeight()>divh) {
			    $('.surveyDescription span').text(function (index, text) {
			        return text.replace(/\W*\s(\S)*$/, '...');
			    });
			}
			setInterval(function() {
				$('.surveyListDiv').find('.timeElapsed').each(function() {
					var createdDate = $(this).attr('data-time');
					$(this).html(platformSpecific.getDiff(createdDate));
				});
			}, 60000);   
                                  if(app.offStatus == 'on'){
                              
                                  cordovaFunction.loadGeoFencingLocations([], function(locations){
                                                                          //geofencingObj.trackingLoc =locations;
                                                                          
                                                                          Survey.geoSurveyList = locations.SurveyIDs;
                                                                          //console.log(Survey.geoSurveyList);
                                                                          for(var i=0;i<Survey.geoSurveyList.length;i++){
                                                                          //alert(obj.SurveyID);
                                                                          //alert(i);
                                                                          //alert(Survey.geoSurveyList[i]);
                                                                          
                                                                          if(obj.SurveyID==Survey.geoSurveyList[i]){
                                                                               $(".takeSurvey[data-attr='"+obj.SurveyID+"']").parent().parent().removeAttr("id");
                                                                            }
                                                                          }
                                                                          
                                                                          }, function(error){
                                                                          alert(error);
                                                                          });
                                   }
                                  
		});
        
		Survey.completeDisplayList();
	},
	completeDisplayList : function(){
		Survey.handleListType();
		utils.styleBody();
		Survey.styleBody();
        Survey.scroll.refresh();
		if(Survey.pullRefresh)
			Survey.scroll.refresh();
        if(window.innerWidth > 480)
            $('.body_container').addClass('surveyBorder');
		if(utils.surveyID != 0){
			//Survey.setSelectedSurveys(utils.surveyID);
			utils.surveyID = 0;
		}
	},
	displayError : function(data){
		utils.displayAlert(data);
	},
	styleBody : function() {
		if (Survey.surveyLength == 0) {
			$('.noData').show();
			$(".surveyListDiv ul").empty(); 
		} else {
			$('.noData').hide();
			$('.scroller').show();
			//if(Survey.surveyLength != 4)
			//	$('#surveyHeader li').css({width : 100 / Survey.surveyLength + '%'});
		}
	},
	ScrollList : function() {
		try {
			
			//to enable scrolling in less content too
			var wrapperH = $('.surveyListDiv').height();
			var scrollerH = $('.surveyListDiv .scroller').height();
			if(scrollerH < wrapperH)
				$('.surveyListDiv .scroller').css('min-height',wrapperH);	
			
			var pullDownEl = document.getElementById('pullDown');
			pullDownOffset = pullDownEl.offsetHeight;
			
			Survey.scroll = new iScroll('listwrapper', {
				useTransition: true,
				topOffset: pullDownOffset,
				onRefresh: function () {
           			if (pullDownEl.className.match('loading')) {
                     	pullDownEl.className = '';
						pullDownEl.querySelector('.pullDownLabel').innerHTML = languageScript.translate('pullToRefresh');
					}
				},
				onScrollMove: function () {
                        pullDownEl.style.display = "block";
					if (this.y > 80 && !pullDownEl.className.match('flip')) {
                        pullDownEl.className = 'flip';
						pullDownEl.querySelector('.pullDownLabel').innerHTML = languageScript.translate('Releasetorefresh');
						this.minScrollY = 0;
					} else if (this.y < 80 && pullDownEl.className.match('flip')) {
                      	pullDownEl.className = '';
						pullDownEl.querySelector('.pullDownLabel').innerHTML = languageScript.translate('pullToRefresh');
						this.minScrollY = -pullDownOffset;
					} 
				},
				onScrollEnd: function () {
                        pullDownEl.style.display = "block";
					if (pullDownEl.className.match('flip')) {
						pullDownEl.className = 'loading';
						pullDownEl.querySelector('.pullDownLabel').innerHTML = languageScript.translate('Loading...');				
						cordovaFunction.checkForUpdate([],function(data){
							Survey.pullRefresh = true;
							Survey.getSurveys();
							utils.panelUpdate();
							applicationPage.loadpage('survey', 'appPage');
						},function(data){
                            pullDownEl.className = '';
                            pullDownEl.querySelector('.pullDownLabel').innerHTML = languageScript.translate('pullToRefresh');
  							utils.displayAlert(data);
                            pullDownEl.style.display = "none";
						});
					}
				}
			});
			setTimeout(function () { document.getElementById('listwrapper').style.left = '0'; }, 800);
	
		} catch (e) {
		}
	},
};

$(function() {
	"use strict";
	Survey.init();
});
