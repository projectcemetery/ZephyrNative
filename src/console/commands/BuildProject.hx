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
     *  Build/install target
     */
    var target : Target;

    /**
     *  Project
     */
    var project : ProjectSettings;

    /**
     *  Write android.hxml
     *  @param path - 
     */
    function writeAndroidHxml () {
        Logger.infoStart ("Writing android.hxml");
        var text = project.generateAndroidHxml (FileUtil.libDir);
        File.saveContent ("android.hxml", text);
        Logger.endInfoSuccess ();
    }

    /**
     *  Copy build data from bundle if not exists
     */
    function writeBuildData () {
        var workBuild = Path.join ([FileUtil.workDir, "build", "android"]); 
        if (!FileSystem.exists (workBuild)) {
            var libBuild = Path.join ([FileUtil.libDir, "bundle", "build", "android"]);            
            FileUtil.copyFromDir (libBuild, workBuild);
        }        
    }

    /**
     *  Compile haxe code
     */
    function compileHaxeCode () {
        Logger.infoStart ("Compiling haxe code");
        ProcessHelper.launch ("haxe", [ProjectSettings.androidHxmlName]);
        Logger.endInfoSuccess ();
    }

    /**
     *  Save activity text
     */
    function saveActivityText () {
        var activityText = FileUtil.getTemplate ("ActivityText.java");

        var activityName = project.getActivityName ();
        var text = activityText.replace (ProjectSettings.activityNameParam, activityName);
        text = text.replace (ProjectSettings.projectNameParam, project.settings.name);
        text = text.replace (ProjectSettings.packageNameParam, project.settings.packageName);

        var path = Path.join ([FileUtil.workDir,"build", "android", "src", "main", "java", "src" ,"zephyr", '${activityName}.java']);
        File.saveContent (path, text);               
    }

    /**
     *  Fix AndroidManifest.xml
     */
    function writeManifest () {
        var name = "AndroidManifest.xml";
        var content = FileUtil.getTemplate (name);        
        content = content.replace ("${packageName}", project.settings.packageName);
        content = content.replace ("${projectName}", project.settings.name);
        content = content.replace ("${activityName}", project.getActivityName ());        
        var path = Path.join ([FileUtil.workDir, "build", "android", "src", "main", name]);
        File.saveContent (path, content);
    } 

    /**
     *  Gradle build/install
     */
    function buildInstall (isInstall) {
        var androidProjPath = Path.join ([FileUtil.workDir, "build", "android"]);
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
            Logger.infoStart ("Assembling APK");            
            ProcessHelper.launch (cmd, ["assembleDebug"]);
            Logger.endInfoSuccess ();
        // Build and install
        } else {
            Logger.infoStart ("Assembling and installing APK");                
            ProcessHelper.launch (cmd, ["installDebug"]);
            Logger.endInfoSuccess ();
        }
    }

    /**
     *  Build/install for android
     *  @param isInstall - 
     */
    function buildAndroid (isInstall : Bool) {
        // Get templates                
        Sys.setCwd (FileUtil.workDir);        
        writeAndroidHxml ();
        writeBuildData ();
        compileHaxeCode ();
        saveActivityText ();
        writeManifest ();
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
        target = params[0];
    }

    /**
     *  Run build
     */
    public function run (isInstall : Bool = false) {        
        var path = Path.join ([FileUtil.workDir, ProjectSettings.projectNameDef]);
        project = ProjectSettings.load (path); 
              
        switch (target) {
            case Target.Android : buildAndroid (isInstall);
            case Target.Web : buildWeb ();
            default: {
                throw "Unsupported platform";
            }
        }
    }
}