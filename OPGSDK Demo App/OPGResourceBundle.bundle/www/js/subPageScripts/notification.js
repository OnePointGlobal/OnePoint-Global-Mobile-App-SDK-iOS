var Notification = {
    
    scroll : null,
    myScroll : null,
    init : function(){
        
        this.styleBody();
        
        this.loadNotifications();
        
        this.bindListners();
        
        utils.IScrollRefresh('#wrapper');
    },
    
    loadNotifications : function(){
        
        
        
        cordovaFunction.fetchPushNotificationList([],
                function(data){
                       if(data.length > 0){
                           $.each(data,function(i, val){
                                  var active = ((val['IsRead']==true)?"Read":"notRead");
                                  if($("ul#thelist li input[data-value="+val['AppNotificationID']+"]").length == 0){
                                                         $("ul#thelist").append("<li class="+active+"><div class='contentDetails'>"+
                                                                                "<div class='ntfDescHeader'><span class='notfTitle title normalfont line-clamp'>"+val['Title']+"</span><span class='notfTime smallfont'>"+platformSpecific.getDiff(val['LastUpdated'])+"</span></div><div class='ntfDesc'>"+
                                                                                "<input type='checkbox'  class='selectDelete' name='deletentf' id='deletentf1' data-value='"+val['AppNotificationID']+"' ><label class='checkNtfDelete' style='display:none'></label>"+
                                                                                "<span class='ntfDescript smallfont line-clamp'>"+val['Body']+"</span></div></div><div class='arrowContainer'><span class='rightArrow'></span></div></li>");
                                   }
                                                         
                            });
                                                  $("ul#thelist li div.arrowContainer").on("click",function(){
                                                           if($(".editNtf").is(":visible")){
                                                                                  var index = $(this).parent().index();
                                                                                 var ntfId = $(this).parent().find($("input[type='checkbox']")).attr("data-value");
                                                                                 var dataToSend = {"notificationID":ntfId};
                                                                                 cordovaFunction.updatePushNotification(dataToSend,function(data){
                                                                                                                        $("ul#thelist li:eq("+index+")").addClass("Read");
                                                                                                                        },function(data){ });
                                                                                 var ntfIndex = $(this).parent().index();
                                                                    if( $("#notificationScroll li").length == 0){
                                                                         $("#notificationScroll").append("<div class='notificationDetails'>"+
                                                                                                        
                                                                                                        "<span class='notificationDetailsTime normalfont'>"+ platformSpecific.getDiff(data[ntfIndex]['LastUpdated'])+"</span>"+
                                                                                                        
                                                                                                        "<span class='notfDescTitle title normalfont'>"+data[ntfIndex]['Title']+"</span>"+
                                                                                                        
                                                                                                        "<div class=normalfont>"+data[ntfIndex]['Body']+"</div></div>");
                                                                        }
                                                                      
                                                                        
                                                                        Notification.openSelectedNotification();
                                                                        
                                                                        Notification.toggleNavigation(true);
                                                                        
                                                                        $("#wrapper").css("margin-left",-$(window).width());
                                                                        
                                                                        $("#notificationScroll").css("margin-left",0);
                                                                        
                                                                        $(".editNtf").hide(); $(".deleteNotify").hide();
                                                                        
                                                                        
                                                                        $("div.ntfsubHeader").addClass("showArrow");
                                                                        
                                                                        }
                                                });
                                                  
                                                  
                                                  
                                                  $("label.checkNtfDelete").on("click",function(e){
                                                                               e.stopPropagation();
                                                                               var attr =  $(this).prev().attr("checked");
                                                                               if(typeof attr !== typeof undefined && attr !== false){
                                                                               $(this).prev().removeAttr("checked");
                                                                               $(this).removeAttr("style");
                                                                               $(this).css({"background-image":'url("././images/check_normal.png")',"width":"28px","height":"28px"});
                                                                               }else{
                                                                               $(this).prev().attr("checked","checked");
                                                                               $(this).removeAttr("style");
                                                                               $(this).css({"background-image":'url("././images/check_selected.png")',"width":"28px","height":"28px"});
                                                                               }
                                                                               
                                                                               
                                                   });
                                                  $(".ntfsubHeader").on("click",function(){
                                                                        $(".editNtf").show();
                                                                        $("#notificationScroll div.notificationDetails").remove();
                                                                        $("#wrapper").css("margin-left",0);
                                                                        $("#notificationScroll").css("margin-left",$(window).width());
                                                                        $(".leftArrow").hide();$(".edit").show();$(".deleteNotify").hide()
                                                                        $("div.ntfsubHeader").removeClass("showArrow")
                                                                          $("div.ntfDescHeader").removeClass("adjustCss");
                                                                         $("#scroller input.selectDelete").removeAttr("checked");
                                                                          $("#scroller input.selectDelete").next().removeAttr("style").hide();
                                                       });
												 Notification.scroll = new iScroll('wrapper');
										          }else{
                                                    $(".editNtf").hide();$("div.ntfsubHeader").css("width","100%");
                                                    $("#wrapper").css("height","auto");
                                                    $(".ntfScroller .ntfNotFound").remove();
                                                    $(".ntfScroller").append("<div class='ntfNotFound largefont'>No notifications were found</div>");
                                                  
                                                  }
                                                  
                                                  },function(data){
                                                  alert("Error occured, Please contact Support.");
                                                  
                                                  });
        
        
        
    },
    
    bindListners : function() {
        
        $(window).on('resize', function() {
                     
                     Notification.styleBody();
               
        });
        
        
        $(".editNtf").on("click",function(){
                         $(this).hide();
                         $(".deleteNotify").show(); $(".cancelNotify").show();
                         $("#scroller input.selectDelete").next().show();
                          $(".ntfsubHeader").addClass("adjustWidth");
                         $("div.ntfDescHeader").addClass("adjustCss");
                         $("span.rightArrow").hide();
                         Notification.scroll.refresh();
                         });
        
        $(".deleteNotify").on("click",function(ev){
                           $(this).hide();
                           ev.stopPropagation();ev.preventDefault();
                           $("span.rightArrow").show();
                           $(".ntfsubHeader").addClass("showDelete");
                           var DleteNtfList = $('input[type="checkbox"][checked="checked"]').map(function(){
                                                                                     return $(this).attr("data-value");
                            }).get();
                              Notification.scroll.refresh();
   
                            if(DleteNtfList.length == 0){
                                  $("span.rightArrow").hide();   $(".deleteNotify").show();
                                 utils.displayAlert("Please select notifications to delete");
                              }else{
                                $("span.rightArrow").hide();
                                cordovaFunction.DeletePushNotification(DleteNtfList,
                                   function(data){
                                                                  utils.displayAlert("Notification deleted Successfully");
                                                                  $.each(DleteNtfList,function(i,index){
                                                                         $("input[data-value="+index+"]").parent().parent().parent().remove();
                                                                         });
                                                                 Notification.scroll.refresh();$(".deleteNotify").hide();
                                                                       $("span.rightArrow").show();$(".cancelNotify").hide();
                                                                       if($("ul#thelist li").length > 0){ $(".editNtf").show();}else{ $(".ntfsubHeader").removeClass("adjustWidth");}
                                                                       $("#scroller input.selectDelete").next().hide();
                                                                       $("div.ntfDescHeader").removeClass("adjustCss");
                                                                 
                                 },function(data){
                                           utils.displayAlert("error occured");
                                 });
                           }
                           
         });
        
        $(".cancelNotify").on("click",function(e){
                              $(this).hide();        $(".deleteNotify").hide();$(".editNtf").show();   $("span.rightArrow").show();
                           $(".checkNtfDelete").hide();
                                $("div.ntfDescHeader").removeClass("adjustCss");Notification.scroll.scrollTo(0,0);
                    Notification.scroll.refresh();
       });
        
    },
    
    styleBody : function () {
        
        var height = $('.body_container').outerHeight();
        
        $('#wrapper').css('height',height-40);
        
    },
    
    openSelectedNotification : function(){
        
        $(".ntfList").hide();
        
        $(".notificationScroll").show();
        
        
    },
    
    toggleNavigation : function(toggleOption){
        
        if($('#wrapper').css('margin-left') == '0px'){
            
            if($(window).width() <= 480)
                
                $('#ntfList').animate({"margin-left" : "-480px"}, { duration: "slow"});
            
            else
                
                $('#ntfList').animate({"margin-left" : "-520px"}, { duration: "slow"});
            
            $('.addSneezeGuard').hide();
            
        }else if(toggleOption){
            
            $('#ntfList').animate({"margin-left" : "0px"}, { duration: "slow"});
            
        }
        
    },
    
};



$(function() {
  
  Notification.init();
  
  });


