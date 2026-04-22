; ModuleID = 'benchmarks/ck/ticketlock.c'
source_filename = "benchmarks/ck/ticketlock.c"
target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "armv8a-pc-linux-gnu"

%struct.ck_spinlock_ticket = type { i32, i32 }

@x = dso_local global i32 0, align 4, !dbg !0
@y = dso_local global i32 0, align 4, !dbg !16
@ticket_lock = dso_local global ptr null, align 4, !dbg !35
@.str = private unnamed_addr constant [31 x i8] c"x == NTHREADS && y == NTHREADS\00", align 1, !dbg !18
@.str.1 = private unnamed_addr constant [27 x i8] c"benchmarks/ck/ticketlock.c\00", align 1, !dbg !24
@__func__.main = private unnamed_addr constant [5 x i8] c"main\00", align 1, !dbg !29

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc ptr @run(ptr noundef %0) #0 !dbg !45 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !49, !DIExpression(), !50)
  %3 = load ptr, ptr @ticket_lock, align 4, !dbg !51
  call arm_aapcscc void @ck_spinlock_ticket_lock(ptr noundef %3), !dbg !52
  %4 = load i32, ptr @x, align 4, !dbg !53
  %5 = add nsw i32 %4, 1, !dbg !53
  store i32 %5, ptr @x, align 4, !dbg !53
  %6 = load i32, ptr @y, align 4, !dbg !54
  %7 = add nsw i32 %6, 1, !dbg !54
  store i32 %7, ptr @y, align 4, !dbg !54
  %8 = load ptr, ptr @ticket_lock, align 4, !dbg !55
  call arm_aapcscc void @ck_spinlock_ticket_unlock(ptr noundef %8), !dbg !56
  ret ptr null, !dbg !57
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_ticket_lock(ptr noundef %0) #0 !dbg !58 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !62, !DIExpression(), !63)
    #dbg_declare(ptr %3, !64, !DIExpression(), !65)
  %4 = load ptr, ptr %2, align 4, !dbg !66
  %5 = getelementptr inbounds nuw %struct.ck_spinlock_ticket, ptr %4, i32 0, i32 0, !dbg !67
  %6 = call arm_aapcscc i32 @ck_pr_faa_uint(ptr noundef %5, i32 noundef 1), !dbg !68
  store i32 %6, ptr %3, align 4, !dbg !69
  br label %7, !dbg !70

7:                                                ; preds = %13, %1
  %8 = load ptr, ptr %2, align 4, !dbg !71
  %9 = getelementptr inbounds nuw %struct.ck_spinlock_ticket, ptr %8, i32 0, i32 1, !dbg !72
  %10 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %9), !dbg !73
  %11 = load i32, ptr %3, align 4, !dbg !74
  %12 = icmp ne i32 %10, %11, !dbg !75
  br i1 %12, label %13, label %14, !dbg !70

13:                                               ; preds = %7
  call arm_aapcscc void @ck_pr_stall(), !dbg !76
  br label %7, !dbg !70, !llvm.loop !77

14:                                               ; preds = %7
  call arm_aapcscc void @ck_pr_fence_lock(), !dbg !80
  ret void, !dbg !81
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_ticket_unlock(ptr noundef %0) #0 !dbg !82 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !83, !DIExpression(), !84)
    #dbg_declare(ptr %3, !85, !DIExpression(), !86)
  call arm_aapcscc void @ck_pr_fence_unlock(), !dbg !87
  %4 = load ptr, ptr %2, align 4, !dbg !88
  %5 = getelementptr inbounds nuw %struct.ck_spinlock_ticket, ptr %4, i32 0, i32 1, !dbg !89
  %6 = call arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %5), !dbg !90
  store i32 %6, ptr %3, align 4, !dbg !91
  %7 = load ptr, ptr %2, align 4, !dbg !92
  %8 = getelementptr inbounds nuw %struct.ck_spinlock_ticket, ptr %7, i32 0, i32 1, !dbg !93
  %9 = load i32, ptr %3, align 4, !dbg !94
  %10 = add i32 %9, 1, !dbg !95
  call arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %8, i32 noundef %10), !dbg !96
  ret void, !dbg !97
}

; Function Attrs: noinline nounwind optnone
define dso_local arm_aapcscc i32 @main() #0 !dbg !98 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x ptr], align 4
  %3 = alloca i32, align 4
  store i32 0, ptr %1, align 4
    #dbg_declare(ptr %2, !101, !DIExpression(), !107)
    #dbg_declare(ptr %3, !108, !DIExpression(), !109)
  %4 = call arm_aapcscc ptr @malloc(i32 noundef 8) #4, !dbg !110
  store ptr %4, ptr @ticket_lock, align 4, !dbg !111
  %5 = load ptr, ptr @ticket_lock, align 4, !dbg !112
  call arm_aapcscc void @ck_spinlock_ticket_init(ptr noundef %5), !dbg !113
  store i32 0, ptr %3, align 4, !dbg !114
  br label %6, !dbg !116

6:                                                ; preds = %16, %0
  %7 = load i32, ptr %3, align 4, !dbg !117
  %8 = icmp slt i32 %7, 3, !dbg !119
  br i1 %8, label %9, label %19, !dbg !120

9:                                                ; preds = %6
  %10 = load i32, ptr %3, align 4, !dbg !121
  %11 = getelementptr inbounds [3 x ptr], ptr %2, i32 0, i32 %10, !dbg !124
  %12 = call arm_aapcscc i32 @pthread_create(ptr noundef %11, ptr noundef null, ptr noundef @run, ptr noundef null), !dbg !125
  %13 = icmp ne i32 %12, 0, !dbg !126
  br i1 %13, label %14, label %15, !dbg !126

14:                                               ; preds = %9
  call arm_aapcscc void @exit(i32 noundef 1) #5, !dbg !127
  unreachable, !dbg !127

15:                                               ; preds = %9
  br label %16, !dbg !129

16:                                               ; preds = %15
  %17 = load i32, ptr %3, align 4, !dbg !130
  %18 = add nsw i32 %17, 1, !dbg !130
  store i32 %18, ptr %3, align 4, !dbg !130
  br label %6, !dbg !131, !llvm.loop !132

19:                                               ; preds = %6
  store i32 0, ptr %3, align 4, !dbg !134
  br label %20, !dbg !136

20:                                               ; preds = %31, %19
  %21 = load i32, ptr %3, align 4, !dbg !137
  %22 = icmp slt i32 %21, 3, !dbg !139
  br i1 %22, label %23, label %34, !dbg !140

23:                                               ; preds = %20
  %24 = load i32, ptr %3, align 4, !dbg !141
  %25 = getelementptr inbounds [3 x ptr], ptr %2, i32 0, i32 %24, !dbg !144
  %26 = load ptr, ptr %25, align 4, !dbg !144
  %27 = call arm_aapcscc i32 @pthread_join(ptr noundef %26, ptr noundef null), !dbg !145
  %28 = icmp ne i32 %27, 0, !dbg !146
  br i1 %28, label %29, label %30, !dbg !146

29:                                               ; preds = %23
  call arm_aapcscc void @exit(i32 noundef 1) #5, !dbg !147
  unreachable, !dbg !147

30:                                               ; preds = %23
  br label %31, !dbg !149

31:                                               ; preds = %30
  %32 = load i32, ptr %3, align 4, !dbg !150
  %33 = add nsw i32 %32, 1, !dbg !150
  store i32 %33, ptr %3, align 4, !dbg !150
  br label %20, !dbg !151, !llvm.loop !152

34:                                               ; preds = %20
  %35 = load i32, ptr @x, align 4, !dbg !154
  %36 = icmp eq i32 %35, 3, !dbg !157
  br i1 %36, label %37, label %40, !dbg !158

37:                                               ; preds = %34
  %38 = load i32, ptr @y, align 4, !dbg !159
  %39 = icmp eq i32 %38, 3, !dbg !160
  br i1 %39, label %41, label %40, !dbg !161

40:                                               ; preds = %37, %34
  call arm_aapcscc void @__assert_fail(ptr noundef @.str, ptr noundef @.str.1, i32 noundef 50, ptr noundef @__func__.main), !dbg !161
  br label %41, !dbg !161

41:                                               ; preds = %40, %37
  %42 = load ptr, ptr @ticket_lock, align 4, !dbg !162
  call arm_aapcscc void @free(ptr noundef %42), !dbg !163
  ret i32 0, !dbg !164
}

; Function Attrs: allocsize(0)
declare arm_aapcscc ptr @malloc(i32 noundef) #1

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_spinlock_ticket_init(ptr noundef %0) #0 !dbg !165 {
  %2 = alloca ptr, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !166, !DIExpression(), !167)
  %3 = load ptr, ptr %2, align 4, !dbg !168
  %4 = getelementptr inbounds nuw %struct.ck_spinlock_ticket, ptr %3, i32 0, i32 0, !dbg !169
  store i32 0, ptr %4, align 4, !dbg !170
  %5 = load ptr, ptr %2, align 4, !dbg !171
  %6 = getelementptr inbounds nuw %struct.ck_spinlock_ticket, ptr %5, i32 0, i32 1, !dbg !172
  store i32 0, ptr %6, align 4, !dbg !173
  call arm_aapcscc void @ck_pr_barrier(), !dbg !174
  ret void, !dbg !175
}

declare arm_aapcscc i32 @pthread_create(ptr noundef, ptr noundef, ptr noundef, ptr noundef) #2

; Function Attrs: noreturn
declare arm_aapcscc void @exit(i32 noundef) #3

declare arm_aapcscc i32 @pthread_join(ptr noundef, ptr noundef) #2

declare arm_aapcscc void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) #2

declare arm_aapcscc void @free(ptr noundef) #2

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc i32 @ck_pr_faa_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !176 {
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !181, !DIExpression(), !182)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !183, !DIExpression(), !182)
    #dbg_declare(ptr %5, !184, !DIExpression(), !182)
  store i32 0, ptr %5, align 4, !dbg !182
    #dbg_declare(ptr %6, !185, !DIExpression(), !182)
  store i32 0, ptr %6, align 4, !dbg !182
    #dbg_declare(ptr %7, !186, !DIExpression(), !182)
  store i32 0, ptr %7, align 4, !dbg !182
  %8 = load i32, ptr %5, align 4, !dbg !182
  %9 = load i32, ptr %6, align 4, !dbg !182
  %10 = load i32, ptr %7, align 4, !dbg !182
  %11 = load ptr, ptr %3, align 4, !dbg !182
  %12 = load i32, ptr %4, align 4, !dbg !182
  %13 = call { i32, i32, i32 } asm sideeffect "1:ldrex $0, [$3];add $1, $4, $0;strex $2, $1, [$3];cmp $2, #0;bne  1b;", "=&r,=&r,=&r,r,r,0,1,2,~{memory},~{cc}"(ptr %11, i32 %12, i32 %8, i32 %9, i32 %10) #6, !dbg !182, !srcloc !187
  %14 = extractvalue { i32, i32, i32 } %13, 0, !dbg !182
  %15 = extractvalue { i32, i32, i32 } %13, 1, !dbg !182
  %16 = extractvalue { i32, i32, i32 } %13, 2, !dbg !182
  store i32 %14, ptr %5, align 4, !dbg !182
  store i32 %15, ptr %6, align 4, !dbg !182
  store i32 %16, ptr %7, align 4, !dbg !182
  %17 = load i32, ptr %5, align 4, !dbg !182
  ret i32 %17, !dbg !182
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc i32 @ck_pr_md_load_uint(ptr noundef %0) #0 !dbg !188 {
  %2 = alloca ptr, align 4
  %3 = alloca i32, align 4
  store ptr %0, ptr %2, align 4
    #dbg_declare(ptr %2, !193, !DIExpression(), !194)
    #dbg_declare(ptr %3, !195, !DIExpression(), !194)
  store i32 0, ptr %3, align 4, !dbg !194
  %4 = load ptr, ptr %2, align 4, !dbg !194
  %5 = call i32 asm sideeffect "ldr $0, [$1];", "=r,r,~{memory}"(ptr %4) #6, !dbg !194, !srcloc !197
  store i32 %5, ptr %3, align 4, !dbg !194
  %6 = load i32, ptr %3, align 4, !dbg !194
  ret i32 %6, !dbg !194
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_stall() #0 !dbg !198 {
  call void asm sideeffect "", "~{memory}"() #6, !dbg !201, !srcloc !202
  ret void, !dbg !203
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_lock() #0 !dbg !204 {
  call arm_aapcscc void @ck_pr_fence_strict_lock(), !dbg !206
  ret void, !dbg !206
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_lock() #0 !dbg !207 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #6, !dbg !208, !srcloc !209
  ret void, !dbg !210
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_unlock() #0 !dbg !211 {
  call arm_aapcscc void @ck_pr_fence_strict_unlock(), !dbg !212
  ret void, !dbg !212
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_md_store_uint(ptr noundef %0, i32 noundef %1) #0 !dbg !213 {
  %3 = alloca ptr, align 4
  %4 = alloca i32, align 4
  store ptr %0, ptr %3, align 4
    #dbg_declare(ptr %3, !216, !DIExpression(), !217)
  store i32 %1, ptr %4, align 4
    #dbg_declare(ptr %4, !218, !DIExpression(), !217)
  %5 = load ptr, ptr %3, align 4, !dbg !217
  %6 = load i32, ptr %4, align 4, !dbg !217
  call void asm sideeffect "str $1, [$0]", "r,r,~{memory}"(ptr %5, i32 %6) #6, !dbg !217, !srcloc !219
  ret void, !dbg !217
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_fence_strict_unlock() #0 !dbg !220 {
  call void asm sideeffect "mcr p15, 0, $0, c7, c10, 5", "r,~{memory}"(i32 0) #6, !dbg !221, !srcloc !222
  ret void, !dbg !223
}

; Function Attrs: noinline nounwind optnone
define internal arm_aapcscc void @ck_pr_barrier() #0 !dbg !224 {
  call void asm sideeffect "", "~{memory}"() #6, !dbg !226, !srcloc !227
  ret void, !dbg !228
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #1 = { allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #3 = { noreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+armv8-a,+crc,+dsp,+hwdiv,+hwdiv-arm,+read-tp-tpidruro,+soft-float,-aes,-bf16,-d32,-dotprod,-fp-armv8,-fp-armv8d16,-fp-armv8d16sp,-fp-armv8sp,-fp16,-fp16fml,-fp64,-fpregs,-fullfp16,-mve,-mve.fp,-neon,-sha2,-thumb-mode,-vfp2,-vfp2sp,-vfp3,-vfp3d16,-vfp3d16sp,-vfp3sp,-vfp4,-vfp4d16,-vfp4d16sp,-vfp4sp" "use-soft-float"="true" }
attributes #4 = { allocsize(0) }
attributes #5 = { noreturn }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!37, !38, !39, !40, !41, !42, !43}
!llvm.ident = !{!44}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 10, type: !14, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "Homebrew clang version 22.1.8", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !15, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "benchmarks/ck/ticketlock.c", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "2e42b97c575f8696a63db17614240b11")
!4 = !{!5, !6, !14, !12}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 32)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "ck_spinlock_ticket_t", file: !8, line: 195, baseType: !9)
!8 = !DIFile(filename: "../ck/include/spinlock/ticket.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "c308b76e8f50dc3a0a4f98ae540c37c4")
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ck_spinlock_ticket", file: !8, line: 191, size: 64, elements: !10)
!10 = !{!11, !13}
!11 = !DIDerivedType(tag: DW_TAG_member, name: "next", scope: !9, file: !8, line: 192, baseType: !12, size: 32)
!12 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!13 = !DIDerivedType(tag: DW_TAG_member, name: "position", scope: !9, file: !8, line: 193, baseType: !12, size: 32, offset: 32)
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !{!0, !16, !18, !24, !29, !35}
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 10, type: !14, isLocal: false, isDefinition: true)
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(scope: null, file: !3, line: 50, type: !20, isLocal: true, isDefinition: true)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 248, elements: !22)
!21 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_unsigned_char)
!22 = !{!23}
!23 = !DISubrange(count: 31)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(scope: null, file: !3, line: 50, type: !26, isLocal: true, isDefinition: true)
!26 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 216, elements: !27)
!27 = !{!28}
!28 = !DISubrange(count: 27)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(scope: null, file: !3, line: 50, type: !31, isLocal: true, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 40, elements: !33)
!32 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !21)
!33 = !{!34}
!34 = !DISubrange(count: 5)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "ticket_lock", scope: !2, file: !3, line: 11, type: !6, isLocal: false, isDefinition: true)
!37 = !{i32 7, !"Dwarf Version", i32 5}
!38 = !{i32 2, !"Debug Info Version", i32 3}
!39 = !{i32 1, !"wchar_size", i32 4}
!40 = !{i32 1, !"min_enum_size", i32 4}
!41 = !{i32 8, !"PIC Level", i32 2}
!42 = !{i32 7, !"PIE Level", i32 2}
!43 = !{i32 7, !"frame-pointer", i32 2}
!44 = !{!"Homebrew clang version 22.1.8"}
!45 = distinct !DISubprogram(name: "run", scope: !3, file: !3, line: 13, type: !46, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !48)
!46 = !DISubroutineType(types: !47)
!47 = !{!5, !5}
!48 = !{}
!49 = !DILocalVariable(name: "arg", arg: 1, scope: !45, file: !3, line: 13, type: !5)
!50 = !DILocation(line: 13, column: 17, scope: !45)
!51 = !DILocation(line: 16, column: 29, scope: !45)
!52 = !DILocation(line: 16, column: 5, scope: !45)
!53 = !DILocation(line: 18, column: 6, scope: !45)
!54 = !DILocation(line: 19, column: 6, scope: !45)
!55 = !DILocation(line: 21, column: 31, scope: !45)
!56 = !DILocation(line: 21, column: 5, scope: !45)
!57 = !DILocation(line: 23, column: 5, scope: !45)
!58 = distinct !DISubprogram(name: "ck_spinlock_ticket_lock", scope: !8, file: !8, line: 222, type: !59, scopeLine: 223, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!59 = !DISubroutineType(types: !60)
!60 = !{null, !61}
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 32)
!62 = !DILocalVariable(name: "ticket", arg: 1, scope: !58, file: !8, line: 222, type: !61)
!63 = !DILocation(line: 222, column: 52, scope: !58)
!64 = !DILocalVariable(name: "request", scope: !58, file: !8, line: 224, type: !12)
!65 = !DILocation(line: 224, column: 15, scope: !58)
!66 = !DILocation(line: 227, column: 28, scope: !58)
!67 = !DILocation(line: 227, column: 36, scope: !58)
!68 = !DILocation(line: 227, column: 12, scope: !58)
!69 = !DILocation(line: 227, column: 10, scope: !58)
!70 = !DILocation(line: 234, column: 2, scope: !58)
!71 = !DILocation(line: 234, column: 26, scope: !58)
!72 = !DILocation(line: 234, column: 34, scope: !58)
!73 = !DILocation(line: 234, column: 9, scope: !58)
!74 = !DILocation(line: 234, column: 47, scope: !58)
!75 = !DILocation(line: 234, column: 44, scope: !58)
!76 = !DILocation(line: 235, column: 3, scope: !58)
!77 = distinct !{!77, !70, !78, !79}
!78 = !DILocation(line: 235, column: 15, scope: !58)
!79 = !{!"llvm.loop.mustprogress"}
!80 = !DILocation(line: 237, column: 2, scope: !58)
!81 = !DILocation(line: 238, column: 2, scope: !58)
!82 = distinct !DISubprogram(name: "ck_spinlock_ticket_unlock", scope: !8, file: !8, line: 271, type: !59, scopeLine: 272, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!83 = !DILocalVariable(name: "ticket", arg: 1, scope: !82, file: !8, line: 271, type: !61)
!84 = !DILocation(line: 271, column: 54, scope: !82)
!85 = !DILocalVariable(name: "update", scope: !82, file: !8, line: 273, type: !12)
!86 = !DILocation(line: 273, column: 15, scope: !82)
!87 = !DILocation(line: 275, column: 2, scope: !82)
!88 = !DILocation(line: 282, column: 28, scope: !82)
!89 = !DILocation(line: 282, column: 36, scope: !82)
!90 = !DILocation(line: 282, column: 11, scope: !82)
!91 = !DILocation(line: 282, column: 9, scope: !82)
!92 = !DILocation(line: 283, column: 20, scope: !82)
!93 = !DILocation(line: 283, column: 28, scope: !82)
!94 = !DILocation(line: 283, column: 38, scope: !82)
!95 = !DILocation(line: 283, column: 45, scope: !82)
!96 = !DILocation(line: 283, column: 2, scope: !82)
!97 = !DILocation(line: 284, column: 2, scope: !82)
!98 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 26, type: !99, scopeLine: 27, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !48)
!99 = !DISubroutineType(types: !100)
!100 = !{!14}
!101 = !DILocalVariable(name: "threads", scope: !98, file: !3, line: 28, type: !102)
!102 = !DICompositeType(tag: DW_TAG_array_type, baseType: !103, size: 96, elements: !105)
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !104, line: 2, baseType: !5)
!104 = !DIFile(filename: "include/libc/pthread.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "17740edbdaeb6f1f4624ba115290b408")
!105 = !{!106}
!106 = !DISubrange(count: 3)
!107 = !DILocation(line: 28, column: 15, scope: !98)
!108 = !DILocalVariable(name: "i", scope: !98, file: !3, line: 29, type: !14)
!109 = !DILocation(line: 29, column: 9, scope: !98)
!110 = !DILocation(line: 31, column: 43, scope: !98)
!111 = !DILocation(line: 31, column: 17, scope: !98)
!112 = !DILocation(line: 32, column: 29, scope: !98)
!113 = !DILocation(line: 32, column: 5, scope: !98)
!114 = !DILocation(line: 34, column: 12, scope: !115)
!115 = distinct !DILexicalBlock(scope: !98, file: !3, line: 34, column: 5)
!116 = !DILocation(line: 34, column: 10, scope: !115)
!117 = !DILocation(line: 34, column: 17, scope: !118)
!118 = distinct !DILexicalBlock(scope: !115, file: !3, line: 34, column: 5)
!119 = !DILocation(line: 34, column: 19, scope: !118)
!120 = !DILocation(line: 34, column: 5, scope: !115)
!121 = !DILocation(line: 36, column: 37, scope: !122)
!122 = distinct !DILexicalBlock(scope: !123, file: !3, line: 36, column: 13)
!123 = distinct !DILexicalBlock(scope: !118, file: !3, line: 35, column: 5)
!124 = !DILocation(line: 36, column: 29, scope: !122)
!125 = !DILocation(line: 36, column: 13, scope: !122)
!126 = !DILocation(line: 36, column: 58, scope: !122)
!127 = !DILocation(line: 38, column: 13, scope: !128)
!128 = distinct !DILexicalBlock(scope: !122, file: !3, line: 37, column: 9)
!129 = !DILocation(line: 40, column: 5, scope: !123)
!130 = !DILocation(line: 34, column: 32, scope: !118)
!131 = !DILocation(line: 34, column: 5, scope: !118)
!132 = distinct !{!132, !120, !133, !79}
!133 = !DILocation(line: 40, column: 5, scope: !115)
!134 = !DILocation(line: 42, column: 12, scope: !135)
!135 = distinct !DILexicalBlock(scope: !98, file: !3, line: 42, column: 5)
!136 = !DILocation(line: 42, column: 10, scope: !135)
!137 = !DILocation(line: 42, column: 17, scope: !138)
!138 = distinct !DILexicalBlock(scope: !135, file: !3, line: 42, column: 5)
!139 = !DILocation(line: 42, column: 19, scope: !138)
!140 = !DILocation(line: 42, column: 5, scope: !135)
!141 = !DILocation(line: 44, column: 34, scope: !142)
!142 = distinct !DILexicalBlock(scope: !143, file: !3, line: 44, column: 13)
!143 = distinct !DILexicalBlock(scope: !138, file: !3, line: 43, column: 5)
!144 = !DILocation(line: 44, column: 26, scope: !142)
!145 = !DILocation(line: 44, column: 13, scope: !142)
!146 = !DILocation(line: 44, column: 44, scope: !142)
!147 = !DILocation(line: 46, column: 13, scope: !148)
!148 = distinct !DILexicalBlock(scope: !142, file: !3, line: 45, column: 9)
!149 = !DILocation(line: 48, column: 5, scope: !143)
!150 = !DILocation(line: 42, column: 32, scope: !138)
!151 = !DILocation(line: 42, column: 5, scope: !138)
!152 = distinct !{!152, !140, !153, !79}
!153 = !DILocation(line: 48, column: 5, scope: !135)
!154 = !DILocation(line: 50, column: 12, scope: !155)
!155 = distinct !DILexicalBlock(scope: !156, file: !3, line: 50, column: 5)
!156 = distinct !DILexicalBlock(scope: !98, file: !3, line: 50, column: 5)
!157 = !DILocation(line: 50, column: 14, scope: !155)
!158 = !DILocation(line: 50, column: 26, scope: !155)
!159 = !DILocation(line: 50, column: 29, scope: !155)
!160 = !DILocation(line: 50, column: 31, scope: !155)
!161 = !DILocation(line: 50, column: 5, scope: !155)
!162 = !DILocation(line: 52, column: 10, scope: !98)
!163 = !DILocation(line: 52, column: 5, scope: !98)
!164 = !DILocation(line: 54, column: 5, scope: !98)
!165 = distinct !DISubprogram(name: "ck_spinlock_ticket_init", scope: !8, file: !8, line: 200, type: !59, scopeLine: 201, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!166 = !DILocalVariable(name: "ticket", arg: 1, scope: !165, file: !8, line: 200, type: !61)
!167 = !DILocation(line: 200, column: 52, scope: !165)
!168 = !DILocation(line: 203, column: 2, scope: !165)
!169 = !DILocation(line: 203, column: 10, scope: !165)
!170 = !DILocation(line: 203, column: 15, scope: !165)
!171 = !DILocation(line: 204, column: 2, scope: !165)
!172 = !DILocation(line: 204, column: 10, scope: !165)
!173 = !DILocation(line: 204, column: 19, scope: !165)
!174 = !DILocation(line: 205, column: 2, scope: !165)
!175 = !DILocation(line: 207, column: 2, scope: !165)
!176 = distinct !DISubprogram(name: "ck_pr_faa_uint", scope: !177, file: !177, line: 553, type: !178, scopeLine: 553, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!177 = !DIFile(filename: "../ck/include/gcc/arm/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "f3f9fb174933d4f9d5af6678feea8d14")
!178 = !DISubroutineType(types: !179)
!179 = !{!12, !180, !12}
!180 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 32)
!181 = !DILocalVariable(name: "target", arg: 1, scope: !176, file: !177, line: 553, type: !180)
!182 = !DILocation(line: 553, column: 1, scope: !176)
!183 = !DILocalVariable(name: "delta", arg: 2, scope: !176, file: !177, line: 553, type: !12)
!184 = !DILocalVariable(name: "previous", scope: !176, file: !177, line: 553, type: !12)
!185 = !DILocalVariable(name: "r", scope: !176, file: !177, line: 553, type: !12)
!186 = !DILocalVariable(name: "tmp", scope: !176, file: !177, line: 553, type: !12)
!187 = !{i64 2147649269}
!188 = distinct !DISubprogram(name: "ck_pr_md_load_uint", scope: !177, file: !177, line: 127, type: !189, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!189 = !DISubroutineType(types: !190)
!190 = !{!12, !191}
!191 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !192, size: 32)
!192 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !12)
!193 = !DILocalVariable(name: "target", arg: 1, scope: !188, file: !177, line: 127, type: !191)
!194 = !DILocation(line: 127, column: 1, scope: !188)
!195 = !DILocalVariable(name: "r", scope: !188, file: !177, line: 127, type: !196)
!196 = !DIBasicType(name: "long", size: 32, encoding: DW_ATE_signed)
!197 = !{i64 2147586705}
!198 = distinct !DISubprogram(name: "ck_pr_stall", scope: !177, file: !177, line: 50, type: !199, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!199 = !DISubroutineType(types: !200)
!200 = !{null}
!201 = !DILocation(line: 53, column: 2, scope: !198)
!202 = !{i64 78914}
!203 = !DILocation(line: 54, column: 2, scope: !198)
!204 = distinct !DISubprogram(name: "ck_pr_fence_lock", scope: !205, file: !205, line: 122, type: !199, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!205 = !DIFile(filename: "../ck/include/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "a04525ce1c6aca0c6489b709b33f6356")
!206 = !DILocation(line: 122, column: 1, scope: !204)
!207 = distinct !DISubprogram(name: "ck_pr_fence_strict_lock", scope: !177, file: !177, line: 98, type: !199, scopeLine: 98, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!208 = !DILocation(line: 98, column: 19, scope: !207)
!209 = !{i64 2147584502}
!210 = !DILocation(line: 98, column: 1, scope: !207)
!211 = distinct !DISubprogram(name: "ck_pr_fence_unlock", scope: !205, file: !205, line: 123, type: !199, scopeLine: 123, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!212 = !DILocation(line: 123, column: 1, scope: !211)
!213 = distinct !DISubprogram(name: "ck_pr_md_store_uint", scope: !177, file: !177, line: 176, type: !214, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !48)
!214 = !DISubroutineType(types: !215)
!215 = !{null, !180, !12}
!216 = !DILocalVariable(name: "target", arg: 1, scope: !213, file: !177, line: 176, type: !180)
!217 = !DILocation(line: 176, column: 1, scope: !213)
!218 = !DILocalVariable(name: "v", arg: 2, scope: !213, file: !177, line: 176, type: !12)
!219 = !{i64 2147589574}
!220 = distinct !DISubprogram(name: "ck_pr_fence_strict_unlock", scope: !177, file: !177, line: 99, type: !199, scopeLine: 99, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!221 = !DILocation(line: 99, column: 21, scope: !220)
!222 = !{i64 2147584797}
!223 = !DILocation(line: 99, column: 1, scope: !220)
!224 = distinct !DISubprogram(name: "ck_pr_barrier", scope: !225, file: !225, line: 37, type: !199, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2)
!225 = !DIFile(filename: "../ck/include/gcc/ck_pr.h", directory: "/Users/r/git/dat3m", checksumkind: CSK_MD5, checksum: "6bd985a96b46842a406b2123a32bcf68")
!226 = !DILocation(line: 40, column: 2, scope: !224)
!227 = !{i64 174650}
!228 = !DILocation(line: 41, column: 2, scope: !224)
