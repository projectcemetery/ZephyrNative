/*
 * Copyright (c) 2017 Grabli66
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package console.commands;

import tink.cli.*;
import sys.FileSystem;
import haxe.io.Path;
import sys.io.File;
using StringTools;

/**
 *  Command for create new project
 */
class CreateNewProject {

    /**
     *  Path of project
     */
    var workDir : String;

    /**
     *  Params for command
     */
    var params : Rest<String>;


    /**
     *  Project settings
     */
    var project : ProjectSettings;

    /**
     *  Write project     
     */
    function writeProjectFile () {
        var path = Path.join ([workDir, ProjectSettings.projectNameDef]);
        project.save (path);
    }       

    /**
     *  Write Main.hx
     *  @param workPath - 
     */
    function writeMain () {
        var packPaths = project.settings.packageName.split (".");

        var path = [workDir, "src"].concat (packPaths);        
        var packagePath = Path.join (path);
        FileSystem.createDirectory (packagePath);        
        var filePath = Path.join ([packagePath, '${project.settings.name}.hx']); 

        var mainText = FileUtil.getTemplate ("MainText.hx");
        var text = mainText.replace (ProjectSettings.packageNameParam, project.settings.packageName);
        text = text.replace (ProjectSettings.projectNameParam, project.settings.name);
        File.saveContent (filePath, text);
    }

    /**
     *  Constructor
     */
    public function new (params : Rest<String>) {
        if (params.length < 2) throw "Wrong parameters";
        this.params = params;

        var name = params[0];
        name = name.replace (" ", "");
        var upper = name.charAt(0).toUpperCase ();
        name = upper + name.substr (1, name.length);

        // TODO: validate package
        var packageName = "com.zephyr";
        if (params.length >= 3) {
            packageName = params[1];
        }        

        this.project = new ProjectSettings (name, packageName);
    }

    /**
     *  Run command
     */
    public function run () {
        workDir = Path.join ([FileUtil.workDir, project.settings.name]);

        if (FileSystem.exists (workDir)) throw 'Folder ${workDir} already exists';
        Logger.infoStart ('Creating directory ${workDir}');
        FileSystem.createDirectory (workDir);            
        Logger.endInfoSuccess ();

        var srcDir = Path.join ([ FileUtil.libDir, "bundle", "project" ]);
        var destDir = workDir;
        Logger.infoStart ('Coping project files from ${srcDir} to ${destDir}');
        FileUtil.copyFromDir (srcDir, destDir);
        Logger.endInfoSuccess ();

        // Write project file
        Logger.infoStart ("Writing project settings");
        writeProjectFile ();
        Logger.endInfoSuccess ();

        // Write Application
        Logger.infoStart ('Write ${project.settings.name}.hx');
        writeMain ();
        Logger.endInfoSuccess ();                         

        Logger.success ("Project created");
    }
}