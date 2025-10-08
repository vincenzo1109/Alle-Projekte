plugins {
    id("com.android.application") apply false
    id("org.jetbrains.kotlin.android") apply false  // keine Version hier!
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Optional: vereinheitlicht die Build-Ausgabe in /build statt in jedem Modul separat
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
