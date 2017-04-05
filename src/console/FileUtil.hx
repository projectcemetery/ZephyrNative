
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
     *  Copy all files from directory recursive
     */
    public static function copyFromDir (src : String, dest : String) : Void {
        if (Sys.systemName () == "Windows") {
            var fullSrc = FileSystem.absolutePath (src);
            var fullDest = FileSystem.absolutePath (dest);
            
            if (!FileSystem.exists (fullSrc)) throw "Source directory not exists";
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
            var proc = new Process ("cp", ["-a", ".", dest]);
            var code = proc.exitCode (true);
            if (code != 0) {
                Logger.info (proc.stderr.readLine ());
            }
            Sys.setCwd (oldPath);
        }
    }

    /**
     *  Return template text
     *  @param name - 
     */
    public static function getTemplate (name : String) : String {
        var path = Path.join (["templates", name]);
        return File.getContent (path);
    }
}