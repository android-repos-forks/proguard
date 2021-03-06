#
# This ProGuard configuration file illustrates how to process ProGuard
# (including its main application, its GUI, its Ant task, and its WTK plugin),
# and the ReTrace tool, all in one go.
# Configuration files for typical applications will be very similar.
# Usage:
#     java -jar proguard.jar @proguardall.pro
#

-verbose

# Specify the input jars, output jars, and library jars.
# We'll read all jars from the lib directory, process them, and write the
# processed jars to a new out directory.

-injars  ../../lib
-outjars out

# You may have to adapt the paths below.

# Before Java 9, the runtime classes were packaged in a single jar file.
#-libraryjars <java.home>/lib/rt.jar

# As of Java 9, the runtime classes are packaged in modular jmod files.
-libraryjars <java.home>/jmods/java.base.jmod   (!**.jar;!module-info.class)
-libraryjars <java.home>/jmods/java.desktop.jmod(!**.jar;!module-info.class)

-libraryjars /usr/local/java/ant/lib/ant.jar
-libraryjars /usr/local/java/wtk2.5.2/wtklib/kenv.zip

-libraryjars /usr/local/java/gradle-4.2.1/lib/plugins/gradle-plugins-4.2.1.jar
-libraryjars /usr/local/java/gradle-4.2.1/lib/gradle-base-services-4.2.1.jar
-libraryjars /usr/local/java/gradle-4.2.1/lib/gradle-logging-4.2.1.jar
-libraryjars /usr/local/java/gradle-4.2.1/lib/gradle-core-api-4.2.1.jar
-libraryjars /usr/local/java/gradle-4.2.1/lib/gradle-core-4.2.1.jar
-libraryjars /usr/local/java/gradle-4.2.1/lib/groovy-all-2.4.12.jar

-libraryjars <user.home>/.gradle/caches/modules-2/files-2.1/com.android.tools.build/builder/3.0.0/36884960f350cb29f1c2c93107f4fa27f4e7444e/builder-3.0.0.jar
-libraryjars <user.home>/.gradle/caches/modules-2/files-2.1/com.android.tools.build/gradle-api/3.0.0/e98ade5c308a99980d2a61f4ce1d9286df0105e3/gradle-api-3.0.0.jar
-libraryjars <user.home>/.gradle/caches/modules-2/files-2.1/com.android.tools.build/builder-model/3.0.0/a86b254415fded5297e1d849fa1884dfdf62ff42/builder-model-3.0.0.jar
-libraryjars <user.home>/.gradle/caches/modules-2/files-2.1/com.android.tools.build/gradle/3.0.0/2356ee8e98b68c53dafc28898e7034080e5c91aa/gradle-3.0.0.jar
-libraryjars <user.home>/.gradle/caches/modules-2/files-2.1/com.android.tools.build/gradle-core/3.0.0/b4b02fa623c5a618e68478d9a4a67e1e87c023c6/gradle-core-3.0.0.jar(!com/android/build/gradle/tasks/TestModuleProGuardTask*.class)
-libraryjars <user.home>/.gradle/caches/modules-2/files-2.1/com.google.guava/guava-jdk5/17.0/463f8378feba44df7ba7cd9272d01837dad62b36/guava-jdk5-17.0.jar
-libraryjars <user.home>/.gradle/caches/modules-2/files-2.1/org.slf4j/slf4j-api/1.7.6/562424e36df3d2327e8e9301a76027fca17d54ea/slf4j-api-1.7.6.jar

# Don't print notes about reflection in injected code.

-dontnote proguard.configuration.ConfigurationLogger

# Don't print warnings about GSON dependencies.

-dontwarn com.google.gson.**

# Preserve injected GSON utility classes and their members.

-keep,allowobfuscation class proguard.optimize.gson._*
-keepclassmembers class proguard.optimize.gson._* {
    *;
}

# Obfuscate class strings of injected GSON utility classes.

-adaptclassstrings proguard.optimize.gson.**

# Allow methods with the same signature, except for the return type,
# to get the same obfuscation name.

-overloadaggressively

# Put all obfuscated classes into the nameless root package.

-repackageclasses ''

# Adapt the names and contents of the resource files.

-adaptresourcefilenames    **.properties,**.gif,**.jpg
-adaptresourcefilecontents proguard/ant/task.properties

# The main entry points.

-keep public class proguard.ProGuard {
    public static void main(java.lang.String[]);
}

-keep public class proguard.gui.ProGuardGUI {
    public static void main(java.lang.String[]);
}

-keep public class proguard.retrace.ReTrace {
    public static void main(java.lang.String[]);
}

# If we have ant.jar, we can properly process the Ant task.

-keep,allowobfuscation class proguard.ant.*
-keepclassmembers public class proguard.ant.* {
    <init>(org.apache.tools.ant.Project);
    public void set*(***);
    public void add*(***);
}

# If we have the Gradle jars, we can properly process the Gradle task.

-keep public class proguard.gradle.* {
    public *;
}

# If we have kenv.zip, we can process the J2ME WTK plugin.

-keep public class proguard.wtk.ProGuardObfuscator
