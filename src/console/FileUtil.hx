
package console;

import sys.FileSystem;
import haxe.io.Path;
import sys.io.File;
import sys.io.Process;

/**
 *  Util for working with files
 */
class FileUtil {

    /**
     *  Directory of lib
     */
    public static var libDir (default, null) : String;

    /**
     *  Directory of project
     */
    public static var workDir (default, null) : String;

    /**
     *  On class create
     */
    static function __init__ () {
        libDir = Sys.getCwd ();
        var args = Sys.args ();
        workDir = args[args.length - 1];
    }

    /**
     *  Copy all files from directory recursive
     */
    public static function copyFromDir (src : String, dest : String) : Void {
        if (Sys.systemName () == "Windows") {
            var fullSrc = FileSystem.absolutePath (src);
            var fullDest = FileSystem.absolutePath (dest);
            
            if (!FileSystem.exists (fullSrc)) throw 'Source directory ${fullSrc} not exists';
            if (!FileSystem.exists (fullDest)) FileSystem.createDirectory (fullDest);

            var allFiles = FileSystem.readDirectory (fullSrc);        
            for (file in allFiles) {            
                var srcPath = Path.join ([ fullSrc, file ]);
                var dstPath = Path.join ([ fullDest, file ]);            
                if (FileSystem.isDirectory (srcPath)) {
                    copyFromDir (srcPath, dstPath);
                } else {
                    File.copy (srcPath, dstPath);
                }
            }
        } else {
            var oldPath = Sys.getCwd ();
            Sys.setCwd (src);
            ProcessHelper.launch ("cp", ["-a", ".", dest]);
            Sys.setCwd (oldPath);
        }
    }

    /**
     *  Return template text
     *  @param name - 
     */
    public static function getTemplate (templateName : String) : String {
        var path = Path.join ([libDir, "bundle", "templates", templateName]);
        return File.getContent (path);
    }
}