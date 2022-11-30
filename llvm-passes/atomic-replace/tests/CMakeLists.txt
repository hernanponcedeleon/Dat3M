set(DIR "${CMAKE_CURRENT_SOURCE_DIR}")

set(CLANG "${LLVM_BINARY_DIR}/bin/clang")
set(OPT "${LLVM_BINARY_DIR}/bin/opt")
set(LLVM_LINK "${LLVM_BINARY_DIR}/bin/llvm-link")
set(LLVM_DIFF "${LLVM_BINARY_DIR}/bin/llvm-diff")
set(ATOMIC_REPLACE_COMMAND "LD_LIBRARY_PATH=.. source ../atomic-replace")

set(INPUT "example")
set(OUTPUT "out")
set(REVOUTPUT "rev_out")
set(ATOMICS "my_atomics")

set(EXP_FILE "${DIR}/expected${LLVM_SUFF}.diff")
set(EXP_REV_FILE "${DIR}/expected_rev.diff")
set(SED_FILE "${DIR}/sed${LLVM_SUFF}.txt")


add_test(
  NAME test-atomic-replace
  COMMAND bash -c " \
    ${CLANG} ${DIR}/${INPUT}.c -O2 -S -emit-llvm -o ${INPUT}.ll;               \
    ${ATOMIC_REPLACE_COMMAND} ${INPUT}.ll ${OUTPUT}.ll;                        \
    ${LLVM_DIFF} ${INPUT}.ll ${OUTPUT}.ll 2>&1 | diff - ${EXP_FILE}            \
  ")

add_test(
  NAME test-atomic-replace-reverse
  COMMAND bash -c " \
    ${CLANG} ${DIR}/${INPUT}.c -O2 -S -emit-llvm -o ${INPUT}.ll;               \
    ${ATOMIC_REPLACE_COMMAND} ${INPUT}.ll ${OUTPUT}.ll;                        \
    ${CLANG} ${DIR}/../${ATOMICS}.c -O2 -S -emit-llvm -o ${ATOMICS}.ll;        \
    sed -i -f ${SED_FILE} ${ATOMICS}.ll;                                       \
    ${LLVM_LINK} -S ${OUTPUT}.ll ${ATOMICS}.ll -o - | ${OPT} -O2 -S > ${REVOUTPUT}.ll; \
    ${LLVM_DIFF} ${INPUT}.ll ${REVOUTPUT}.ll 2>&1 | diff - ${EXP_REV_FILE}     \
  ")
