//# sourceURL=settings.js

var Panel = {
	PanelData : {},
	init : function() {
        if(languageScript.phoneLanguage == "ar-EG"){
            $('.editPanel span.largefont,.versionDetails,.editPassword ,.editPassword #oldpwd,.versionNum,.editPassword #newpwd,.editPassword #confirmpwd,.body_content.editPanel.choosePanelWrapo').css({'text-align':'right','unicode-bidi':'bidi-override'});
        }
		this.fetchPanels();
		this.bindListners();
		$('select').addClass('empty');
        //$(".body_container").removeAttr("style");
	},
	bindListners : function() {
		$('#panelList').on('change', function() {
			$(this).removeClass('empty');
			$('.editPanel > .message').html();
		});
		$('.editPanel .submitBtn').on('click', function() {
			if ($('#panelList').val() == null)
				Panel.displayError(languageScript.translate("selectPanelErr"));
			else {
				cordovaFunction.storeData("selectedPanel",$('#panelList').val(),function(data){
					themeScript.applyTheme(Panel.PanelData,$('#panelList').val());
					utils.panelID = $('#panelList').val();
					$('.editPanel > .message').addClass('success').html(languageScript.translate('changePanelSuccess'));
				},function(data){
					$('.editPanel > .message').addClass('error').html(languageScript.translate('changePanelError'));
				});
			}
		});
	},
	fetchPanels : function() {
		cordovaFunction.fetchPanels({}, Panel.addPanels, Panel.displayError);
	},
	addPanels : function(result) {
		var validPanel = false;
		Panel.PanelData = result;
		Panel.PanelData.Panels.forEach(function(key, value) {
			var opt = new Option(key.Name, key.PanelID);
			if(utils.panelID == key.PanelID)
				validPanel = true;
			$('#panelList').append(opt);
		});
		$('#panelList').val(utils.panelID);
		if(!validPanel){
			utils.displayAlert(languageScript.translate('genericError'));
			applicationPage.logoutFunction();
		}
		if (Panel.PanelData.Panels.length <= 1) {
			$('#settings_pageHeader li[attrPanel = "Panel"]').hide();
			$('#settings_pageHeader li').css('width', '50%');
		}
		$('.pageHeader').show();
		$('.editPassword').addClass('active');
	},
	displayError : function(msg) {
		$('.editPanel > .message').addClass('error').html(msg);
		console.log("Error in change Panel" + msg);
		$('.pageHeader').show();
		$('.editPassword').addClass('active');
	}
};
var changePassword = {
	userCredentials : [ {
		'currentPassword' : '',
		'newPassword' : ''
	} ],
	init : function() {
		this.bindListners();
		this.styleBody();
		utils.IScrollRefresh('.editPassword.wrapper');
	},
	bindListners : function() {
		$(".editPassword input").on('keypress',function(event){
			var elementVal = $(this).val();
			if(event.keyCode == 13){
				if(elementVal == null || !elementVal){
					$(this)[0].focus();
					$(this).siblings().find('.invalid').show();
				}
				else{
					var nxtInput = $(this).parent('li').next().find('input');
					if(nxtInput && nxtInput.length > 0){
						nxtInput[0].focus();
					} else{
						$(this)[0].blur();
						changePassword.submitForm();
					}
				}
			}
			event.stopPropagation();
		});
		$(".editPassword input").on('blur',function(event){
			var elementVal = $(this).val();
			if(elementVal == null || !elementVal){
				$(this).siblings().find('.invalid').show();
			} else
				$(this).siblings().find('.invalid').hide();
			event.stopPropagation();
		});
		
		$('.editPassword .submitBtn').on('click',function() {
			changePassword.submitForm();
		});

		$(window).on('resize',function(){
			changePassword.styleBody();
		});
	},
	submitForm : function(){
		$('.editPassword .message').html('').removeClass('error').removeClass('success');
		if (!changePassword.formValid())
			changePassword 
					.displayError(languageScript.translate('changePwdError1'));
		else if ($('#oldpwd').val() === $('#newpwd').val())
			changePassword
					.displayError(languageScript.translate('changePwdError2'));
		else if ($('#confirmpwd').val() != $('#newpwd')
				.val())
			changePassword
					.displayError(languageScript.translate('changePwdError3'));
		else {
			changePassword.userCredentials = {
				'currentPassword' : $('#oldpwd').val(),
				'newPassword' : $('#newpwd').val()
			};
			changePassword
					.changeValue(changePassword.userCredentials);
		}
	},
	changeValue : function(newCredentials) {
		cordovaFunction.changePassword(newCredentials,
				changePassword.changeValueSuccess, changePassword.displayError);
	},
	changeValueSuccess : function(data) {
		changePassword.resetFields();
		$('.editPassword .message').html(languageScript.translate('changePwdSuccess')).removeClass('error').addClass('success');
	},
	resetFields : function() {
		$('input').val('');
		$('.editPassword .message').html('').removeClass('error').removeClass('success');
		$('.editPassword').find('.invalid').hide();
	},
 	formValid : function() {
		var isFormValid = true;
		$('input').each(function() {
			if (!$(this).val()) {
				isFormValid = false;
				$(this).siblings().find('.invalid').show();
			}
		});
		return isFormValid
	},
	styleBody : function(){
		var height = $('.body_container').height() - $('.pageHeader').outerHeight();
		var padding = parseInt($('.editPassword.wrapper').css('padding-top'));
		$('.editPassword.wrapper').css({'padding-top':0});
		$('.editPassword .scroller').css('padding-top', padding);
	},
	displayError : function(msg) {
		$('.editPassword .message').removeClass('success');
		$('.editPassword .message').addClass('error').html(msg);
	}
};

var settingsPage = {
	init : function() {
		this.bindListeners();
		$('.pageHeader').hide();
		$('.pageHeader li').eq(1).css('border-left','2px solid #D0DADC');
		Panel.init();
		changePassword.init();
	},
	bindListeners : function() {
		$('.pageHeader li').on('click', function() {
			$('.pageHeader li').removeClass('active');
			$('.pageHeader li').css('border-left','none');
			$(this).addClass('active');
			$(this).next().css('border-left','2px solid #D0DADC');
			$('.body_content').hide();			
			$('.edit' + $(this).attr('attrPanel')).show();
			if ($(this).attr('attrPanel') == "Password") {
				changePassword.init();
			} else{
				changePassword.resetFields();
				
			}
		});
	}
};

$(function() {
	'use strict';
	settingsPage.init();	
});