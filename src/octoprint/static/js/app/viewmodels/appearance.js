$(function() {
    function AppearanceViewModel(parameters) {
        var self = this;

        self.name = parameters[0].appearance_name;
        self.color = parameters[0].appearance_color;
        self.colorTransparent = parameters[0].appearance_colorTransparent;

        self.brand = ko.pureComputed(function() {
            if (self.name())
                return gettext("3DRaion") + ": " + self.name();
            else
                return gettext("3DRaion");
        });

        self.title = ko.pureComputed(function() {
            if (self.name())
                return self.name() + " [" + gettext("3DRaion") + "]";
            else
                return gettext("3DRaion");
        });
    }

    OCTOPRINT_VIEWMODELS.push([
        AppearanceViewModel,
        ["settingsViewModel"],
        "head"
    ]);
});
