var landingPage = {
	PanelData : [],
	selectedPanel: 0, userFullName: "",themeString:"",userImage:"",
	// Application Constructor
	init : function() {
		landingPage.bindEvents();

		languageScript.applyLocalization(function(){
			landingPage.styleBody();
		});
		
		$('#panelList').addClass('empty');
		landingPage.getData();
	},
	// Bind Event Listeners
	bindEvents : function() {

		$('#panelList').on('change', function() {
			$(this).removeClass('empty');

		});
		$('.submitBtn').on('click',function(){
			if($('#panelList').val() == null)
				$('.message').addClass('error').html(languageScript.translate('selectPanelErr'));
			else{
				landingPage.selectedPanel = $('#panelList').val();
				landingPage.addTheme();
			}
		});
		
		$(window).on('resize',function(){
			landingPage.styleBody();
		});

	},
	getData : function(){
		//$(".bodyWrapper").show();//$(".bodyWrapper .spinner").hide();	//$(".loadingNotify").show();
		cordovaFunction.checkForUpdate([],landingPage.fetchProfile,landingPage.displayError);
	},
	fetchProfile : function(){
		//$(".bodyWrapper").hide();	//$(".bodyWrapper .spinner").hide();	//$(".loadingNotify").hide();
		cordovaFunction.fetchProfile({},landingPage.addProfile,landingPage.displayError);
	},
	addProfile : function(data){
		landingPage.userFullName = data.PanellistProfileData.FirstName;
		$('.welcome').append(landingPage.userFullName +"!");
		if(data.PanellistProfileData.MediaID){
			var imageDataToSend = {"mediaType":"Image", "mediaID": data.PanellistProfileData.MediaID};
			cordovaFunction.downloadImage(imageDataToSend,function(data){
				landingPage.userImage = data.path;
				landingPage.fetchPanels();
			},function(){
				landingPage.fetchPanels();
			});
		} else landingPage.fetchPanels();
	},
	fetchPanels : function(){
		$('.bodyWrapper').show();
		cordovaFunction.fetchPanels({},landingPage.addPanels,landingPage.displayError);
	},
	addPanels : function(result) {
		$('.bodyWrapper').hide();
		var defaultPanel;
		landingPage.PanelData = result;
		landingPage.PanelData.Panels.forEach(function(key, value) {
			if(value == 0){
				landingPage.selectedPanel = key.PanelID;
			}
			var opt = new Option(key.Name, key.PanelID);
			$('#panelList').append(opt);
		});
		if(landingPage.PanelData.Panels.length > 1){
			$('.body_content.editPanel').css('opacity',1);
		}
		else{
			landingPage.addTheme();
		}
	},
	addTheme : function(){
		var theme = themeScript.applyTheme(landingPage.PanelData,landingPage.selectedPanel);
		landingPage.goToApp();
	},
	goToApp : function(){
		$('.bodyWrapper').show();
		cordovaFunction.storeData("selectedPanel", landingPage.selectedPanel,
				function(data) {}, function(data) {});
		window.open('applicationPage.html', '_self');
	},
	displayError: function(data){
		$('.bodyWrapper').hide();
		utils.displayAlert(data);
	},
	styleBody : function(){
		var windowHeight = window.innerHeight ? window.innerHeight : $(window).height();
		if(isMobile.iOS())
			windowHeight -= 20;
		var contentHeight = $('.choosePanelWrapo').height();
		var ht = (windowHeight - contentHeight)/2;
		if(ht > 0)
			$('.choosePanelWrapo').css('padding-top',ht);
	}
};

//if DOM loaded, proceed to bind the Cordova's deviceready event
$(function() {
	app.init('landingPage');
	//landingPage.init();
});