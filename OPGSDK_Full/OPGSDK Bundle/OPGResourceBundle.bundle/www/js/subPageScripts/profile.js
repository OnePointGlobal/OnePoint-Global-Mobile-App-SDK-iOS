//# sourceURL=profile.js

var editProfilebtn = $('.editProfileBtn'), profilewrapo = $('.profilewrapo'), editprofilewrapo = $('.editProfilewrapo'), submitbtn = $(".submitBtn"), inputs = $('input'), selects = $('select'), cancelbtn = $(".cancelBtn");

var Profile = {
	isFormValid : true,
	edittedCredential : {},
	userProfile : {},
	gender : {
		1 : languageScript.languageFile['genderPHOpt1'],
		2 : languageScript.languageFile['genderPHOpt2']
	}, maritalStatus : {
		1 : languageScript.languageFile['maritalStatusPHOpt1'],
		2 : languageScript.languageFile['maritalStatusPHOpt2'],
		3 : languageScript.languageFile['maritalStatusPHOpt3'],
		4 : languageScript.languageFile['maritalStatusPHOpt4']
        
	},
	imageURI : null,
	profileData : {},
	init : function() {
            this.bindListners();
            this.fetchProfile();
        $(".body_container").removeAttr("style");
    },

	bindListners : function() {
        $('.bodyWrapper').show();
		editProfilebtn.on('click', function() {
			Profile.editting();
		});

		cancelbtn.on('click', function() {
			Profile.canceleditting();
		});
		
        $('input.noInteger').bind('keyup blur', function () {
                                  $(this).val($(this).val().replace(/[^A-Za-z]/g, ''))
                                  });

		/*document.addEventListener("showkeyboard", function(){
			$('.pageFooter').hide();
		}, false);*/
		
		document.addEventListener("hidekeyboard", function(){
				$('.pageFooter').show();
	    }, false);

		// validate each field on any change
		$('input , select').each(function() {

			$(this).on('blur focusout change', function() {
				Profile.instantValidation($(this));
				Profile.displayError($(this).parent('li').attr('aria-error'));
			});

			$(this).on('focus', function() {
				Profile.displayError($(this).parent('li').attr('aria-error'));
			});

		});

		// remove placeholder on selection of a option for select fields
		$('select').on('change', function() {
			$(this).removeClass('empty');
		});

		// supress keyboard and use mobile datepicker to select date
		$('input#DOB').bind('click', function(e) {
			e.preventDefault();
			try {
                var position = Profile.getPopoverPosition('input#DOB');
				platformSpecific.datepicker($(this),position);
			} catch (err) {
				console.log("Error: " + err);
			}
		});

		// show media options while uploading photos
		$('.uploadPhoto .pic, .uploadPhoto span').on('click', function(e) {
            e.stopPropagation();
			$('.optionWrapper, .mediaWrapper').show();
		});

		// remove options if user clicks outside
		$('.mediaWrapper').on('click', function(e) {
			e.stopPropagation();
			e.preventDefault();
			var $target = $(e.target);
			if($target.is(".mediaSelect div") || $target.parents().is(".mediaSelect div")){
				var option = $target.parent("div.option").attr('data-attr') || $target.attr('data-attr');
				var mediaOptions = {
					"gallery" : 0,
					"camera" : 1
				};
				if(option == "remove"){
					Profile.setImageURI(null);
				}else{
					try {
                        var position = Profile.getPopoverPosition('.uploadPhoto .pic');
                      //  platformSpecific.getImage(mediaOptions[option],1,Profile.setImageURI, position);
                        cordovaFunction.uploadImageToLocation(mediaOptions[option],Profile.setImageURI,position);
					} catch (err) {
						console.log("Error: " + err);
					}
				}
				Profile.hideMediaSelectionPanel(e);
			}
			else Profile.hideMediaSelectionPanel(e);
		});

		// submit the form
		submitbtn.on('click', function() {
			try{
			var m_names_g = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun",
					"Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
			var m_names_l = new Array(languageScript.languageFile['Jan'], languageScript.languageFile['Feb'],
					languageScript.languageFile['Mar'],languageScript.languageFile['Apr'], languageScript.languageFile['May'],
					languageScript.languageFile['Jun'],languageScript.languageFile['Jul'], languageScript.languageFile['Aug'],
					languageScript.languageFile['Sep'], languageScript.languageFile['Oct'], languageScript.languageFile['Nov'],
					languageScript.languageFile['Dec']);
			// check if form is valid and set the validated values
			if (Profile.formValid()) {
				// send entered values
				var Date_o_birth = $('input#DOB').val();
				var mnth =  Date_o_birth.substring(0,Date_o_birth.indexOf(" "));
				var m_index = m_names_l.indexOf(mnth);
				var mnth_g = m_names_g[m_index];
				var re_Date_o_birth = Date_o_birth.replace(mnth,mnth_g);
				Profile.profileData = {
					"FirstName" : $('input#FirstName').val(),
					"LastName" : $('input#LastName').val(),
					"MaritalStatus" : $('select#maritalStatus').val(),
					"Gender" : $('select#gender').val(),
					"DOB" : platformSpecific.getISOString(re_Date_o_birth),
					"MediaID" : $('.pic > img').attr("data-id")
				};
          
				Profile.storeProfile(Profile.profileData);
			} else {
				Profile.displayError(languageScript.translate('correctErrors'));
			}
			}catch(e){utils.displayAlert(e)}
		});

	},
    getPopoverPosition : function(elm){
        if(isMobile.iPad){
            var offset = $(elm).offset();
            var top = offset.top+80;
            var left = offset.left;

            return {'left':left,'top':top};
            
        }else return null;
    },
	hideMediaSelectionPanel : function(){
		$('.optionWrapper, .mediaWrapper').hide();
	},
	setImageURI : function(data){
		Profile.imageURI = data? data : "images/profile.png";
		if(data && isMobile.Android()){
			var imageDataToSend =  {
					"mediaPath": Profile.imageURI, 
					"comments":"Profile Pic"
				};
			cordovaFunction.getPath(imageDataToSend,function(data){
				$('.editProfilewrapo .pic > img').attr("src", data.path+"?"+new Date().getTime());
			},function(){});
		}else{
			$('.editProfilewrapo .pic > img').attr("src", Profile.imageURI+"?"+new Date().getTime());
		}
	},
	storeProfile : function(profileData) {

		// format to send data
		var dataToSend = {
			"FirstName" : "",
			"LastName" : "",
			"Address2" : "",
			"Address1" : "",
			"Website" : "",
			"MediaID" : "",
			"DOB" : "",
			"Email" : "",
			"PostalCode" : "",
			"CountryCode" : "",
			"MobileNumber" : "",
			"Gender":"",
			"MaritalStatus":""
		};
		$.each(dataToSend, function(key, value) {
			if (profileData[key]) {
				dataToSend[key] = profileData[key];
				Profile.userProfile[key] = profileData[key];
			} else
				dataToSend[key] = Profile.userProfile[key];
		});
		if(Profile.imageURI!=null && Profile.imageURI!="images/profile.png"){
			var imageDataToSend =  {
					"mediaPath": Profile.imageURI, 
					"comments":"Profile Pic"
				};
			$('.optionWrapper,.uploadWrapper').show();
			$('.uploadDiv .opt').css('width',0);
			cordovaFunction.uploadImage(imageDataToSend,function(data){
				if(data.Percent){		
					$('.uploadDiv .opt').css('width',data.Percent+'%');
					if(data.Percent == 100){
						$('.uploadDiv .opt').css('border-radius','5px 5px 5px 5px');
					}
				}else{
					$('.optionWrapper,.uploadWrapper').hide();
					dataToSend["MediaID"]  = data.MediaID;
					Profile.userProfile["MediaID"] = data.MediaID;
					cordovaFunction.downloadImage({"mediaID":data.MediaID,"mediaType" : "Image"}, function(data){
                                                 Profile.imageURI = data.path ? data.path : "images/profile.png";
                                                  Profile.userProfile["imageSrc"] = Profile.imageURI;
                                                  cordovaFunction.storeProfile(dataToSend,Profile.finishEditting,Profile.displayError);
                                },function(error){	Profile.imageURI = "images/profile.png";   cordovaFunction.storeProfile(dataToSend,Profile.finishEditting,Profile.displayError);} );
				}	
			},function(data){
				$('.optionWrapper,.uploadWrapper').hide();
				Profile.displayError(data);
			});
		}else{
			if(Profile.imageURI == "images/profile.png"){
				dataToSend["MediaID"] = null;
				Profile.userProfile["MediaID"] = null;
				Profile.userProfile["imageSrc"] = "images/profile.png";
			}
			cordovaFunction.storeProfile(dataToSend,Profile.finishEditting,Profile.displayError);
		}
		
	},
	fetchProfile : function() {
		cordovaFunction.fetchProfile({}, Profile.setProfile,function(data){
			utils.displayAlert(languageScript.translate('genericError'));
			});
		return true;
	},
	setProfile : function(data){
		Profile.userProfile = data.PanellistProfileData;
		Profile.userProfile.imageSrc = utils.userImage;
		//console.log('set profile profile data : '+JSON.stringify(Profile.userProfile));
		Profile.setIntialField();
        $('.bodyWrapper').hide();
	},
	editting : function() {
		// edit profile
		profilewrapo.hide();
		Profile.setIntialField();
		editprofilewrapo.show();
		utils.styleBody();
		utils.IScrollRefresh('.editProfilewrapo .wrapper');
	},
	
	finishEditting : function() {
		// finish editting profile
		utils.appstatus();
		
		$.each(Profile.profileData, function(key, value) {
			Profile.userProfile[key] = Profile.profileData[key];
		});
		//console.log('finish editing profile data : '+JSON.stringify(Profile.userProfile));
		Profile.setIntialField();
		Profile.canceleditting();
	},

	canceleditting : function() {
		// come back to profile
		editprofilewrapo.hide();
		Profile.resetFields();
		profilewrapo.show();
		utils.styleBody();
		utils.IScrollRefresh('.profilewrapo .wrapper');
	},

	setIntialField : function() {
		// fetch value from userCredential object and display in the UI
		// fields
		//console.log('set initial filed data : '+JSON.stringify(Profile.userProfile));
		if(!Profile.userProfile)
			return;
		var FirstName = Profile.userProfile.FirstName || '';
		var LastName = Profile.userProfile.LastName || '';
		var Gender = Profile.userProfile.Gender || 0;
		var MaritalStatus = Profile.userProfile.MaritalStatus || 0;
		var DOB = Profile.userProfile.DOB || "";
		var formattedDate = platformSpecific.formatDate(DOB);
		var Email = Profile.userProfile.Email || '';
		var MobileNumber = Profile.userProfile.MobileNumber || '';
		var imageSrc = Profile.userProfile.imageSrc || "images/profile.png";
		var MediaID = Profile.userProfile.MediaID || null;
		
		$('li.FullName').html(FirstName + " " + LastName);
		$('input#FirstName').val(FirstName);
		$('input#LastName').val(LastName);
		$('select#gender').val(Gender);
        //console.log("profile data--"+Profile.gender);
        //console.log("selected value--"+Gender);
		$('div.gender').html(Profile.gender[Gender]);
		$('select#maritalStatus').val(MaritalStatus);
		$('div.maritalStatus').html(Profile.maritalStatus[MaritalStatus]);
		
		$('input#DOB , div.DOB').val(formattedDate).html(formattedDate);

		$('div.Email').html(Email);
		$('div.MobileNumber').html(MobileNumber);
		
		$('.pic > img').attr("src", imageSrc+"?"+new Date().getTime());
		
		$('.pic > img').attr("data-id", MediaID);

		Profile.resetFields();
		utils.styleBody();
		utils.IScrollRefresh('.profilewrapo .wrapper');
	},
	formValid : function() {

		// loop through all fields, validate them, and set isFormValid to
		// false if any field is invalid

		isFormValid = true;

		$("input , select").each(function() {

			Profile.instantValidation($(this));

			if ($(this).parent('li').attr('aria-invalid') == "true") {
				isFormValid = false;
			}
		});
		return isFormValid;
	},

	shouldBeValidated : function(field) {

		// if field is not readonly, disabled, and is required, then
		// validate it
		return (!(field.attr('disabled') || field.disabled) && (field
				.attr('required') || field.required));
	},

	instantValidation : function(field) {

		// if field should be validated, then validate against
		// null values for required fields,
		// against set patterns
		// and set aria-invalid attribute accordingly
		var fieldParent = field.parent('li');

		if (this.shouldBeValidated(field)) {
			var fieldID = field.attr('id');
			var invalid = field.attr('required') && !field.val();
			if (!invalid) {
				fieldParent.attr({'aria-error':'','aria-invalid':'false'});
				field.siblings('.validateImg').find('.valid').show();
				field.siblings('.validateImg').find('.invalid').hide();

			} else if (invalid) {
				
				fieldParent.attr({'aria-error':languageScript.translate('err'+fieldID),'aria-invalid':'true'});
				field.siblings('.validateImg').find('.valid').hide();
				field.siblings('.validateImg').find('.invalid').show();
			}
		}
	},
	resetFields : function(){
		// reset aria values for errors and validation
		$('.editProfilewrapo li').removeAttr('aria-invalid aria-error');
		$('.valid, .invalid').hide();
		
		// set default null option of select field as placeholder
		$('select').each(function() {
			if ($(this).val() == null)
				$(this).addClass('empty');
		});

		// reset error field
		$('.message').html('');
		//reset uploaded image URI
		Profile.imageURI = null;
	},
	displayError : function(err) {
		$('.message').addClass('error').html(err);
	}
};

$(function() {
	Profile.init();
});
