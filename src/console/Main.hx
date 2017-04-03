package console;

import tink.Cli;

/**
 *  Console util for manage project
 */
class Main {

    /**
     *  Entry point
     *  @param args - 
     */
    public static function main () {
        Cli.process(Sys.args(), new ConsoleCommand()).handle(Cli.exit);
    }
}