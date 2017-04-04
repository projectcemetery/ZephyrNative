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
    public function run () {
        try {
            var workPath = params[0];            
            var activityText = FileUtil.getTemplate ("ActivityText.java");
            Sys.setCwd (workPath);
            var project = ProjectSettings.load (ProjectSettings.projectNameDef);
            var proc = new Process ("haxe", [ProjectSettings.androidHxmlName]);
            var code = proc.exitCode (true);
            if (code != 0) {
                trace (proc.stderr.readLine());
            }

            var activityName = project.getActivityName ();
            var text = activityText.replace (ProjectSettings.activityNameParam, activityName);
            text = text.replace (ProjectSettings.projectNameParam, project.settings.name);
            text = text.replace (ProjectSettings.packageNameParam, project.settings.packageName);

            var path = Path.join ([workPath,"build", "android", "src", "main", "java", "src" ,"zephyr", '${activityName}.java']);
            File.saveContent (path, text);
        } catch (e : Dynamic) {
            trace (e);
            trace ("Can't build project");
        }
    }
}