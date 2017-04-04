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
     *  Params for command
     */
    var params : Rest<String>;

    /**
     *  Constructor
     */
    public function new (params : Rest<String>) {
        if (params.length < 1) throw "Wrong parameters";
        this.params = params;        
    }

    /**
     *  Run build
     */
    public function run (isInstall : Bool = false) {
        try {
            var workPath = params[0];            
            var activityText = FileUtil.getTemplate ("ActivityText.java");
            Sys.setCwd (workPath);
            var project = ProjectSettings.load (ProjectSettings.projectNameDef);
            trace ("Compiling haxe code");            
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

            // Only build
            if (!isInstall) {
                trace ("Assembling APK");            
                ProcessHelper.launch ("./gradlew", ["assembleDebug"], function (error : String) {
                    if (error != null) throw (error);
                });
                trace ("Build complete");
            } else {
                trace ("Assembling and installing APK");            
                ProcessHelper.launch ("./gradlew", ["installDebug"], function (error : String) {
                    if (error != null) throw (error);
                });
                trace ("Installation complete");
            }            
        } catch (e : Dynamic) {
            trace (e);
            trace ("Can't build project");
        }
    }
}