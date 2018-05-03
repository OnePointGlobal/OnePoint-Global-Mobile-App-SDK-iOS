$(function() {
  
  $('input[type="submit"]').on('click',function() {
                               // Get all the forms elements and their values in one step
                               var dataArr = {};
                               var btnName = $(this).attr('name');
                               $('#mrForm').find('input, textarea, select, radio, checkbox').each(function(i, field) {
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
                             /*  cordovaFunction.nextSurvey(JSON.stringify(dataArr), function(data) {
                                                          window.open(data);
                                                          }, function(data) {
                                                          console.log(data);
                                                          });*/
                    cordova.exec(function(data) {
                                    window.open(data);
                                    }, function(data) {
                                    console.log("Error occured in " + actionName + " : " + data);
                                    errorFunction("Error occured in " + actionName + " : " + data);
                                    }, "RuntimePlugin", "continue", [JSON.stringify(dataArr)]);
                               
                               
                               });
  
  });

