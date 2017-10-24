var btnName = "";
var dataArr = {};


$(document).ready(function(){
                  $("input[type='submit']").attr("data-nav","mrNavButton");
                  $('input[data-nav="mrNavButton"]').click(function(e) {
                                                           btnName = $(this).attr("name");
                                                           sendResults(btnName);
                                                           });
                  
                  });

$(document).keypress(function(e){
                     if($('input[type="text"]').length > 0){
                     if(e.keyCode == 13){
                     e.preventDefault();
                     btnName = "_NNext";
                     document.activeElement.blur();
                     //e.blur();
                     sendResults(btnName);
                     }
                     }
                     });


function sendResults(btnName){
    $('#mrForm').find('input, textarea, select, radio, checkbox').each(function(i, field) {
                                                                       // Get all the forms elements and their values in one step
                                                                       if (field.type == 'submit') {
                                                                       if (field.name == btnName){
                                                                       dataArr[field.name] = field.value;
                                                                       }
                                                                       }else if (field.type == 'radio') {
                                                                       if(field.checked == 1)
                                                                       dataArr[field.name] = field.value;
                                                                       }else if (field.type == 'checkbox') {
                                                                       if(field.checked == 1)
                                                                       dataArr[field.name] = field.value;
                                                                       }else if ($(field).prop('tagName').toLowerCase() == 'select') {
                                                                       if ($(field).val() != "")
                                                                       dataArr[field.name] = field.value;
                                                                       }else{
                                                                       dataArr[field.name] = field.value;   
                                                                       }
                                                                       });
  

    
    cordova.exec(function(data) {
                 console.log('Hello : '+data);
              
                 window.open(data);
                 
                 }, function(data) {
                 console.log("Error occured in " + actionName + " : " + data);
                 errorFunction("Error occured in " + actionName + " : " + data);
                 }, "RuntimePlugin", "continueSurvey",[JSON.stringify(dataArr)]);

    
}


