package ${packageName};

import zephyr.app.IApplication;
import zephyr.app.ApplicationContext;

/**
 *  Entry point for Zephyr Application
 */
@:keep
class ${projectName} implements IApplication {

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