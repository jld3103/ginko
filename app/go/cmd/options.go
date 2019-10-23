package main

import (
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/nealwon/go-flutter-plugin-sqlite"
    file_picker "github.com/miguelpruivo/plugins_flutter_file_picker/go"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(800, 600),
    flutter.AddPlugin(sqflite.NewSqflitePlugin(flutter.ProjectOrganizationName, flutter.ProjectName)),
    flutter.AddPlugin(&file_picker.FilePickerPlugin{}),
}
