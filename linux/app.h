#ifndef FLUTTER_MY_APPLICATION_H_
#define FLUTTER_MY_APPLICATION_H_

#include <gtk/gtk.h>

#define APP_TITLE "Discord RPC Control"

G_DECLARE_FINAL_TYPE(App, app, APP, MAIN_WINDOW,
                     GtkApplication)

/**
 * my_application_new:
 *
 * Creates a new Flutter-based application.
 *
 * Returns: a new #MyApplication.
 */
App* app_new();

#endif  // FLUTTER_MY_APPLICATION_H_
