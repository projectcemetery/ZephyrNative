package console.commands;

import tink.cli.*;
import sys.FileSystem;
import haxe.io.Path;
import sys.io.File;
import sys.io.Process;
import console.ProjectSettings;

using StringTools;

/**
 *  Command for build project
 */
class BuildProject {

    /**
     *  Path from which util was launched
     */
    var workPath : String;

    /**
     *  Build/install target
     */
    var target : Target;

    /**
     *  Build/install for android
     *  @param isInstall - 
     */
    function buildAndroid (isInstall : Bool) {
        var activityText = FileUtil.getTemplate ("ActivityText.java");
        Sys.setCwd (workPath);
        var project = ProjectSettings.load (ProjectSettings.projectNameDef);
        Logger.info ("Compiling haxe code");            
        ProcessHelper.launch ("haxe", [ProjectSettings.androidHxmlName], function (error : String) {
            if (error != null) throw (error);
        });

        var activityName = project.getActivityName ();
        var text = activityText.replace (ProjectSettings.activityNameParam, activityName);
        text = text.replace (ProjectSettings.projectNameParam, project.settings.name);
        text = text.replace (ProjectSettings.packageNameParam, project.settings.packageName);

        var path = Path.join ([workPath,"build", "android", "src", "main", "java", "src" ,"zephyr", '${activityName}.java']);
        File.saveContent (path, text);

        var androidProjPath = Path.join ([workPath, "build", "android"]);
        Sys.setCwd (androidProjPath);

        var cmd = {
            if (Sys.systemName () == "Windows") {
                "gradlew.bat";
            } else {
                "./gradlew";
            }
        }

        // Only build            
        if (!isInstall) {
            Logger.info ("Assembling APK");            
            ProcessHelper.launch (cmd, ["assembleDebug"], function (error : String) {
                if (error != null) throw (error);
            });
            Logger.info ("Build complete");
        } else {
            Logger.info ("Assembling and installing APK");                
            ProcessHelper.launch (cmd, ["installDebug"], function (error : String) {
                if (error != null) throw (error);
            });
            Logger.info ("Installation complete");
        }        
    }

    /**
     *  Constructor
     */
    public function new (params : Array<String>, other : Rest<String>) {
        if (other.length < 1) throw "Wrong parameters";
        workPath = other[0];
        target = params[0];
    }

    /**
     *  Run build
     */
    public function run (isInstall : Bool = false) {
        switch (target) {
            case Target.Android : buildAndroid (isInstall);
            default: {
                throw "Unsupported platform";
            }
        }        
    }
}