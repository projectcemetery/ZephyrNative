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
     *  Project
     */
    var project : ProjectSettings;

    /**
     *  Path to lib
     */
    var libDir : String;

    /**
     *  Write android.hxml
     *  @param path - 
     */
    function writeAndroidHxml (libPath : String) {
        Logger.infoStart ("Writing android.hxml");
        var text = project.generateAndroidHxml (libPath);
        File.saveContent ("android.hxml", text);
        Logger.endInfoSuccess ();
    }

    /**
     *  Compile haxe code
     */
    function compileHaxeCode () {
        Logger.infoStart ("Compiling haxe code");
        ProcessHelper.launch ("haxe", [ProjectSettings.androidHxmlName], function (error : String) {
            if (error != null) {
                Logger.endInfoError ();
                throw (error);
            }
        });
    }

    /**
     *  Save activity text
     */
    function saveActivityText (activityText : String) {
        var activityName = project.getActivityName ();
        var text = activityText.replace (ProjectSettings.activityNameParam, activityName);
        text = text.replace (ProjectSettings.projectNameParam, project.settings.name);
        text = text.replace (ProjectSettings.packageNameParam, project.settings.packageName);

        var path = Path.join ([workPath,"build", "android", "src", "main", "java", "src" ,"zephyr", '${activityName}.java']);
        File.saveContent (path, text);

        var androidProjPath = Path.join ([workPath, "build", "android"]);
        Sys.setCwd (androidProjPath);        
    }

    /**
     *  Gradle build/install
     */
    function buildInstall (isInstall) {
        var cmd = {
            if (Sys.systemName () == "Windows") {
                "gradlew.bat";
            } else {
                "./gradlew";
            }
        }

        // Only build            
        if (!isInstall) {
            Logger.infoStart ("Assembling APK");            
            ProcessHelper.launch (cmd, ["assembleDebug"], function (error : String) {
                if (error != null) {
                    throw (error);
                } else {
                     Logger.endInfoError ();
                }
            });
            Logger.endInfoSuccess ();
        // Build and install
        } else {
            Logger.infoStart ("Assembling and installing APK");                
            ProcessHelper.launch (cmd, ["installDebug"], function (error : String) {
                if (error != null) {
                    throw (error);
                } else {
                     Logger.endInfoError ();
                }
            });
            Logger.endInfoSuccess ();
        }
    }

    /**
     *  Build/install for android
     *  @param isInstall - 
     */
    function buildAndroid (isInstall : Bool) {
        trace ("SHIT");
        // Get templates
        var activityText = FileUtil.getTemplate ("ActivityText.java");        
        Sys.setCwd (workPath);
        
        writeAndroidHxml (libDir);        
        compileHaxeCode ();
        saveActivityText (activityText);        
        buildInstall (isInstall);
    }

    /**
     *  Build for web
     */
    function buildWeb () {
        
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
        libDir = Sys.getCwd ();        
        project = ProjectSettings.load (ProjectSettings.projectNameDef); 
              
        switch (target) {
            case Target.Android : buildAndroid (isInstall);
            case Target.Web : buildWeb ();
            default: {
                throw "Unsupported platform";
            }
        }        
    }
}