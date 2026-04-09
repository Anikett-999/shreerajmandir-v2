Got dependencies!
39 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
Launching lib\main.dart on M2006C3MII in debug mode...
lib/presentation/widgets/app_drawer.dart:28:61: Error: Member not found: 'primaryRed'.
            decoration: const BoxDecoration(color: AppTheme.primaryRed),
                                                            ^^^^^^^^^^
lib/presentation/widgets/app_drawer.dart:45:66: Error: Member not found: 'primaryRed'.
            leading: const Icon(Icons.table_bar, color: AppTheme.primaryRed),
                                                                 ^^^^^^^^^^
lib/presentation/widgets/app_drawer.dart:57:69: Error: Member not found: 'primaryRed'.
            leading: const Icon(Icons.receipt_long, color: AppTheme.primaryRed),
                                                                    ^^^^^^^^^^
lib/presentation/widgets/app_drawer.dart:69:63: Error: Member not found: 'primaryRed'.
            leading: const Icon(Icons.person, color: AppTheme.primaryRed),
                                                              ^^^^^^^^^^
lib/presentation/widgets/app_drawer.dart:81:62: Error: Member not found: 'primaryRed'.
            leading: const Icon(Icons.print, color: AppTheme.primaryRed),
                                                             ^^^^^^^^^^
lib/presentation/widgets/app_drawer.dart:93:65: Error: Member not found: 'primaryRed'.
            leading: const Icon(Icons.settings, color: AppTheme.primaryRed),
                                                                ^^^^^^^^^^
lib/presentation/widgets/app_drawer.dart:109:63: Error: Member not found: 'primaryRed'.
            leading: const Icon(Icons.logout, color: AppTheme.primaryRed),
                                                              ^^^^^^^^^^
lib/presentation/widgets/app_drawer.dart:110:74: Error: Member not found: 'primaryRed'.
            title: const Text('Logout', style: TextStyle(color: AppTheme.primaryRed, fontWeight: FontWeight.bold)),
                                                                         ^^^^^^^^^^
lib/presentation/screens/billing_screen.dart:155:81: Error: Member not found: 'occupiedOrange'.
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.occupiedOrange, foregroundColor: Colors.white),
                                                                                ^^^^^^^^^^^^^^
lib/presentation/screens/billing_screen.dart:178:37: Error: Member not found: 'billingBlue'.
          color: isTotal ? AppTheme.billingBlue : null,
                                    ^^^^^^^^^^^
lib/presentation/screens/global/settings_screen.dart:33:13: Error: No named parameter with the name 'onPressed'.
            onPressed: () {},
            ^^^^^^^^^
../../flutter/packages/flutter/lib/src/material/list_tile.dart:390:9: Context: Found this candidate, but the arguments don't match.
  const ListTile({
        ^^^^^^^^
lib/presentation/screens/global/settings_screen.dart:45:13: Error: No named parameter with the name 'onPressed'.
            onPressed: () {},
            ^^^^^^^^^
../../flutter/packages/flutter/lib/src/material/list_tile.dart:390:9: Context: Found this candidate, but the arguments don't match.
  const ListTile({
        ^^^^^^^^
lib/presentation/widgets/global/base_widgets.dart:43:7: Error: No named parameter with the name 'padding'.
      padding: const EdgeInsets.all(24.0),
      ^^^^^^^
../../flutter/packages/flutter/lib/src/widgets/basic.dart:2552:9: Context: Found this candidate, but the arguments don't match.
  const Center({super.key, super.widthFactor, super.heightFactor, super.child});
        ^^^^^^
lib/presentation/widgets/global/base_widgets.dart:90:7: Error: No named parameter with the name 'padding'.
  const Center({super.key, super.widthFactor, super.heightFactor, super.child});
        ^^^^^^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:compileFlutterBuildDebug'.
> Process 'command 'C:\Users\anike\flutter\bin\flutter.bat'' finished with non-zero exit value 1

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.
> Get more help at https://help.gradle.org.

BUILD FAILED in 51s
Running Gradle task 'assembleDebug'...                             52.2s
Error: Gradle task assembleDebug failed with exit code 1
PS C:\Users\anike\Downloads\ShreeRajmandirV2> flutter pub get



Resolving dependencies... 
Downloading packages... 
  _fe_analyzer_shared 85.0.0 (98.0.0 available)
  _flutterfire_internals 1.3.59 (1.3.68 available)
  analyzer 7.6.0 (12.0.0 available)
  analyzer_plugin 0.13.4 (0.14.7 available)
  build 2.5.4 (4.0.5 available)
  build_config 1.1.2 (1.3.0 available)
  build_resolvers 2.5.4 (3.0.4 available)
  build_runner 2.5.4 (2.13.1 available)
  build_runner_core 9.1.2 (9.3.2 available)
  cloud_firestore 5.6.12 (6.2.0 available)
  cloud_firestore_platform_interface 6.6.12 (7.1.0 available)
  cloud_firestore_web 4.4.12 (5.2.0 available)
  custom_lint_core 0.7.5 (0.8.2 available)
  custom_lint_visitor 1.0.0+7.7.0 (1.0.0+9.0.0 available)
  dart_style 3.1.1 (3.1.8 available)
  fake_cloud_firestore 3.1.0 (4.1.0+1 available)
  firebase_auth 5.7.0 (6.3.0 available)
  firebase_auth_platform_interface 7.7.3 (8.1.8 available)
  firebase_auth_web 5.15.3 (6.1.4 available)
  firebase_core 3.15.2 (4.6.0 available)
  firebase_core_web 2.24.1 (3.5.1 available)
  flutter_riverpod 2.6.1 (3.3.1 available)
  freezed 2.5.8 (3.2.5 available)
  freezed_annotation 2.4.4 (3.1.0 available)
  google_fonts 6.3.3 (8.0.2 available)
  intl 0.19.0 (0.20.2 available)
  json_annotation 4.9.0 (4.11.0 available)
  json_serializable 6.9.5 (6.13.1 available)
  meta 1.17.0 (1.18.2 available)
  path_provider_android 2.2.23 (2.3.0 available)
  riverpod 2.6.1 (3.2.1 available)
  riverpod_analyzer_utils 0.5.9 (0.5.10 available)
  riverpod_annotation 2.6.1 (4.0.2 available)
  riverpod_generator 2.6.4 (4.0.3 available)
  rx 0.4.0 (0.5.0 available)
  source_gen 2.0.0 (4.2.2 available)
  source_helper 1.3.7 (1.3.11 available)
  test_api 0.7.10 (0.7.11 available)
  vector_math 2.2.0 (2.3.0 available)
Got dependencies!
39 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
PS C:\Users\anike\Downloads\ShreeRajmandirV2> flutter run    
Launching lib\main.dart on M2006C3MII in debug mode...
Note: Some input files use or override a deprecated API.
Note: Recompile with -Xlint:deprecation for details.
e: Daemon compilation failed: null
java.lang.Exception
        at org.jetbrains.kotlin.daemon.common.CompileService$CallResult$Error.get(CompileService.kt:69)
        at org.jetbrains.kotlin.daemon.common.CompileService$CallResult$Error.get(CompileService.kt:65)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.compileWithDaemon(GradleKotlinCompilerWork.kt:240)
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.compileWithDaemonOrFallbackImpl(GradleKotlinCompilerWork.kt:159)     
        at org.jetbrains.kotlin.compilerRunner.GradleKotlinCompilerWork.run(GradleKotlinCompilerWork.kt:111)
        at org.jetbrains.kotlin.compilerRunner.GradleCompilerRunnerWithWorkers$GradleKotlinCompilerWorkAction.execute(GradleCompilerRunnerWithWorkers.kt:74)
        at org.gradle.workers.internal.DefaultWorkerServer.execute(DefaultWorkerServer.java:63)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1$1.create(NoIsolationWorkerFactory.java:66)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1$1.create(NoIsolationWorkerFactory.java:62)
        at org.gradle.internal.classloader.ClassLoaderUtils.executeInClassloader(ClassLoaderUtils.java:100)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1.lambda$execute$0(NoIsolationWorkerFactory.java:62)
        at org.gradle.workers.internal.AbstractWorker$1.call(AbstractWorker.java:44)
        at org.gradle.workers.internal.AbstractWorker$1.call(AbstractWorker.java:41)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$CallableBuildOperationWorker.execute(DefaultBuildOperationRunner.java:210)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$CallableBuildOperationWorker.execute(DefaultBuildOperationRunner.java:205)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$2.execute(DefaultBuildOperationRunner.java:67)
        at org.gradle.internal.operations.DefaultBuildOperationRunner$2.execute(DefaultBuildOperationRunner.java:60)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.execute(DefaultBuildOperationRunner.java:167)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.execute(DefaultBuildOperationRunner.java:60)
        at org.gradle.internal.operations.DefaultBuildOperationRunner.call(DefaultBuildOperationRunner.java:54)
        at org.gradle.workers.internal.AbstractWorker.executeWrappedInBuildOperation(AbstractWorker.java:41)
        at org.gradle.workers.internal.NoIsolationWorkerFactory$1.execute(NoIsolationWorkerFactory.java:59)
        at org.gradle.workers.internal.DefaultWorkerExecutor.lambda$submitWork$0(DefaultWorkerExecutor.java:174)
        at java.base/java.util.concurrent.FutureTask.run(Unknown Source)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.runExecution(DefaultConditionalExecutionQueue.java:194) 
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.access$700(DefaultConditionalExecutionQueue.java:127)   
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner$1.run(DefaultConditionalExecutionQueue.java:169)        
        at org.gradle.internal.Factories$1.create(Factories.java:31)
        at org.gradle.internal.work.DefaultWorkerLeaseService.withLocks(DefaultWorkerLeaseService.java:263)
        at org.gradle.internal.work.DefaultWorkerLeaseService.runAsWorkerThread(DefaultWorkerLeaseService.java:127)
        at org.gradle.internal.work.DefaultWorkerLeaseService.runAsWorkerThread(DefaultWorkerLeaseService.java:132)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.runBatch(DefaultConditionalExecutionQueue.java:164)
        at org.gradle.internal.work.DefaultConditionalExecutionQueue$ExecutionRunner.run(DefaultConditionalExecutionQueue.java:133)
        at java.base/java.util.concurrent.Executors$RunnableAdapter.call(Unknown Source)
        at java.base/java.util.concurrent.FutureTask.run(Unknown Source)
        at org.gradle.internal.concurrent.ExecutorPolicy$CatchAndRecordFailures.onExecute(ExecutorPolicy.java:64)
        at org.gradle.internal.concurrent.AbstractManagedExecutor$1.run(AbstractManagedExecutor.java:48)
        at java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(Unknown Source)
        at java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(Unknown Source)
        at java.base/java.lang.Thread.run(Unknown Source)
Caused by: java.lang.AssertionError: java.lang.Exception: Could not close incremental caches in C:\Users\anike\Downloads\ShreeRajmandirV2\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin: class-fq-name-to-source.tab, source-to-classes.tab, internal-name-to-source.tab
        at org.jetbrains.kotlin.com.google.common.io.Closer.close(Closer.java:218)
        at org.jetbrains.kotlin.incremental.IncrementalCachesManager.close(IncrementalCachesManager.kt:55)
        at kotlin.io.CloseableKt.closeFinally(Closeable.kt:46)
        at org.jetbrains.kotlin.incremental.IncrementalCompilerRunner.compileNonIncrementally(IncrementalCompilerRunner.kt:293)
        at org.jetbrains.kotlin.incremental.IncrementalCompilerRunner.compile(IncrementalCompilerRunner.kt:128)
        at org.jetbrains.kotlin.daemon.CompileServiceImplBase.execIncrementalCompiler(CompileServiceImpl.kt:684)
        at org.jetbrains.kotlin.daemon.CompileServiceImplBase.access$execIncrementalCompiler(CompileServiceImpl.kt:94)
        at org.jetbrains.kotlin.daemon.CompileServiceImpl.compile(CompileServiceImpl.kt:1810)
        at java.base/jdk.internal.reflect.DirectMethodHandleAccessor.invoke(Unknown Source)
        at java.base/java.lang.reflect.Method.invoke(Unknown Source)
        at java.rmi/sun.rmi.server.UnicastServerRef.dispatch(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport$1.run(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport$1.run(Unknown Source)
        at java.base/java.security.AccessController.doPrivileged(Unknown Source)
        at java.rmi/sun.rmi.transport.Transport.serviceCall(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport.handleMessages(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run0(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.lambda$run$0(Unknown Source)
        at java.base/java.security.AccessController.doPrivileged(Unknown Source)
        at java.rmi/sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run(Unknown Source)
        ... 3 more
Caused by: java.lang.Exception: Could not close incremental caches in C:\Users\anike\Downloads\ShreeRajmandirV2\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\jvm\kotlin: class-fq-name-to-source.tab, source-to-classes.tab, internal-name-to-source.tab
        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
        at org.jetbrains.kotlin.com.google.common.io.Closer.close(Closer.java:205)
        ... 22 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: E:\flutter_pub_cache\hosted\pub.dev\shared_preferences_android-2.4.23\android\src\main\kotlin\io\flutter\plugins\sharedpreferences\MessagesAsync.g.kt and C:\Users\anike\Downloads\ShreeRajmandirV2\android.
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)      
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:33)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: E:\flutter_pub_cache\hosted\pub.dev\shared_preferences_android-2.4.23\android\src\main\kotlin\io\flutter\plugins\sharedpreferences\MessagesAsync.g.kt and C:\Users\anike\Downloads\ShreeRajmandirV2\android.
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)      
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)
                at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: E:\flutter_pub_cache\hosted\pub.dev\shared_preferences_android-2.4.23\android\src\main\kotlin\io\flutter\plugins\sharedpreferences\MessagesAsync.g.kt and C:\Users\anike\Downloads\ShreeRajmandirV2\android.
                at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:33)
                at org.jetbrains.kotlin.incremental.storage.FileDescriptor.save(FileToPathConverter.kt:30)
                at org.jetbrains.kotlin.incremental.storage.AppendableCollectionExternalizer.save(LazyStorage.kt:151)
                at org.jetbrains.kotlin.incremental.storage.AppendableCollectionExternalizer.save(LazyStorage.kt:142)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                ... 24 more
        Suppressed: java.lang.Exception: Could not close incremental caches in C:\Users\anike\Downloads\ShreeRajmandirV2\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\lookups: id-to-file.tab, file-to-id.tab
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:95)
                at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.close(BasicMapsOwner.kt:53)
                at org.jetbrains.kotlin.incremental.LookupStorage.close(LookupStorage.kt:155)
                ... 23 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: E:\flutter_pub_cache\hosted\pub.dev\shared_preferences_android-2.4.23\android\src\main\kotlin\io\flutter\plugins\sharedpreferences\MessagesAsync.g.kt and C:\Users\anike\Downloads\ShreeRajmandirV2\android.
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.LegacyFileExternalizer.save(IdToFileMap.kt:51)
                        at org.jetbrains.kotlin.incremental.storage.LegacyFileExternalizer.save(IdToFileMap.kt:48)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:447)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: E:\flutter_pub_cache\hosted\pub.dev\shared_preferences_android-2.4.23\android\src\main\kotlin\io\flutter\plugins\sharedpreferences\MessagesAsync.g.kt and C:\Users\anike\Downloads\ShreeRajmandirV2\android.
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)       
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                        at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.PersistentStorageWrapper.close(PersistentStorage.kt:124)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 25 more
        Suppressed: java.lang.Exception: Could not close incremental caches in C:\Users\anike\Downloads\ShreeRajmandirV2\build\shared_preferences_android\kotlin\compileDebugKotlin\cacheable\caches-jvm\inputs: source-to-output.tab
                ... 25 more
                Suppressed: java.lang.IllegalArgumentException: this and base files have different roots: E:\flutter_pub_cache\hosted\pub.dev\shared_preferences_android-2.4.23\android\src\main\kotlin\io\flutter\plugins\sharedpreferences\MessagesAsync.g.kt and C:\Users\anike\Downloads\ShreeRajmandirV2\android.
                        at kotlin.io.FilesKt__UtilsKt.toRelativeString(Utils.kt:117)
                        at kotlin.io.FilesKt__UtilsKt.relativeTo(Utils.kt:128)
                        at org.jetbrains.kotlin.incremental.storage.RelocatableFileToPathConverter.toPath(RelocatableFileToPathConverter.kt:24)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:50)
                        at org.jetbrains.kotlin.incremental.storage.FileDescriptor.getHashCode(FileToPathConverter.kt:30)
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.hashKey(LinkedCustomHashMap.java:109)       
                        at org.jetbrains.kotlin.com.intellij.util.containers.LinkedCustomHashMap.remove(LinkedCustomHashMap.java:153)
                        at org.jetbrains.kotlin.com.intellij.util.containers.SLRUMap.remove(SLRUMap.java:89)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.flushAppendCache(PersistentMapImpl.java:1007)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.doPut(PersistentMapImpl.java:455)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentMapImpl.put(PersistentMapImpl.java:426)
                        at org.jetbrains.kotlin.com.intellij.util.io.PersistentHashMap.put(PersistentHashMap.java:106)
                        at org.jetbrains.kotlin.incremental.storage.LazyStorage.set(LazyStorage.kt:80)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.applyChanges(InMemoryStorage.kt:108)
                        at org.jetbrains.kotlin.incremental.storage.AppendableInMemoryStorage.applyChanges(InMemoryStorage.kt:179)
                        at org.jetbrains.kotlin.incremental.storage.InMemoryStorage.close(InMemoryStorage.kt:136)
                        at org.jetbrains.kotlin.incremental.storage.AppendableSetBasicMap.close(BasicMap.kt:157)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner$close$1.invoke(BasicMapsOwner.kt:53)
                        at org.jetbrains.kotlin.incremental.storage.BasicMapsOwner.forEachMapSafe(BasicMapsOwner.kt:87)
                        ... 24 more

Running Gradle task 'assembleDebug'...                            130.6s
√ Built build\app\outputs\flutter-apk\app-debug.apk
Installing build\app\outputs\flutter-apk\app-debug.apk...          19.8s
D/FlutterJNI(25328): Beginning load of flutter...
D/FlutterJNI(25328): flutter (null) was loaded normally!
I/flutter (25328): [IMPORTANT:flutter/shell/platform/android/android_context_gl_impeller.cc(104)] Using the Impeller rendering backend (OpenGLES).
D/FlutterRenderer(25328): Width is zero. 0,0
D/FlutterRenderer(25328): Width is zero. 0,0
D/FlutterJNI(25328): Sending viewport metrics to the engine.
Syncing files to device M2006C3MII...                              238ms

Flutter run key commands.
r Hot reload.
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

A Dart VM Service on M2006C3MII is available at: http://127.0.0.1:60630/XA9h_YV0jUA=/
The Flutter DevTools debugger and profiler on M2006C3MII is available at:
http://127.0.0.1:60630/XA9h_YV0jUA=/devtools/?uri=ws://127.0.0.1:60630/XA9h_YV0jUA=/ws
D/ViewRootImpl(25328): setSurfaceViewCreated, created:true
D/Surface (25328): Surface::disconnect(this=0xbcdcf000,api=1)
D/Surface (25328): Surface::connect(this=0xbcdcf000,api=1)
W/Looper  (25328): Slow Looper main: Long Msg: seq=7 plan=19:31:00.938  late=3475ms wall=3836ms running=0ms h=android.view.Choreographer$FrameHandler c=android.view.Choreographer$FrameDisplayEventReceiver
W/Looper  (25328): Slow Looper main: doFrame is 3475ms late because of 5 msg, msg 1 took 2190ms (seq=2 late=1ms h=android.app.ActivityThread$H w=110), msg 2 took 2954ms (seq=3 late=1920ms h=android.app.ActivityThread$H w=159)
I/Choreographer(25328): Skipped 226 frames!  The application may be doing too much work on its main thread.
W/Looper  (25328): Slow Looper main: doFrame is 3776ms late because of 7 msg, msg 1 took 3836ms (seq=7 late=3475ms h=android.view.Choreographer$FrameHandler c=android.view.Choreographer$FrameDisplayEventReceiver)
D/FlutterJNI(25328): Sending viewport metrics to the engine.
I/eerajmandir.po(25328): ProcessProfilingInfo new_methods=2151 is saved saved_to_disk=1 resolve_classes_delay=8000
I/Choreographer(25328): Skipped 427 frames!  The application may be doing too much work on its main thread.
W/Looper  (25328): Slow Looper main: doFrame is 7125ms late
D/ProfileInstaller(25328): Installing profile for com.shreerajmandir.pos
I/Choreographer(25328): Skipped 129 frames!  The application may be doing too much work on its main thread.
I/OpenGLRenderer(25328): Davey! duration=2288ms; Flags=1, IntendedVsync=51929869467958, Vsync=51932019468001, OldestInputEvent=9223372036854775807, NewestInputEvent=0, HandleInputStart=51932034901402, AnimationStart=51932034997941, PerformTraversalsStart=51932035007864, DrawStart=51932053454787, SyncQueued=51932059650710, SyncStart=51932070048633, IssueDrawCommandsStart=51932070497172, SwapBuffers=51932165663556, FrameCompleted=51932168308402, DequeueBufferDuration=0, QueueBufferDuration=1491000,
W/Looper  (25328): Slow Looper main: doFrame is 2165ms late because of 14 msg, msg 10 took 320ms (seq=39 late=3757ms h=android.os.Handler c=io.flutter.embedding.engine.dart.DartMessenger$$ExternalSyntheticLambda0)
W/InputEventReceiver(25328): App Input: Dispatching InputEvent took 110ms in main thread! (MotionEvent: event_seq=0, seq=194121, action=ACTION_DOWN)
I/Choreographer(25328): Skipped 40 frames!  The application may be doing too much work on its main thread.
W/Looper  (25328): Slow Looper main: doFrame is 681ms late because of 1 msg
I/AssistStructure(25328): Flattened final assist data: 528 bytes, containing 1 windows, 3 views
D/FlutterJNI(25328): Sending viewport metrics to the engine.
W/eerajmandir.po(25328): Accessing hidden method Landroid/view/View;->getViewRootImpl()Landroid/view/ViewRootImpl; (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden field Landroid/view/View$AttachInfo;->mVisibleInsets:Landroid/graphics/Rect; (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden field Landroid/view/ViewRootImpl;->mAttachInfo:Landroid/view/View$AttachInfo; (greylist, reflection, allowed)
I/AssistStructure(25328): Flattened final assist data: 512 bytes, containing 1 windows, 3 views
I/Choreographer(25328): Skipped 47 frames!  The application may be doing too much work on its main thread.
W/Looper  (25328): Slow Looper main: doFrame is 786ms late because of 7 msg
I/AssistStructure(25328): Flattened final assist data: 560 bytes, containing 1 windows, 3 views
D/ForceDarkHelper(25328): updateByCheckExcludeList: pkg: com.shreerajmandir.pos activity: com.shreerajmandir.pos.MainActivity@5c9d05b
E/SpannableStringBuilder(25328): SPAN_EXCLUSIVE_EXCLUSIVE spans cannot have a zero length
E/SpannableStringBuilder(25328): SPAN_EXCLUSIVE_EXCLUSIVE spans cannot have a zero length
I/AssistStructure(25328): Flattened final assist data: 512 bytes, containing 1 windows, 3 views
I/FirebaseAuth(25328): Logging in as Waiter@test.com with empty reCAPTCHA token
D/NetworkSecurityConfig(25328): No Network Security Config specified, using platform default
W/System  (25328): Ignoring header X-Firebase-Locale because its value was null.
D/FlutterJNI(25328): Sending viewport metrics to the engine.
I/System.out(25328): [okhttp]:check permission begin!
I/eerajmandir.po(25328): The ClassLoaderContext is a special shared library.
I/System.out(25328): [okhttp]:not MMS!
I/System.out(25328): [okhttp]:not Email!
I/System.out(25328): [socket]:check permission begin!
I/eerajmandir.po(25328): The ClassLoaderContext is a special shared library.
I/System.out(25328): [OkHttp] sendRequest<<
W/System  (25328): Ignoring header X-Firebase-Locale because its value was null.
I/System.out(25328): [okhttp]:check permission begin!
I/System.out(25328): [okhttp]:not MMS!
I/System.out(25328): [okhttp]:not Email!
I/System.out(25328): [OkHttp] sendRequest<<
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->objectFieldOffset(Ljava/lang/reflect/Field;)J (greylist,core-platform-api, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getLong(Ljava/lang/Object;J)J (greylist,core-platform-api, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->allocateInstance(Ljava/lang/Class;)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->arrayBaseOffset(Ljava/lang/Class;)I (greylist,core-platform-api, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->arrayIndexScale(Ljava/lang/Class;)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Llibcore/io/Memory;->peekLong(JZ)J (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Llibcore/io/Memory;->pokeLong(JJZ)V (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Llibcore/io/Memory;->pokeInt(JIZ)V (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Llibcore/io/Memory;->peekInt(JZ)I (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Llibcore/io/Memory;->pokeByte(JB)V (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Llibcore/io/Memory;->peekByte(J)B (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Llibcore/io/Memory;->pokeByteArray(J[BII)V (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Llibcore/io/Memory;->peekByteArray(J[BII)V (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getLong(Ljava/lang/Object;J)J (greylist,core-platform-api, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden field Ljava/nio/Buffer;->address:J (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getLong(Ljava/lang/Object;J)J (greylist,core-platform-api, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
D/FirebaseAuth(25328): Notifying id token listeners about user ( xwIb2rd9wQe0IaTGBh0PmRNpqr92 ).
D/FirebaseAuth(25328): Notifying auth state listeners about user ( xwIb2rd9wQe0IaTGBh0PmRNpqr92 ).
W/DynamiteModule(25328): Local module descriptor class for com.google.android.gms.providerinstaller.dynamite not found.
I/DynamiteModule(25328): Considering local module com.google.android.gms.providerinstaller.dynamite:0 and remote module com.google.android.gms.providerinstaller.dynamite:0
W/ProviderInstaller(25328): Failed to load providerinstaller module: No acceptable module com.google.android.gms.providerinstaller.dynamite found. Local version is 0 and remote version is 0.
I/eerajmandir.po(25328): The ClassLoaderContext is a special shared library.
I/eerajmandir.po(25328): The ClassLoaderContext is a special shared library.
I/eerajmandir.po(25328): The ClassLoaderContext is a special shared library.
W/ProviderInstaller(25328): Failed to report request stats: com.google.android.gms.common.security.ProviderInstallerImpl.reportRequestStats [class android.content.Context, long, long]
V/NativeCrypto(25328): Registering com/google/android/gms/org/conscrypt/NativeCrypto's 334 native methods...
W/eerajmandir.po(25328): Accessing hidden field Lsun/misc/Unsafe;->theUnsafe:Lsun/misc/Unsafe; (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getUnsafe()Lsun/misc/Unsafe; (greylist,core-platform-api, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->compareAndSwapObject(Ljava/lang/Object;JLjava/lang/Object;Ljava/lang/Object;)Z (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->compareAndSwapInt(Ljava/lang/Object;JII)Z (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObjectVolatile(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->compareAndSwapObject(Ljava/lang/Object;JLjava/lang/Object;Ljava/lang/Object;)Z (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->compareAndSwapLong(Ljava/lang/Object;JJJ)Z (greylist, linking, allowed)  
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getLong(Ljava/lang/Object;J)J (greylist,core-platform-api, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
E/GoogleApiManager(25328): Failed to get service from broker.
E/GoogleApiManager(25328): java.lang.SecurityException: Unknown calling package name 'com.google.android.gms'.
E/GoogleApiManager(25328):      at android.os.Parcel.createException(Parcel.java:2074)
E/GoogleApiManager(25328):      at android.os.Parcel.readException(Parcel.java:2042)
E/GoogleApiManager(25328):      at android.os.Parcel.readException(Parcel.java:1990)
E/GoogleApiManager(25328):      at bgbk.a(:com.google.android.gms@261133009@26.11.33 (100300-887465546):36)
E/GoogleApiManager(25328):      at bfzl.z(:com.google.android.gms@261133009@26.11.33 (100300-887465546):150)
E/GoogleApiManager(25328):      at bffn.run(:com.google.android.gms@261133009@26.11.33 (100300-887465546):42)
E/GoogleApiManager(25328):      at android.os.Handler.handleCallback(Handler.java:914)
E/GoogleApiManager(25328):      at android.os.Handler.dispatchMessage(Handler.java:100)
E/GoogleApiManager(25328):      at ctev.mj(:com.google.android.gms@261133009@26.11.33 (100300-887465546):1)
E/GoogleApiManager(25328):      at ctev.dispatchMessage(:com.google.android.gms@261133009@26.11.33 (100300-887465546):5)
E/GoogleApiManager(25328):      at android.os.Looper.loop(Looper.java:225)
E/GoogleApiManager(25328):      at android.os.HandlerThread.run(HandlerThread.java:67)
W/eerajmandir.po(25328): Accessing hidden method Llibcore/io/Memory;->pokeByte(JB)V (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Llibcore/io/Memory;->peekByte(J)B (greylist, reflection, allowed)
W/GoogleApiManager(25328): Not showing notification since connectionResult is not user-facing: ConnectionResult{statusCode=DEVELOPER_ERROR, resolution=null, message=null, clientMethodKey=null}
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getLong(Ljava/lang/Object;J)J (greylist,core-platform-api, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, reflection, allowed)
W/FlagRegistrar(25328): Failed to register com.google.android.gms.providerinstaller#com.shreerajmandir.pos
W/FlagRegistrar(25328): fdbi: 17: 17: API: Phenotype.API is not available on this device. Connection failed with: ConnectionResult{statusCode=DEVELOPER_ERROR, resolution=null, message=null, clientMethodKey=null}
W/FlagRegistrar(25328):         at fdbk.a(:com.google.android.gms@261133009@26.11.33 (100300-887465546):13)
W/FlagRegistrar(25328):         at fzxd.d(:com.google.android.gms@261133009@26.11.33 (100300-887465546):3)
W/FlagRegistrar(25328):         at fzxf.run(:com.google.android.gms@261133009@26.11.33 (100300-887465546):130)
W/FlagRegistrar(25328):         at fzzm.execute(:com.google.android.gms@261133009@26.11.33 (100300-887465546):1)
W/FlagRegistrar(25328):         at fzxn.f(:com.google.android.gms@261133009@26.11.33 (100300-887465546):1)
W/FlagRegistrar(25328):         at fzxn.m(:com.google.android.gms@261133009@26.11.33 (100300-887465546):99)
W/FlagRegistrar(25328):         at fzxn.r(:com.google.android.gms@261133009@26.11.33 (100300-887465546):17)
W/FlagRegistrar(25328):         at euyp.hI(:com.google.android.gms@261133009@26.11.33 (100300-887465546):35)
W/FlagRegistrar(25328):         at ejpq.run(:com.google.android.gms@261133009@26.11.33 (100300-887465546):12)
W/FlagRegistrar(25328):         at fzzm.execute(:com.google.android.gms@261133009@26.11.33 (100300-887465546):1)
W/FlagRegistrar(25328):         at ejpr.b(:com.google.android.gms@261133009@26.11.33 (100300-887465546):18)
W/FlagRegistrar(25328):         at ejqg.b(:com.google.android.gms@261133009@26.11.33 (100300-887465546):34)
W/FlagRegistrar(25328):         at ejqi.d(:com.google.android.gms@261133009@26.11.33 (100300-887465546):25)
W/FlagRegistrar(25328):         at bfcw.c(:com.google.android.gms@261133009@26.11.33 (100300-887465546):9)
W/FlagRegistrar(25328):         at bffl.q(:com.google.android.gms@261133009@26.11.33 (100300-887465546):48)
W/FlagRegistrar(25328):         at bffl.d(:com.google.android.gms@261133009@26.11.33 (100300-887465546):10)
W/FlagRegistrar(25328):         at bffl.g(:com.google.android.gms@261133009@26.11.33 (100300-887465546):191)
W/FlagRegistrar(25328):         at bffl.onConnectionFailed(:com.google.android.gms@261133009@26.11.33 (100300-887465546):2)
W/FlagRegistrar(25328):         at bffn.run(:com.google.android.gms@261133009@26.11.33 (100300-887465546):70)
W/FlagRegistrar(25328):         at android.os.Handler.handleCallback(Handler.java:914)
W/FlagRegistrar(25328):         at android.os.Handler.dispatchMessage(Handler.java:100)
W/FlagRegistrar(25328):         at ctev.mj(:com.google.android.gms@261133009@26.11.33 (100300-887465546):1)
W/FlagRegistrar(25328):         at ctev.dispatchMessage(:com.google.android.gms@261133009@26.11.33 (100300-887465546):5)
W/FlagRegistrar(25328):         at android.os.Looper.loop(Looper.java:225)
W/FlagRegistrar(25328):         at android.os.HandlerThread.run(HandlerThread.java:67)
W/FlagRegistrar(25328): Caused by: bfbd: 17: API: Phenotype.API is not available on this device. Connection failed with: ConnectionResult{statusCode=DEVELOPER_ERROR, resolution=null, message=null, clientMethodKey=null}
W/FlagRegistrar(25328):         at bfyx.a(:com.google.android.gms@261133009@26.11.33 (100300-887465546):15)
W/FlagRegistrar(25328):         at bfcz.a(:com.google.android.gms@261133009@26.11.33 (100300-887465546):1)
W/FlagRegistrar(25328):         at bfcw.c(:com.google.android.gms@261133009@26.11.33 (100300-887465546):5)
W/FlagRegistrar(25328):         ... 11 more
W/eerajmandir.po(25328): Accessing hidden method Ljava/security/spec/ECParameterSpec;->getCurveName()Ljava/lang/String; (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
I/chatty  (25328): uid=10535(com.shreerajmandir.pos) FirestoreWorker identical 1 line
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Ldalvik/system/VMStack;->getStackClass2()Ljava/lang/Class; (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObjectVolatile(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
I/ProviderInstaller(25328): Installed default security provider GmsCore_OpenSSL
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
I/chatty  (25328): uid=10535(com.shreerajmandir.pos) FirestoreWorker identical 1 line
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
I/System.out(25328): [socket]:check permission begin!
W/eerajmandir.po(25328): Accessing hidden field Ljava/net/Socket;->impl:Ljava/net/SocketImpl; (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Ldalvik/system/CloseGuard;->get()Ldalvik/system/CloseGuard; (greylist,core-platform-api, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Ldalvik/system/CloseGuard;->open(Ljava/lang/String;)V (greylist,core-platform-api, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Ljava/security/spec/ECParameterSpec;->setCurveName(Ljava/lang/String;)V (greylist, reflection, allowed)
W/eerajmandir.po(25328): Accessing hidden method Ldalvik/system/BlockGuard;->getThreadPolicy()Ldalvik/system/BlockGuard$Policy; (greylist,core-platform-api, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Ldalvik/system/BlockGuard$Policy;->onNetwork()V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getLong(Ljava/lang/Object;J)J (greylist,core-platform-api, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getLong(Ljava/lang/Object;J)J (greylist,core-platform-api, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
E/GoogleApiManager(25328): Failed to get service from broker. 
E/GoogleApiManager(25328): java.lang.SecurityException: Unknown calling package name 'com.google.android.gms'.
E/GoogleApiManager(25328):      at android.os.Parcel.createException(Parcel.java:2074)
E/GoogleApiManager(25328):      at android.os.Parcel.readException(Parcel.java:2042)
E/GoogleApiManager(25328):      at android.os.Parcel.readException(Parcel.java:1990)
E/GoogleApiManager(25328):      at bgbk.a(:com.google.android.gms@261133009@26.11.33 (100300-887465546):36)
E/GoogleApiManager(25328):      at bfzl.z(:com.google.android.gms@261133009@26.11.33 (100300-887465546):150)
E/GoogleApiManager(25328):      at bffn.run(:com.google.android.gms@261133009@26.11.33 (100300-887465546):42)
E/GoogleApiManager(25328):      at android.os.Handler.handleCallback(Handler.java:914)
E/GoogleApiManager(25328):      at android.os.Handler.dispatchMessage(Handler.java:100)
E/GoogleApiManager(25328):      at ctev.mj(:com.google.android.gms@261133009@26.11.33 (100300-887465546):1)
E/GoogleApiManager(25328):      at ctev.dispatchMessage(:com.google.android.gms@261133009@26.11.33 (100300-887465546):5)
E/GoogleApiManager(25328):      at android.os.Looper.loop(Looper.java:225)
E/GoogleApiManager(25328):      at android.os.HandlerThread.run(HandlerThread.java:67)
W/GoogleApiManager(25328): Not showing notification since connectionResult is not user-facing: ConnectionResult{statusCode=DEVELOPER_ERROR, resolution=null, message=null, clientMethodKey=null}
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getLong(Ljava/lang/Object;J)J (greylist,core-platform-api, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getLong(Ljava/lang/Object;J)J (greylist,core-platform-api, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getLong(Ljava/lang/Object;J)J (greylist,core-platform-api, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
D/FlutterJNI(25328): Sending viewport metrics to the engine.
W/Looper  (25328): Slow Looper main: doFrame is 399ms late because of 2 msg
I/AssistStructure(25328): Flattened final assist data: 544 bytes, containing 1 windows, 3 views
D/FlutterJNI(25328): Sending viewport metrics to the engine.
I/Choreographer(25328): Skipped 36 frames!  The application may be doing too much work on its main thread.
W/Looper  (25328): Slow Looper main: doFrame is 606ms late because of 2 msg
D/FlutterJNI(25328): Sending viewport metrics to the engine.
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
I/AssistStructure(25328): Flattened final assist data: 544 bytes, containing 1 windows, 3 views
D/FlutterJNI(25328): Sending viewport metrics to the engine.
I/Choreographer(25328): Skipped 35 frames!  The application may be doing too much work on its main thread.
W/Looper  (25328): Slow Looper main: doFrame is 598ms late because of 4 msg
D/FlutterJNI(25328): Sending viewport metrics to the engine.
I/flutter (25328): 🛒 SEND TO KITCHEN INITIALIZED!
I/flutter (25328): 🚀 Calling KOTService...
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getLong(Ljava/lang/Object;J)J (greylist,core-platform-api, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getInt(Ljava/lang/Object;J)I (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putInt(Ljava/lang/Object;JI)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putObject(Ljava/lang/Object;JLjava/lang/Object;)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getLong(Ljava/lang/Object;J)J (greylist,core-platform-api, linking, allowed)
W/eerajmandir.po(25328): Accessing hidden method Lsun/misc/Unsafe;->getObject(Ljava/lang/Object;J)Ljava/lang/Object; (greylist, linking, allowed)
I/flutter (25328): ✅ KOTService returned successfully!
