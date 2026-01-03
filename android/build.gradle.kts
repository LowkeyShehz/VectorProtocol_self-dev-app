allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    afterEvaluate {
        if (project.name == "isar_flutter_libs") {
             val android = project.extensions.findByName("android")
             if (android != null) {
                 try {
                     val getNamespace = android.javaClass.getMethod("getNamespace")
                     if (getNamespace.invoke(android) == null) {
                         val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                         setNamespace.invoke(android, "dev.isar.isar_flutter_libs")
                     }

                     // Force compileSdk to 34 to handle lStar resource errors
                     try {
                         val setCompileSdkVersion = android.javaClass.getMethod("setCompileSdkVersion", Int::class.javaPrimitiveType)
                         setCompileSdkVersion.invoke(android, 34)
                     } catch (e: Exception) {
                         try {
                             val setCompileSdkVersion = android.javaClass.getMethod("setCompileSdkVersion", Int::class.java)
                             setCompileSdkVersion.invoke(android, 34)
                         } catch (e2: Exception) {
                              println("Level Up Build: Failed to force compileSdk: ${e2.message}")
                         }
                     }
                 } catch (e: Exception) {
                     // Ignore
                 }
             }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}
