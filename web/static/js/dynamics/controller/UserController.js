/**
 * Userpage controller
 * 
 * @constructor
 * @base CommonController
 */
var UserController = function(options) {
  this.id = options.id;
  this.infoElement = options.userInfoElement;
  this.passwordElement = options.passwordElement;
  this.userSettingsElement = options.userSettingsElement;
  this.init();
  this.initConfigs();
  this.paint();
};
UserController.prototype = new BacklogController();

/**
 * Initialize and render the story list.
 */
UserController.prototype.paint = function() {
  var me = this;
  ModelFactory.initializeFor(ModelFactory.initializeForTypes.user,
      this.id, function(model) {
        me.model = model;
        me._renderTables();
      });
};

UserController.prototype._renderTables = function()  {
  this.infoView = new DynamicVerticalTable(
      this, this.model, this.userInfoConfig,
      this.infoElement);
  this.infoView.render();
  
  this.passwordView = new DynamicVerticalTable(
      this, this.model, this.passwordViewConfig,
      this.passwordElement);
  this.passwordView.render();
  
  this.settingsView = new DynamicVerticalTable(
      this, this.model, this.settingsViewConfig,
      this.userSettingsElement);
  this.settingsView.render(); 
};

/**
 * Initialize product details configuration.
 */
UserController.prototype.initConfigs = function() {
  this._initUserInfoConfig();
  this._initPasswordConfig();
  this._initSettingsConfig();
};

UserController.columnIndices = {
  fullName:   0,
  loginName:  1,
  initials:   2,
  email:      3,
  weekEffort: 4
};

UserController.prototype._initUserInfoConfig = function() {
  var config = new DynamicTableConfiguration( {
    leftWidth: '20%',
    rightWidth: '79%',
    cssClass: "ui-widget-content ui-corner-all",
    caption: "User info",
    captionConfig: {
      cssClasses: "dynamictable-caption-block ui-widget-header ui-corner-all"
    }
  });
  
  config.addColumnConfiguration(UserController.columnIndices.fullName, {
    title : "Name",
    get : UserModel.prototype.getFullName,
    editable : true,
    edit : {
      editor : "Text",
      required: true,
      set: UserModel.prototype.setFullName
    }
  });
  
  config.addColumnConfiguration(UserController.columnIndices.loginName, {
    title : "Login name",
    get : UserModel.prototype.getLoginName,
    editable : true,
    edit : {
      editor : "Text",
      required: true,
      set: UserModel.prototype.setLoginName
    }
  });
  
  config.addColumnConfiguration(UserController.columnIndices.initials, {
    title : "Initials",
    get : UserModel.prototype.getInitials,
    editable : true,
    edit : {
      editor : "Text",
      required: true,
      set: UserModel.prototype.setInitials
    }
  });
  
  config.addColumnConfiguration(UserController.columnIndices.email, {
    title : "Email",
    get : UserModel.prototype.getEmail,
    editable : true,
    edit : {
      editor : "Email",
      required: true,
      set: UserModel.prototype.setEmail
    }
  });
  
  config.addColumnConfiguration(UserController.columnIndices.weekEffort, {
    title : "Weekly hours",
    get : UserModel.prototype.getWeekEffort,
    editable : true,
    decorator: DynamicsDecorators.exactEstimateDecorator,
    edit : {
      editor : "ExactEstimate",
      required: true,
      set: UserModel.prototype.setWeekEffort,
      decorator: DynamicsDecorators.exactEstimateEditDecorator
    }
  });
  
  this.userInfoConfig = config;
};

/**
 * Callback for changing password.
 */
UserController.prototype.changePassword = function() {
  var model = this.model;
  var element = $('<div/>').appendTo(document.body);
  $('<div/>').text("Change password of " + model.getFullName()).appendTo(element);
  
  var container = $('<div/>').text('New password: ').appendTo(element);
  var input = $('<input type="password"/>').appendTo(container);
  var dialog = element.dialog({
    modal: true,
    buttons: {
      'Ok': function() {
        model.setPassword1(input.val());
        element.dialog('destroy');
        element.remove();
      },
      'Cancel': function() {
        element.dialog('destroy');
        element.remove();
      }
    }
  });
};


/**
 * Initialize configuration for password changing.
 */
UserController.prototype._initPasswordConfig = function() {
  var config = new DynamicTableConfiguration( {
    leftWidth: '20%',
    rightWidth: '79%',
    cssClass: "ui-widget-content ui-corner-all",
    caption: "Change password",
    captionConfig: {
      cssClasses: "dynamictable-caption-block ui-widget-header ui-corner-all"
    }
  });
  
  config.addCaptionItem({
    text: "Change password",
    name: "changePassword",
    callback: UserController.prototype.changePassword
  });
  /*
  config.addColumnConfiguration(0, {
    title : "Password",
    get : function() { return ""; },
    editable : true,
    edit : {
      editor : "Text",
      required: true
    }
  });
  
  config.addColumnConfiguration(1, {
    title : "Confirm password",
    get : function() { return ""; },
    editable : true,
    edit : {
      editor : "Text",
      required: true
    }
  });
  */
  this.passwordViewConfig = config;
};

/**
 * Initialize configuration for settings changing.
 */
UserController.prototype._initSettingsConfig = function() {
  var config = new DynamicTableConfiguration( {
    leftWidth: '20%',
    rightWidth: '79%',
    cssClass: "ui-widget-content ui-corner-all",
    caption: "User specific settings",
    captionConfig: {
      cssClasses: "dynamictable-caption-block ui-widget-header ui-corner-all"
    }
  });

  /*
  config.addColumnConfiguration(0, {
    title : "Autoassign to tasks",
    get: UserModel.prototype.isAutoAssignToTasks,
    editable : true,
    edit : {
      editor : "SingleSelection",
      items  : { "true": "True", "false": "False" },
      set: UserModel.prototype.setAutoAssignToTasks
    }
  });
  */
  this.settingsViewConfig = config;
};

