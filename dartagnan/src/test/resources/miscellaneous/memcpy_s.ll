; ModuleID = '/home/ponce/git/Dat3M/output/memcpy_s.ll'
source_filename = "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/memcpy_s.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@__const.main.a = private unnamed_addr constant [4 x i32] [i32 1, i32 2, i32 3, i32 4], align 16
@__const.main.b = private unnamed_addr constant [3 x i32] [i32 5, i32 6, i32 7], align 4
@.str = private unnamed_addr constant [8 x i8] c"ret > 0\00", align 1
@.str.1 = private unnamed_addr constant [60 x i8] c"/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/memcpy_s.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [11 x i8] c"int main()\00", align 1
@.str.2 = private unnamed_addr constant [10 x i8] c"b[0] == 0\00", align 1
@.str.3 = private unnamed_addr constant [10 x i8] c"b[1] == 0\00", align 1
@.str.4 = private unnamed_addr constant [10 x i8] c"b[2] == 0\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"b[2] == 7\00", align 1
@.str.6 = private unnamed_addr constant [9 x i8] c"ret == 0\00", align 1
@.str.7 = private unnamed_addr constant [10 x i8] c"b[0] == 1\00", align 1
@.str.8 = private unnamed_addr constant [10 x i8] c"b[1] == 2\00", align 1
@.str.9 = private unnamed_addr constant [10 x i8] c"b[2] == 3\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main() #0 !dbg !9 {
  %1 = alloca i32, align 4
  %2 = alloca [4 x i32], align 16
  %3 = alloca [3 x i32], align 4
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [4 x i32]* %2, metadata !14, metadata !DIExpression()), !dbg !18
  %5 = bitcast [4 x i32]* %2 to i8*, !dbg !18
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %5, i8* align 16 bitcast ([4 x i32]* @__const.main.a to i8*), i64 16, i1 false), !dbg !18
  call void @llvm.dbg.declare(metadata [3 x i32]* %3, metadata !19, metadata !DIExpression()), !dbg !23
  %6 = bitcast [3 x i32]* %3 to i8*, !dbg !23
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %6, i8* align 4 bitcast ([3 x i32]* @__const.main.b to i8*), i64 12, i1 false), !dbg !23
  call void @llvm.dbg.declare(metadata i32* %4, metadata !24, metadata !DIExpression()), !dbg !25
  %7 = getelementptr inbounds [4 x i32], [4 x i32]* %2, i64 0, i64 0, !dbg !26
  %8 = bitcast i32* %7 to i8*, !dbg !26
  %9 = call i32 @memcpy_s(i8* null, i64 12, i8* %8, i64 12), !dbg !27
  store i32 %9, i32* %4, align 4, !dbg !28
  %10 = load i32, i32* %4, align 4, !dbg !29
  %11 = icmp sgt i32 %10, 0, !dbg !29
  br i1 %11, label %12, label %13, !dbg !32

12:                                               ; preds = %0
  br label %14, !dbg !32

13:                                               ; preds = %0
  call void @__assert_fail(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 22, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !29
  unreachable, !dbg !29

14:                                               ; preds = %12
  %15 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !33
  %16 = bitcast i32* %15 to i8*, !dbg !33
  %17 = call i32 @memcpy_s(i8* %16, i64 12, i8* null, i64 12), !dbg !34
  store i32 %17, i32* %4, align 4, !dbg !35
  %18 = load i32, i32* %4, align 4, !dbg !36
  %19 = icmp sgt i32 %18, 0, !dbg !36
  br i1 %19, label %20, label %21, !dbg !39

20:                                               ; preds = %14
  br label %22, !dbg !39

21:                                               ; preds = %14
  call void @__assert_fail(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 26, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !36
  unreachable, !dbg !36

22:                                               ; preds = %20
  %23 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !40
  %24 = load i32, i32* %23, align 4, !dbg !40
  %25 = icmp eq i32 %24, 0, !dbg !40
  br i1 %25, label %26, label %27, !dbg !43

26:                                               ; preds = %22
  br label %28, !dbg !43

27:                                               ; preds = %22
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 27, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !40
  unreachable, !dbg !40

28:                                               ; preds = %26
  %29 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !44
  %30 = load i32, i32* %29, align 4, !dbg !44
  %31 = icmp eq i32 %30, 0, !dbg !44
  br i1 %31, label %32, label %33, !dbg !47

32:                                               ; preds = %28
  br label %34, !dbg !47

33:                                               ; preds = %28
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 28, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !44
  unreachable, !dbg !44

34:                                               ; preds = %32
  %35 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !48
  %36 = load i32, i32* %35, align 4, !dbg !48
  %37 = icmp eq i32 %36, 0, !dbg !48
  br i1 %37, label %38, label %39, !dbg !51

38:                                               ; preds = %34
  br label %40, !dbg !51

39:                                               ; preds = %34
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.4, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 29, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !48
  unreachable, !dbg !48

40:                                               ; preds = %38
  %41 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !52
  store i32 5, i32* %41, align 4, !dbg !53
  %42 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !54
  store i32 6, i32* %42, align 4, !dbg !55
  %43 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !56
  store i32 7, i32* %43, align 4, !dbg !57
  %44 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !58
  %45 = bitcast i32* %44 to i8*, !dbg !58
  %46 = getelementptr inbounds [4 x i32], [4 x i32]* %2, i64 0, i64 0, !dbg !59
  %47 = bitcast i32* %46 to i8*, !dbg !59
  %48 = call i32 @memcpy_s(i8* %45, i64 8, i8* %47, i64 16), !dbg !60
  store i32 %48, i32* %4, align 4, !dbg !61
  %49 = load i32, i32* %4, align 4, !dbg !62
  %50 = icmp sgt i32 %49, 0, !dbg !62
  br i1 %50, label %51, label %52, !dbg !65

51:                                               ; preds = %40
  br label %53, !dbg !65

52:                                               ; preds = %40
  call void @__assert_fail(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 36, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !62
  unreachable, !dbg !62

53:                                               ; preds = %51
  %54 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !66
  %55 = load i32, i32* %54, align 4, !dbg !66
  %56 = icmp eq i32 %55, 0, !dbg !66
  br i1 %56, label %57, label %58, !dbg !69

57:                                               ; preds = %53
  br label %59, !dbg !69

58:                                               ; preds = %53
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 37, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !66
  unreachable, !dbg !66

59:                                               ; preds = %57
  %60 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !70
  %61 = load i32, i32* %60, align 4, !dbg !70
  %62 = icmp eq i32 %61, 0, !dbg !70
  br i1 %62, label %63, label %64, !dbg !73

63:                                               ; preds = %59
  br label %65, !dbg !73

64:                                               ; preds = %59
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 38, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !70
  unreachable, !dbg !70

65:                                               ; preds = %63
  %66 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !74
  %67 = load i32, i32* %66, align 4, !dbg !74
  %68 = icmp eq i32 %67, 7, !dbg !74
  br i1 %68, label %69, label %70, !dbg !77

69:                                               ; preds = %65
  br label %71, !dbg !77

70:                                               ; preds = %65
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.5, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 40, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !74
  unreachable, !dbg !74

71:                                               ; preds = %69
  %72 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !78
  store i32 5, i32* %72, align 4, !dbg !79
  %73 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !80
  store i32 6, i32* %73, align 4, !dbg !81
  %74 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !82
  %75 = bitcast i32* %74 to i8*, !dbg !82
  %76 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !83
  %77 = bitcast i32* %76 to i8*, !dbg !83
  %78 = call i32 @memcpy_s(i8* %75, i64 12, i8* %77, i64 12), !dbg !84
  store i32 %78, i32* %4, align 4, !dbg !85
  %79 = load i32, i32* %4, align 4, !dbg !86
  %80 = icmp sgt i32 %79, 0, !dbg !86
  br i1 %80, label %81, label %82, !dbg !89

81:                                               ; preds = %71
  br label %83, !dbg !89

82:                                               ; preds = %71
  call void @__assert_fail(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 46, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !86
  unreachable, !dbg !86

83:                                               ; preds = %81
  %84 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !90
  %85 = load i32, i32* %84, align 4, !dbg !90
  %86 = icmp eq i32 %85, 0, !dbg !90
  br i1 %86, label %87, label %88, !dbg !93

87:                                               ; preds = %83
  br label %89, !dbg !93

88:                                               ; preds = %83
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 47, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !90
  unreachable, !dbg !90

89:                                               ; preds = %87
  %90 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !94
  %91 = load i32, i32* %90, align 4, !dbg !94
  %92 = icmp eq i32 %91, 0, !dbg !94
  br i1 %92, label %93, label %94, !dbg !97

93:                                               ; preds = %89
  br label %95, !dbg !97

94:                                               ; preds = %89
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 48, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !94
  unreachable, !dbg !94

95:                                               ; preds = %93
  %96 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !98
  %97 = load i32, i32* %96, align 4, !dbg !98
  %98 = icmp eq i32 %97, 0, !dbg !98
  br i1 %98, label %99, label %100, !dbg !101

99:                                               ; preds = %95
  br label %101, !dbg !101

100:                                              ; preds = %95
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.4, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 49, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !98
  unreachable, !dbg !98

101:                                              ; preds = %99
  %102 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !102
  store i32 5, i32* %102, align 4, !dbg !103
  %103 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !104
  store i32 6, i32* %103, align 4, !dbg !105
  %104 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !106
  store i32 7, i32* %104, align 4, !dbg !107
  %105 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !108
  %106 = bitcast i32* %105 to i8*, !dbg !108
  %107 = getelementptr inbounds [4 x i32], [4 x i32]* %2, i64 0, i64 0, !dbg !109
  %108 = bitcast i32* %107 to i8*, !dbg !109
  %109 = call i32 @memcpy_s(i8* %106, i64 12, i8* %108, i64 12), !dbg !110
  store i32 %109, i32* %4, align 4, !dbg !111
  %110 = load i32, i32* %4, align 4, !dbg !112
  %111 = icmp eq i32 %110, 0, !dbg !112
  br i1 %111, label %112, label %113, !dbg !115

112:                                              ; preds = %101
  br label %114, !dbg !115

113:                                              ; preds = %101
  call void @__assert_fail(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.6, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 56, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !112
  unreachable, !dbg !112

114:                                              ; preds = %112
  %115 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !116
  %116 = load i32, i32* %115, align 4, !dbg !116
  %117 = icmp eq i32 %116, 1, !dbg !116
  br i1 %117, label %118, label %119, !dbg !119

118:                                              ; preds = %114
  br label %120, !dbg !119

119:                                              ; preds = %114
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.7, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 57, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !116
  unreachable, !dbg !116

120:                                              ; preds = %118
  %121 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 1, !dbg !120
  %122 = load i32, i32* %121, align 4, !dbg !120
  %123 = icmp eq i32 %122, 2, !dbg !120
  br i1 %123, label %124, label %125, !dbg !123

124:                                              ; preds = %120
  br label %126, !dbg !123

125:                                              ; preds = %120
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.8, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 58, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !120
  unreachable, !dbg !120

126:                                              ; preds = %124
  %127 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 2, !dbg !124
  %128 = load i32, i32* %127, align 4, !dbg !124
  %129 = icmp eq i32 %128, 3, !dbg !124
  br i1 %129, label %130, label %131, !dbg !127

130:                                              ; preds = %126
  br label %132, !dbg !127

131:                                              ; preds = %126
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.9, i64 0, i64 0), i8* getelementptr inbounds ([60 x i8], [60 x i8]* @.str.1, i64 0, i64 0), i32 59, i8* getelementptr inbounds ([11 x i8], [11 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #5, !dbg !124
  unreachable, !dbg !124

132:                                              ; preds = %130
  ret i32 0, !dbg !128
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

declare dso_local i32 @memcpy_s(i8*, i64, i8*, i64) #3

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #4

attributes #0 = { noinline nounwind uwtable "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn }
attributes #3 = { "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noreturn nounwind "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { noreturn nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 12.0.0-3ubuntu1~20.04.5", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/ponce/git/Dat3M/benchmarks/c/miscellaneous/memcpy_s.c", directory: "/home/ponce/git/Dat3M")
!2 = !{}
!3 = !{!4}
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!5 = !{i32 7, !"Dwarf Version", i32 4}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{!"Ubuntu clang version 12.0.0-3ubuntu1~20.04.5"}
!9 = distinct !DISubprogram(name: "main", scope: !10, file: !10, line: 13, type: !11, scopeLine: 14, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DIFile(filename: "benchmarks/c/miscellaneous/memcpy_s.c", directory: "/home/ponce/git/Dat3M")
!11 = !DISubroutineType(types: !12)
!12 = !{!13}
!13 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!14 = !DILocalVariable(name: "a", scope: !9, file: !10, line: 15, type: !15)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 128, elements: !16)
!16 = !{!17}
!17 = !DISubrange(count: 4)
!18 = !DILocation(line: 15, column: 9, scope: !9)
!19 = !DILocalVariable(name: "b", scope: !9, file: !10, line: 16, type: !20)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 96, elements: !21)
!21 = !{!22}
!22 = !DISubrange(count: 3)
!23 = !DILocation(line: 16, column: 9, scope: !9)
!24 = !DILocalVariable(name: "ret", scope: !9, file: !10, line: 18, type: !13)
!25 = !DILocation(line: 18, column: 9, scope: !9)
!26 = !DILocation(line: 21, column: 41, scope: !9)
!27 = !DILocation(line: 21, column: 11, scope: !9)
!28 = !DILocation(line: 21, column: 9, scope: !9)
!29 = !DILocation(line: 22, column: 5, scope: !30)
!30 = distinct !DILexicalBlock(scope: !31, file: !10, line: 22, column: 5)
!31 = distinct !DILexicalBlock(scope: !9, file: !10, line: 22, column: 5)
!32 = !DILocation(line: 22, column: 5, scope: !31)
!33 = !DILocation(line: 25, column: 20, scope: !9)
!34 = !DILocation(line: 25, column: 11, scope: !9)
!35 = !DILocation(line: 25, column: 9, scope: !9)
!36 = !DILocation(line: 26, column: 5, scope: !37)
!37 = distinct !DILexicalBlock(scope: !38, file: !10, line: 26, column: 5)
!38 = distinct !DILexicalBlock(scope: !9, file: !10, line: 26, column: 5)
!39 = !DILocation(line: 26, column: 5, scope: !38)
!40 = !DILocation(line: 27, column: 5, scope: !41)
!41 = distinct !DILexicalBlock(scope: !42, file: !10, line: 27, column: 5)
!42 = distinct !DILexicalBlock(scope: !9, file: !10, line: 27, column: 5)
!43 = !DILocation(line: 27, column: 5, scope: !42)
!44 = !DILocation(line: 28, column: 5, scope: !45)
!45 = distinct !DILexicalBlock(scope: !46, file: !10, line: 28, column: 5)
!46 = distinct !DILexicalBlock(scope: !9, file: !10, line: 28, column: 5)
!47 = !DILocation(line: 28, column: 5, scope: !46)
!48 = !DILocation(line: 29, column: 5, scope: !49)
!49 = distinct !DILexicalBlock(scope: !50, file: !10, line: 29, column: 5)
!50 = distinct !DILexicalBlock(scope: !9, file: !10, line: 29, column: 5)
!51 = !DILocation(line: 29, column: 5, scope: !50)
!52 = !DILocation(line: 30, column: 5, scope: !9)
!53 = !DILocation(line: 30, column: 10, scope: !9)
!54 = !DILocation(line: 31, column: 5, scope: !9)
!55 = !DILocation(line: 31, column: 10, scope: !9)
!56 = !DILocation(line: 32, column: 5, scope: !9)
!57 = !DILocation(line: 32, column: 10, scope: !9)
!58 = !DILocation(line: 35, column: 20, scope: !9)
!59 = !DILocation(line: 35, column: 38, scope: !9)
!60 = !DILocation(line: 35, column: 11, scope: !9)
!61 = !DILocation(line: 35, column: 9, scope: !9)
!62 = !DILocation(line: 36, column: 5, scope: !63)
!63 = distinct !DILexicalBlock(scope: !64, file: !10, line: 36, column: 5)
!64 = distinct !DILexicalBlock(scope: !9, file: !10, line: 36, column: 5)
!65 = !DILocation(line: 36, column: 5, scope: !64)
!66 = !DILocation(line: 37, column: 5, scope: !67)
!67 = distinct !DILexicalBlock(scope: !68, file: !10, line: 37, column: 5)
!68 = distinct !DILexicalBlock(scope: !9, file: !10, line: 37, column: 5)
!69 = !DILocation(line: 37, column: 5, scope: !68)
!70 = !DILocation(line: 38, column: 5, scope: !71)
!71 = distinct !DILexicalBlock(scope: !72, file: !10, line: 38, column: 5)
!72 = distinct !DILexicalBlock(scope: !9, file: !10, line: 38, column: 5)
!73 = !DILocation(line: 38, column: 5, scope: !72)
!74 = !DILocation(line: 40, column: 5, scope: !75)
!75 = distinct !DILexicalBlock(scope: !76, file: !10, line: 40, column: 5)
!76 = distinct !DILexicalBlock(scope: !9, file: !10, line: 40, column: 5)
!77 = !DILocation(line: 40, column: 5, scope: !76)
!78 = !DILocation(line: 41, column: 5, scope: !9)
!79 = !DILocation(line: 41, column: 10, scope: !9)
!80 = !DILocation(line: 42, column: 5, scope: !9)
!81 = !DILocation(line: 42, column: 10, scope: !9)
!82 = !DILocation(line: 45, column: 20, scope: !9)
!83 = !DILocation(line: 45, column: 38, scope: !9)
!84 = !DILocation(line: 45, column: 11, scope: !9)
!85 = !DILocation(line: 45, column: 9, scope: !9)
!86 = !DILocation(line: 46, column: 5, scope: !87)
!87 = distinct !DILexicalBlock(scope: !88, file: !10, line: 46, column: 5)
!88 = distinct !DILexicalBlock(scope: !9, file: !10, line: 46, column: 5)
!89 = !DILocation(line: 46, column: 5, scope: !88)
!90 = !DILocation(line: 47, column: 5, scope: !91)
!91 = distinct !DILexicalBlock(scope: !92, file: !10, line: 47, column: 5)
!92 = distinct !DILexicalBlock(scope: !9, file: !10, line: 47, column: 5)
!93 = !DILocation(line: 47, column: 5, scope: !92)
!94 = !DILocation(line: 48, column: 5, scope: !95)
!95 = distinct !DILexicalBlock(scope: !96, file: !10, line: 48, column: 5)
!96 = distinct !DILexicalBlock(scope: !9, file: !10, line: 48, column: 5)
!97 = !DILocation(line: 48, column: 5, scope: !96)
!98 = !DILocation(line: 49, column: 5, scope: !99)
!99 = distinct !DILexicalBlock(scope: !100, file: !10, line: 49, column: 5)
!100 = distinct !DILexicalBlock(scope: !9, file: !10, line: 49, column: 5)
!101 = !DILocation(line: 49, column: 5, scope: !100)
!102 = !DILocation(line: 50, column: 5, scope: !9)
!103 = !DILocation(line: 50, column: 10, scope: !9)
!104 = !DILocation(line: 51, column: 5, scope: !9)
!105 = !DILocation(line: 51, column: 10, scope: !9)
!106 = !DILocation(line: 52, column: 5, scope: !9)
!107 = !DILocation(line: 52, column: 10, scope: !9)
!108 = !DILocation(line: 55, column: 20, scope: !9)
!109 = !DILocation(line: 55, column: 38, scope: !9)
!110 = !DILocation(line: 55, column: 11, scope: !9)
!111 = !DILocation(line: 55, column: 9, scope: !9)
!112 = !DILocation(line: 56, column: 5, scope: !113)
!113 = distinct !DILexicalBlock(scope: !114, file: !10, line: 56, column: 5)
!114 = distinct !DILexicalBlock(scope: !9, file: !10, line: 56, column: 5)
!115 = !DILocation(line: 56, column: 5, scope: !114)
!116 = !DILocation(line: 57, column: 5, scope: !117)
!117 = distinct !DILexicalBlock(scope: !118, file: !10, line: 57, column: 5)
!118 = distinct !DILexicalBlock(scope: !9, file: !10, line: 57, column: 5)
!119 = !DILocation(line: 57, column: 5, scope: !118)
!120 = !DILocation(line: 58, column: 5, scope: !121)
!121 = distinct !DILexicalBlock(scope: !122, file: !10, line: 58, column: 5)
!122 = distinct !DILexicalBlock(scope: !9, file: !10, line: 58, column: 5)
!123 = !DILocation(line: 58, column: 5, scope: !122)
!124 = !DILocation(line: 59, column: 5, scope: !125)
!125 = distinct !DILexicalBlock(scope: !126, file: !10, line: 59, column: 5)
!126 = distinct !DILexicalBlock(scope: !9, file: !10, line: 59, column: 5)
!127 = !DILocation(line: 59, column: 5, scope: !126)
!128 = !DILocation(line: 61, column: 2, scope: !9)
