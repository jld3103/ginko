package main

// DO NOT EDIT, this file is generated by hover at compile-time for the downloads_path_provider plugin.

import (
	flutter "github.com/go-flutter-desktop/go-flutter"
	downloads_path_provider "github.com/jld3103/downloads_path_provider/go"
)

func init() {
	// Only the init function can be tweaked by plugin maker.
	options = append(options, flutter.AddPlugin(&downloads_path_provider.DownloadsPathProviderPlugin{}))
}
