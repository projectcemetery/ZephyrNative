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

/**
 *  Command for create new project
 */
class CreateNewProject {

    /**
     *  Params for command
     */
    var params : Rest<String>;

    /**
     *  Constructor
     */
    public function new (params : Rest<String>) {
        this.params = params;
    }

    /**
     *  Run command
     */
    public function run () {
        // Создать рабочий каталог        
        // Получить каталог библиотеки
        // Скопировать из Bundle в рабочий каталог: native
        // Поправить манифест: название, activity
        // Сгенерировать файл Activity от ZephyrActivity        

        try {
            var name = params[0];
            var launchDir = params[params.length - 1];
            var workDir = Path.join ([ launchDir, name ]);
            var libDir = FileSystem.fullPath (".");
            if (FileSystem.exists (workDir)) throw 'Folder ${workDir} already exists';
            FileSystem.createDirectory (workDir);            

            var srcDir = Path.join ([ libDir, "bundle" ]);
            var destDir = Path.join ([ workDir, "bundle" ]);            
            FileUtil.copyDir (srcDir, destDir);


            trace ("Project created");
        } catch (e : Dynamic) {
            trace (e);
            trace ("Can't create new project");
        }        
    }
}