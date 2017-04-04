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
     *  Params for command
     */
    var params : Rest<String>;

    /**
     *  Project name
     */
    var name : String;

    /**
     *  Project package name
     */
    var packageName : String = "zephyr";

    /**
     *  android.hxml template
     */
    var androidHxml : String = 
"-cp src
-D analyzer-optimize
-D no-compilation
-dce full
-lib ZephyrNative
-java ./out
${packageName}
${javaLibs}";

    var mainText : String = 
"package ${packageName};

import zephyr.app.IApplication;
import zephyr.app.ApplicationContext;

/**
 *  Entry point for Zephyr Application
 */
@:keep
class Main implements IApplication {

    /**
     *  Call when application ready
     *  @param context
     */
    public function onReady (context : ApplicationContext) : Void {
        // Register controller: 
        // context.registerController (MyControllerClass);
        // Navigate to controller:
        // context.navigate (MyControllerClass);
    }
}
";

    /**
     *  Fix AndroidManifest.xml
     */
    function fixManifest (path : String) {        
        var content = File.getContent (path);
        content = content.replace ("${packageName}", packageName);
        content = content.replace ("${projectName}", name);
        File.saveContent (path, content);
    }

    /**
     *  Fix android.hxml
     *  @param path - 
     */
    function writeAndroidHxml (workPath : String, libPath : String) {
        var androidHxmlPath = Path.join ([ workPath, "android.hxml" ]);
        var libData = Path.join ([ libPath, "libs", "android.jar" ]);
        androidHxml = androidHxml.replace ("${packageName}", '${packageName}.Main');
        androidHxml = androidHxml.replace ("${javaLibs}", '-java-lib ${libData}');        

        File.saveContent (androidHxmlPath, androidHxml);
    }

    /**
     *  Write Main.hx
     *  @param workPath - 
     */
    function writeMain (workPath : String) {
        var packPaths = packageName.split (".");

        var path = [workPath, "src"].concat (packPaths);        
        var packagePath = Path.join (path);
        FileSystem.createDirectory (packagePath);        
        var filePath = Path.join ([packagePath, "Main.hx"]);        
        var text = mainText.replace ("${packageName}", packageName);
        File.saveContent (filePath, text);
    }

    /**
     *  Constructor
     */
    public function new (params : Rest<String>) {
        if (params.length < 1) throw "Wrong parameters";
        this.params = params;
        name = params[0];
        name = name.replace (" ", "");
        var upper = name.charAt(0).toUpperCase ();
        name = upper + name.substr (1, name.length);        
    }

    /**
     *  Run command
     */
    public function run () {
        try {            
            var launchDir = params[params.length - 1];
            var workDir = Path.join ([ launchDir, name ]);
            var libDir = FileSystem.fullPath (".");
            if (FileSystem.exists (workDir)) throw 'Folder ${workDir} already exists';
            trace ('Creating directory ${workDir}');
            FileSystem.createDirectory (workDir);            

            var srcDir = Path.join ([ libDir, "bundle" ]);
            var destDir = workDir;
            trace ('Coping bundle files from ${srcDir} to ${destDir}');
            FileUtil.copyDir (srcDir, destDir);

            // Fix manifest
            trace ("Fixing android manifest");
            var manifestPath = Path.join ([ workDir, "build", "android", "src", "main", "AndroidManifest.xml" ]);
            fixManifest (manifestPath);

            // Add java lib to android.hxml
            trace ("Writing android.hxml");
            writeAndroidHxml (workDir, libDir);

            // Write Main.hx
            trace ("Write Main.hx");
            writeMain (workDir);

            trace ("Project created");
        } catch (e : Dynamic) {
            trace (e);
            trace ("Can't create new project");
        }        
    }
}