package console.commands;

import tink.cli.*;
import sys.FileSystem;
import haxe.io.Path;
import sys.io.File;
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
     *  Write hxml file
     *  @param path - 
     */
    function writeHxml () {
        Logger.infoStart ('Writing ${target}.hxml');
        var text = switch(target) {
            case Target.Android: project.generateAndroidHxml ();
            case Target.Web: project.generateWebHxml ();
            default: throw "Unknown target";
        }
        
        var outPath = Path.join (["build", '${target}.hxml']);
        File.saveContent (outPath, text);
        Logger.endInfoSuccess ();
    }

    /**
     *  Copy build data from bundle if not exists
     */
    function writeBuildData () {
        var workBuild = Path.join ([FileUtil.workDir, "build", target]); 
        if (!FileSystem.exists (workBuild)) {
            FileSystem.createDirectory (workBuild);
            var libBuild = Path.join ([FileUtil.libDir, "bundle", "build", target]);            
            Logger.infoStart ('Copy bundle from ${libBuild} to ${workBuild}');
            FileUtil.copyFromDir (libBuild, workBuild);
            Logger.endInfoSuccess ();
        }        
    }

    /**
     *  Compile haxe code
     */
    function compileHaxeCode () {
        Logger.infoStart ("Compiling haxe code");

        var name = switch (target) {
            case Target.Android: ProjectSettings.androidHxmlName;
            case Target.Web: ProjectSettings.webHxmlName;
            default: throw "Unsupported platform";
        }

        var path = Path.join ([FileUtil.workDir, "build"]);
        var old = Sys.getCwd ();
        Sys.setCwd (path);
        ProcessHelper.launch ("haxe", [name]);
        Logger.endInfoSuccess ();
        Sys.setCwd (old);
    }

    /**
     *  Save activity text
     */
    function writeActivityText () {
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
        writeHxml ();
        writeBuildData ();
        compileHaxeCode ();
        writeActivityText ();
        writeManifest ();
        buildInstall (isInstall);                      
    }

    /**
     *  Write index.html
     */
    function writeIndex () {
        Logger.infoStart ('Writing index.html');
        var indexText = FileUtil.getTemplate ("index.html");        
        var text = indexText.replace (ProjectSettings.projectNameParam, project.settings.packageName);      
        var path = Path.join ([FileUtil.workDir,"build", "web", "index.html"]);
        File.saveContent (path, text);
        Logger.endInfoSuccess ();
    }

    /**
     *  Build for web
     */
    function buildWeb () {        
        writeHxml ();
        writeBuildData ();
        writeIndex ();
        compileHaxeCode ();
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
        
        // Set dir to working project dir
        Sys.setCwd (FileUtil.workDir);
        switch (target) {
            case Target.Android : buildAndroid (isInstall);
            case Target.Web : buildWeb ();
            default: throw "Unsupported platform";
        }
    }
}