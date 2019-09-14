package main

import (
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/plugins/shared_preferences"
	"github.com/go-flutter-desktop/plugins/path_provider"
	"github.com/nealwon/go-flutter-plugin-sqlite"
	"github.com/go-flutter-desktop/plugins/url_launcher"
)

var vendorName = "ginko"
var applicationName = "app"

var options = []flutter.Option{
	flutter.WindowInitialDimensions(800, 600),
	flutter.AddPlugin(&shared_preferences.SharedPreferencesPlugin{
    	VendorName:      vendorName,
    	ApplicationName: applicationName,
    }),
    flutter.AddPlugin(&path_provider.PathProviderPlugin{
    	VendorName:      vendorName,
    	ApplicationName: applicationName,
    }),
    flutter.AddPlugin(sqflite.NewSqflitePlugin(vendorName,applicationName)),
    flutter.AddPlugin(&url_launcher.UrlLauncherPlugin{}),
}
