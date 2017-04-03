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
     *  Fix AndroidManifest.xml
     */
    function fixManifest (path : String) {        
        var content = File.getContent (path);
        content = content.replace ("${packageName}", 'com.zephyrnative.${name}');
        content = content.replace ("${projectName}", name);
        File.saveContent (path, content);
    }

    /**
     *  Fix android.hxml
     *  @param path - 
     */
    function fixAndroidHxml (workPath : String, libPath : String) {
        var androidHxmlPath = Path.join ([ workPath, "android.hxml" ]);
        var stringBuff = new StringBuf ();
        stringBuff.add (File.getContent (androidHxmlPath));
        var path = Path.join ([ libPath, "libs", "android.jar" ]);
        stringBuff.add ("\n");
        stringBuff.add ('-java-lib ${path}');
        stringBuff.add ("\r\n");
        var data = stringBuff.toString ();
        File.saveContent (androidHxmlPath, data);        
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
            FileSystem.createDirectory (workDir);            

            var srcDir = Path.join ([ libDir, "bundle" ]);
            var destDir = workDir;           
            FileUtil.copyDir (srcDir, destDir);

            // Fix manifest
            var manifestPath = Path.join ([ workDir, "build", "android", "src", "main", "AndroidManifest.xml" ]);
            fixManifest (manifestPath);

            // Add java lib to android.hxml            
            fixAndroidHxml (workDir, libDir);            

            trace ("Project created");
        } catch (e : Dynamic) {
            trace (e);
            trace ("Can't create new project");
        }        
    }
}