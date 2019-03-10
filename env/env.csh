#!/bin/csh -f
setenv VERILOG_SIM IUS
set IMX319_MODLIST = "ATR DPC1DDY DPC1DST DPC2DS EIS HADDSEL HSUBBIN LSC NR PD PSTSCL RMSC SHDBLK SPC STATS VGRAV"

unsetenv PRO_CYN_RUN_SAVE_RES
setenv EVALUATE `pwd`
setenv blm "bsub -q re5x07lm -Is"
setenv EN_TAP_DUMP 1

setenv INPUT_FILE       "evaluate.conf"
setenv OUTPUT_DIR       "output"
setenv ALWAYS_CONTINUE  0
setenv LEFT_NONE        0

setenv COMMAND_LOG `pwd`/regression_cmd.log
rm -f ${COMMAND_LOG}

set REGRESSION_GLOBAL_STA = `date '+%Y%m%d%H%M%S'`
echo "***Regression_INFO : regression global started at $REGRESSION_GLOBAL_STA." | tee -a ${COMMAND_LOG}

# 
# runtime option check
# 
echo "***Regression_INFO : regression runtime option check ..." | tee -a ${COMMAND_LOG}
set runtime_opt = "$argv"

if ( `echo $runtime_opt | grep '\-\-input' | sed 's/.*\-\-input\s*=\s*\(\S*\).*/\1/g'` != "") then
    setenv INPUT_FILE `echo $runtime_opt | grep '\-\-input' | sed 's/.*\-\-input\s*=\s*\(\S*\).*/\1/g'`
endif
if ( `echo $runtime_opt | grep '\-\-output' | sed 's/.*\-\-output\s*=\s*\(\S*\).*/\1/g'` != "") then
    setenv OUTPUT_DIR `echo $runtime_opt | grep '\-\-output' | sed 's/.*\-\-output\s*=\s*\(\S*\).*/\1/g'`
endif

if ( `echo $runtime_opt | grep -w '\-\-left_none' | wc -l` != 0) then
    setenv LEFT_NONE 1
    echo "***Regression_INFO : --left_none is active." | tee -a ${COMMAND_LOG}
endif
if ( `echo $runtime_opt | grep -w '\-\-always_continue' | wc -l` != 0) then
    setenv ALWAYS_CONTINUE 1
    echo "***Regression_INFO : --always_continue is active." | tee -a ${COMMAND_LOG}
endif

if (! -d $OUTPUT_DIR) then
    echo "***Regression_FATAL: output directory $OUTPUT_DIR is not a directory." | tee -a ${COMMAND_LOG}
    exit 1
endif

if (! -f $INPUT_FILE) then
    echo "***Regression_FATAL: input file $INPUT_FILE does not exist or is not a regular file." | tee -a ${COMMAND_LOG}
    exit 1
endif

echo "***Regression_INFO : used configuration file $INPUT_FILE." | tee -a ${COMMAND_LOG}
echo "***Regression_INFO : regression result will output to $OUTPUT_DIR." | tee -a ${COMMAND_LOG}

setenv RESULT_DIR `pwd`/$OUTPUT_DIR

# 
# tool setup
# 
echo "***Regression_INFO : regression tool setup ..." | tee -a ${COMMAND_LOG}
set bs_script = `cat $INPUT_FILE | grep -v '^\s*\#' | sed 's/\#.*//g' | xargs | sed 's/.*\[VERSION\]\s*\(\S*\)\s*\[FLOWS\].*/\1/g'`

unset argv
pushd setup >& /dev/null
if (`source IMX319.csh >& errinfo.txt`) then
endif
if (`source $bs_script >>& errinfo.txt`) then
endif

if ( `cat errinfo.txt | wc -l` == 0 ) then
    source IMX319.csh
    source $bs_script
    rm -f errinfo.txt
    echo "***Regression_INFO : tool setup succeeded." | tee -a ${COMMAND_LOG}
else
    echo "***Regression_FATAL: tool setup failed." | tee -a ${COMMAND_LOG}
    cat errinfo.txt
endif
popd >& /dev/null

# 
# regression environment check
# 
echo "***Regression_INFO : regression environment check ..." | tee -a ${COMMAND_LOG}
if (`cat $INPUT_FILE | grep -v '^\s*\#' | sed 's/\#.*//g' | grep '\-mod\s*=\s*' | sed 's/.*\-mod\s*=\s*\([A-Za-z0-9_, ]*\) .*/\1/g' | sed 's/,\s*/\n/g' | sort | uniq | grep -w 'all' | wc -l`) then
    set env_check_modlist = "$IMX319_MODLIST"
else
    set env_check_modlist = `cat $INPUT_FILE | grep -v '^\s*\#' | sed 's/\#.*//g' | grep '\-mod\s*=\s*' | sed 's/.*\-mod\s*=\s*\([A-Za-z0-9_, ]*\) .*/\1/g' | sed 's/,\s*/\n/g' | sort | uniq | xargs`
endif

csh -f scripts/regression_env_check.csh $env_check_modlist
if ($? != 0 ) then
    echo "***Regression_FATAL: regression environment failed." | tee -a ${COMMAND_LOG}
    exit 1
endif

echo "***Regression_INFO : regression environment check succeeded." | tee -a ${COMMAND_LOG}

# 
# regression running
# 
set total_flow = `cat $INPUT_FILE | grep -v '^\s*\#' | sed 's/\#.*//g' | sed -n '/\[FLOWS\]/,$p' | grep -v '^\s*$' | wc -l`

set regression_flow = 2
while ( $regression_flow <= $total_flow )
    set line = `cat $INPUT_FILE | grep -v '^\s*\#' | sed 's/\#.*//g' | sed -n '/\[FLOWS\]/,$p' | grep -v '^\s*$' | sed -n ''$regression_flow'p'`
    set flow = `echo $line | awk '{print$1}'`

    if (`echo $line | sed 's/.*\-mod\s*=\s*\([A-Za-z0-9_, ]*\) .*/\1/g' | sed 's/,\s*/\n/g' | sort | uniq | xargs | grep -w all | wc -l`) then
        set modlist = "$IMX319_MODLIST"
    else
        set modlist = `echo $line | sed 's/.*\-mod\s*=\s*\([A-Za-z0-9_, ]*\) .*/\1/g' | sed 's/,\s*/\n/g' | sort | uniq | xargs`
    endif

    ### get regression option ###
    set make_clean = `echo $line | grep -w '\-clean' | wc -l`
    set make_build = `echo $line | grep -w '\-build' | wc -l`
    set make_sim   = `echo $line | grep -w '\-sim'   | wc -l`
    set make_cov   = `echo $line | grep -w '\-cov'   | wc -l`
    set make_lint  = `echo $line | grep -w '\-lint'  | wc -l`
    set make_dc    = `echo $line | grep -w '\-dc'    | wc -l`

    set S_VCS	= `echo $line | grep -w '\-VCS' | wc -l`
    set S_IUS	= `echo $line | grep -w '\-IUS' | wc -l`
    setenv FUNC	  `echo $line | grep -w '\-func\=[^-]*' | sed 's/^\W*\-func\=//g'`

    set total_mod = `echo $modlist | wc -w`
    set done_mod = 0
    ############# TLM FLOW #############
    if ($flow == "TLM") then
        foreach MOD ($modlist)
            echo "***Regression_INFO : ${flow}@${MOD} started at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
            @ done_mod++

            set mod = `echo $MOD | tr A-Z a-z`
            setenv DEFAULT_TEST_CASE "`cat ${EVALUATE}/setup/define_default_test_case/define_default_${mod}_test_case.txt`"

            pushd ../$MOD/behavioral_synthesis/du${mod}_core >& /dev/null

            ## option: -clean
            if ($make_clean == 1) then
                echo "***Regression_INFO : ${flow}@${MOD} clean started at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
                cd make_nw_opt
                rm -f Makefile.prj
                make clean
                rm -rf ../../compiled_techlib
                cd ../
                echo "***Regression_INFO : ${flow}@${MOD} clean ended at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
            endif

            ## option: -build
            if ($make_build == 1) then
                echo "***Regression_INFO : ${flow}@${MOD} build started at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
                cd make_nw_opt

                setenv _LOG_FILE_ $RESULT_DIR/TLM_build_${mod}.txt
                if ( -e ${_LOG_FILE_} ) then
                    mv -f ${_LOG_FILE_} ${_LOG_FILE_}.`date '+%Y%m%d%H%M%S'`
                endif

                csh -f ${EVALUATE}/scripts/TLM_auto_build.csh
                if ($?) then
                    setenv TLM_auto_build_failed_${mod} 1
                    if ($ALWAYS_CONTINUE == 1) then
                        echo "***Regression_WARN : ${flow}@${MOD} build failed. regression will continue according to option --always_continue" | tee -a ${COMMAND_LOG}
                    else
                        continue
                    endif
                endif

                cd ../
                echo "***Regression_INFO : ${flow}@${MOD} build ended at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
            endif

            ## option: -sim
            if ($make_sim == 1) then
                echo "***Regression_INFO : ${flow}@${MOD} sim started at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
                cd make_nw_opt

                setenv _LOG_FILE_ $RESULT_DIR/TLM_sim_${mod}.txt
                if ( -e ${_LOG_FILE_} ) then
                    mv -f ${_LOG_FILE_} ${_LOG_FILE_}.`date '+%Y%m%d%H%M%S'`
                endif

                csh -f ${EVALUATE}/scripts/TLM_auto_sim.csh
                if ($?) then
                    setenv TLM_auto_sim_failed_${mod} 1
#                    if ($ALWAYS_CONTINUE == 1) then
#                        echo "***Regression_WARN : ${flow}@${MOD} sim failed. regression will continue according to option --always_continue" | tee -a ${COMMAND_LOG}
#                    else
#                        continue
#                    endif
                endif

                cd ../
                echo "***Regression_INFO : ${flow}@${MOD} sim ended at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
            endif

            ## option: -cov
            if ($make_cov == 1) then
                echo "***Regression_INFO : ${flow}@${MOD} cov started at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
                cd make_nw_jeda

                setenv _LOG_FILE_ $RESULT_DIR/TLM_cov_${mod}.txt
                if ( -e ${_LOG_FILE_} ) then
                    mv -f ${_LOG_FILE_} ${_LOG_FILE_}.`date '+%Y%m%d%H%M%S'`
                endif

                $blm pro_cyn_run.rb $DEFAULT_TEST_CASE
                $blm make gen_report
                cat summary.txt | tee -a ${_LOG_FILE_}

                cd ../
                echo "***Regression_INFO : ${flow}@${MOD} cov ended at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
            endif

            ## runtime option: --left_none
            if ($LEFT_NONE == 1) then
                echo "***Regression_INFO : ${flow}@${MOD} --left_none started at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}

                cd make_nw_jeda
                rm -f Makefile.prj
                make clean
                cd ..

                cd make_nw_opt
                rm -f Makefile.prj
                make clean
                cd ..

                rm -rf ../vect/*
                rm -rf ../exp/*

                echo "***Regression_INFO : ${flow}@${MOD} --left_none ended at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
            endif
            popd >& /dev/null
            echo "***Regression_INFO : ${flow}@${MOD} ${done_mod}/${total_mod} ended at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
        end
    endif

    ############# RTL FLOW #############
    if ($flow == "RTL") then
        foreach MOD ($modlist)
            echo "***Regression_INFO : ${flow}@${MOD} started at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
            @ done_mod++

            set mod = `echo $MOD | tr A-Z a-z`
            setenv DEFAULT_TEST_CASE `cat ${EVALUATE}/setup/define_default_test_case/define_default_${mod}_test_case.txt`

            pushd ${EVALUATE}/../$MOD/behavioral_synthesis/ >& /dev/null

            ## option: -clean
            if ($make_clean == 1) then
                echo "***Regression_INFO : ${flow}@${MOD} clean started at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
                rm -rf compiled_techlib

                cd du${mod}_core/make
                rm -f Makefile.prj
                make clean
                rm -rf cachelib

                cd ../../du${mod}/make
                rm -f Makefile.prj
                make clean
                rm -rf cachelib

                cd ../..
                echo "***Regression_INFO : ${flow}@${MOD} clean ended at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
            endif

            ## option: -build
            if ($make_build == 1) then
                echo "***Regression_INFO : ${flow}@${MOD} build started at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
                setenv _LOG_FILE_ $RESULT_DIR/RTL_build_${mod}.txt
                if ( -e ${_LOG_FILE_} ) then
                    mv -f ${_LOG_FILE_} ${_LOG_FILE_}.`date '+%Y%m%d%H%M%S'`
                endif

                if ($ALWAYS_CONTINUE == 0) then
                    if (`csh -c 'echo ${?TLM_auto_build_failed_'$mod'}'` || `csh -c 'echo ${?TLM_auto_sim_failed_'$mod'}'`) then
                        echo "***Regression_WARN : ${flow}@${MOD} build will skip due to TLM build or sim failed." | tee -a ${COMMAND_LOG}
                        echo "SKIPPED due to TLM build or sim failed." | tee -a ${_LOG_FILE_}
                        continue
                    endif
                endif

                cd du${mod}_core/make

                ### build core ###
                csh -f ${EVALUATE}/scripts/RTL_auto_build_core.csh
                if ($?) then
                    if ($ALWAYS_CONTINUE == 1) then
                        echo "***Regression_WARN : ${flow}@${MOD} build failed. regression will continue according to option --always_continue" | tee -a ${COMMAND_LOG}
                    else
                        continue
                    endif
                else
                    ### build wrapper ###
                    csh -f ${EVALUATE}/scripts/RTL_auto_build_wrapper.csh $mod
                endif

                cd ../..
                echo "***Regression_INFO : ${flow}@${MOD} build ended at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
            endif

            ## option: -lint
            if ($make_lint == 1) then
                echo "***Regression_INFO : ${flow}@${MOD} lint started at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
                setenv _LOG_FILE_ $RESULT_DIR/RTL_lint_${mod}.txt
                if ( -e ${_LOG_FILE_} ) then
                    mv -f ${_LOG_FILE_} ${_LOG_FILE_}.`date '+%Y%m%d%H%M%S'`
                endif

                cp du${mod}/rtl/du${mod}_HLS.v ${LOGIC_PATH}/rtl/DUBETOP/du${mod}_top
                cd ${LOGIC_PATH}/chk_lint/du${mod}

                $blm script/spyglass_lint.csh |& tee cmd.log

                csh -f ${EVALUATE}/scripts/RTL_auto_lint.csh
                ${EVALUATE}/scripts/summary_spyglass.pl $MOD |& tee ${_LOG_FILE_}

                cd -
                echo "***Regression_INFO : ${flow}@${MOD} lint ended at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
            endif

            ## option: -dc
            if ($make_dc == 1) then
                echo "***Regression_INFO : ${flow}@${MOD} dc started at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
                setenv _LOG_FILE_ $RESULT_DIR/RTL_dc_${mod}.txt
                if ( -e ${_LOG_FILE_} ) then
                    mv -f ${_LOG_FILE_} ${_LOG_FILE_}.`date '+%Y%m%d%H%M%S'`
                endif

                cp du${mod}/rtl/du${mod}_HLS.v ${LOGIC_PATH}/rtl/DUBETOP/du${mod}_top
                cd ${LOGIC_PATH}/chk_synth/du${mod}_dc

                csh -f run_dt_syn.csh

                set bb = `grep 'Macro/Black Box area' report/du${mod}_area2.rpt | sed 's/.*:\s*//g'`
                set total = `grep 'Total cell area' report/du${mod}_area2.rpt | sed 's/.*:\s*//g'`
                set comb = `grep 'Combinational area' report/du${mod}_area2.rpt | sed 's/.*:\s*//g'`
                set noncomb = `grep 'Noncombinational area' report/du${mod}_area2.rpt | sed 's/.*:\s*//g'`
                set real_total = `echo "$total - $bb" | bc`

                set slack = 100
                foreach fn (`grep slack report/du${mod}_*.rpt -h | awk '{print$3}' | sort | uniq`)
                    if (`echo $slack $fn | awk '{if ($1>$2) print 1; else print 0;}'`) then
                        set slack = $fn
                    endif
                end

                echo "TOTAL    : $real_total" | tee -a ${_LOG_FILE_}
                echo "COMB     : $comb" | tee -a ${_LOG_FILE_}
                echo "NON-COMB : $noncomb" | tee -a ${_LOG_FILE_}
                echo "SLACK    : $slack" | tee -a ${_LOG_FILE_}

                cd -

                echo "***Regression_INFO : ${flow}@${MOD} dc ended at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
            endif

            ## option: -sim
            if ($make_sim == 1) then
                echo "***Regression_INFO : ${flow}@${MOD} sim started at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
                setenv _LOG_FILE_ $RESULT_DIR/RTL_sim_${mod}.txt
                if ( -e ${_LOG_FILE_} ) then
                    mv -f ${_LOG_FILE_} ${_LOG_FILE_}.`date '+%Y%m%d%H%M%S'`
                endif


                cd du${mod}/sim
                csh -f $EVALUATE/scripts/RTL_auto_sim.csh

                cd ../../
                echo "***Regression_INFO : ${flow}@${MOD} sim ended at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
            endif

            ## runtime option: --left_none
            if ($LEFT_NONE == 1) then
                echo "***Regression_INFO : ${flow}@${MOD} --left_none started at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}

                pushd du${mod}/make >& /dev/null
                rm -f Makefile.prj
                make clean
                popd  >& /dev/null

                pushd du${mod}/make_hub >& /dev/null
                rm -f Makefile.prj
                make clean
                popd  >& /dev/null

                pushd du${mod}_core/make >& /dev/null
                rm -f Makefile.prj
                make clean
                popd  >& /dev/null

                pushd du${mod}_core/make_hub >& /dev/null
                rm -f Makefile.prj
                make clean
                popd  >& /dev/null

                pushd du${mod}/sim >& /dev/null
                ./sim_para.rb clean
                popd  >& /dev/null

                pushd vect >& /dev/null
                rm -rf ./*
                popd  >& /dev/null

                pushd exp >& /dev/null
                rm -rf ./*
                popd  >& /dev/null

                echo "***Regression_INFO : ${flow}@${MOD} --left_none ended at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
            endif

            popd >& /dev/null
            echo "***Regression_INFO : ${flow}@${MOD} ${done_mod}/${total_mod} ended at `date '+%Y%m%d%H%M%S'`." | tee -a ${COMMAND_LOG}
        end
    endif


    #### <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< will be implemented after >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    if ( $flow == "SCFLOW") then
        setenv _LOG_FILE_ $EVALUATE/$OUTPUT_DIR/SC_report.txt
        foreach MOD ( $modlist  )
            echo "################# Running SC flow for $MOD ... ##########################"
            setenv DEFAULT_TEST_CASE `cat ${EVALUATE}/setup/define_default_test_case/define_default_${mod}_test_case.txt`
            echo "***SC FLOW $MOD***"
            cd $EVALUATE/../$MOD/behavioral_synthesis/
            setenv mod `echo $MOD | tr '[A-Z]' '[a-z]'`
            pushd du${mod}_core >& /dev/null
            pushd make_nw_opt >& /dev/null
            echo "----start of $MOD TLM ----" >> ${_LOG_FILE_}
            csh -f $EVALUATE/scripts/TLM_auto_build.csh
            $blm pro_cyn_run.rb $DEFAULT_TEST_CASE 0 >& /dev/null
            popd >& /dev/null
            pushd make_nw_jeda >& /dev/null
            csh -f $EVALUATE/scripts/TLM_auto_build.csh
            csh -f $EVALUATE/scripts/TLM_auto_cov.csh
            echo "----end of $MOD TLM ----" >> ${_LOG_FILE_}
            csh -f $EVALUATE/scripts/latency.csh path_reset
            popd >& /dev/null

            popd >& /dev/null
            csh -f $EVALUATE/scripts/RTL_auto_build.csh

            if ( ! -e _rtl_ok ) then
                continue
            endif

            pushd du${mod}_core/make_nw_opt >& /dev/null
            $blm pro_cyn_run.rb -s p $DEFAULT_TEST_CASE 0 > /dev/null
            popd >& /dev/null

            if ($S_VCS == "1") then
                pushd du${mod}_core >& /dev/null
                if (! -e make_vcs) then
                    mkdir make_vcs
                    cp -a make/project.tcl make_vcs/
                    cp -a make/Makefile make_vcs/
                    echo "verilogSimulator    vcs" >> make_vcs/project.tcl
                    ln -s ../make/bdw_work make_vcs/bdw_work
                    ln -s ../make/cachelib make_vcs/cachelib
                endif
                pushd make_vcs >& /dev/null
                $blm make sim_E_9999 > sim_E.log 
                $blm make sim_V_9999 > sim_V.log
                if ( `cat sim_E.log | grep MISSMATCH | wc -l` ) then
                    echo "[FAILED]VCS Sim E Failed" >> ${_LOG_FILE_}
                else
                    if ( `cat sim_E.log | grep OK | wc -l` ) then
                        echo "[PASSED]VCS Sim E successed" >> ${_LOG_FILE_}
                    else
                        echo "[FAILED]VCS Sim E can NOT run" >> ${_LOG_FILE_}
                    endif
                endif

                if ( `cat sim_V.log | grep MISSMATCH | wc -l` ) then
                    echo "[FAILED]VCS Sim V Failed" >> ${_LOG_FILE_}
                else
                    if ( `cat sim_V.log | grep OK | wc -l` ) then
                        echo "[PASSED]VCS Sim V successed" >> ${_LOG_FILE_}
                    else
                        echo "[FAILED]VCS Sim V can NOT run" >> ${_LOG_FILE_}
                    endif
                endif

                popd >& /dev/null
                popd >& /dev/null
            endif

            if ($S_IUS == "1") then
                pushd du${mod}_core >& /dev/null
                if (! -e make_ius) then
                    mkdir make_ius
                    cp -a make/project.tcl make_ius/
                    cp -a make/Makefile make_ius/
                    echo "verilogSimulator    ncverilog" >> make_ius/project.tcl
                    ln -s ../make/bdw_work make_ius/bdw_work
                    ln -s ../make/cachelib make_ius/cachelib
                endif
                pushd make_ius >& /dev/null
                $blm make sim_E_9999 > sim_E.log
                $blm make sim_V_9999 > sim_V.log

                if ( `cat sim_E.log | grep MISSMATCH | wc -l` ) then
                    echo "[FAILED]IUS Sim E Failed" >> ${_LOG_FILE_}
                else
                    if ( `cat sim_E.log | grep OK | wc -l` ) then
                        echo "[PASSED]IUS Sim E successed" >> ${_LOG_FILE_}
                    else
                        echo "[FAILED]IUS Sim E can NOT run" >> ${_LOG_FILE_}
                    endif
                endif

                if ( `cat sim_V.log | grep MISSMATCH | wc -l` ) then
                    echo "[FAILED]IUS Sim V Failed" >> ${_LOG_FILE_}
                else
                    if ( `cat sim_V.log | grep OK | wc -l` ) then
                        echo "[PASSED]IUS Sim V successed" >> ${_LOG_FILE_}
                    else
                        echo "[FAILED]IUS Sim V can NOT run" >> ${_LOG_FILE_}
                    endif
                endif

                popd >& /dev/null
                popd >& /dev/null
            endif

            pushd du${mod}_core/make_hub >& /dev/null
            $blm pro_cyn_run.rb $DEFAULT_TEST_CASE 0 > co_sim.log
            if ( `cat co_sim.log | grep MISSMATCH | wc -l` ) then
                echo "[FAILED]Core Co-Sim Failed" >> ${_LOG_FILE_}
            else
                if ( `cat co_sim.log | grep OK | wc -l` ) then
                    echo "[PASSED]Core Co-Sim successed" >> ${_LOG_FILE_}
                else
                    echo "[FAILED]Core Co-Sim can NOT run" >> ${_LOG_FILE_}
                endif
            endif
            popd >& /dev/null
            if ( $LEFT_NONE == 1 ) then
                echo "LEFT NONE WAS SETTED, CLEANNING"
                echo "***LEFT NONE***" >> $OUTPUT_DIR/SC_report.txt
                pushd du${mod}/make >& /dev/null
                rm -f Makefile.prj
                make clean
                popd  >& /dev/null
                pushd du${mod}/make_hub >& /dev/null
                rm -f Makefile.prj
                make clean
                popd  >& /dev/null
                pushd du${mod}_core/make >& /dev/null
                rm -f Makefile.prj
                make clean
                popd  >& /dev/null
                pushd du${mod}_core/make_hub >& /dev/null
                rm -f Makefile.prj
                make clean
                popd  >& /dev/null
                pushd du${mod}_core/make_nw >& /dev/null
                rm -f Makefile.prj
                make clean
                popd  >& /dev/null
                pushd du${mod}_core/make_nw_jeda >& /dev/null
                rm -f Makefile.prj
                make clean
                popd  >& /dev/null
                pushd du${mod}_core/make_nw_opt >& /dev/null
                rm -f Makefile.prj
                make clean
                popd  >& /dev/null
                pushd vect >& /dev/null
                rm -rf ./*
                popd  >& /dev/null
                pushd exp >& /dev/null
                rm -rf ./*
                popd  >& /dev/null
            endif
        end
        cd $EVALUATE
    endif

    if ( $flow == "RTLCOV") then
        setenv _LOG_FILE_ $EVALUATE/$OUTPUT_DIR/RTL_COV_report.txt
        foreach MOD ( $modlist  )
            echo "################# Running RTL cov flow for $MOD ... ##########################"
            setenv DEFAULT_TEST_CASE `cat ${EVALUATE}/setup/define_default_test_case/define_default_${mod}_test_case.txt`
            echo "now is $MOD"
            setenv mod `echo $MOD | tr '[A-Z]' '[a-z]'`
            cd $EVALUATE/../$MOD/behavioral_synthesis/du${mod}/sim
            csh -f $EVALUATE/scripts/RTL_auto_cov.csh
            if ( $LEFT_NONE == 1 ) then
                echo "LEFT NONE WAS SETTED, CLEANNING"
                echo "***LEFT NONE***" >> $OUTPUT_DIR/RTL_COV_report.txt
                pushd du${mod}/sim >& /dev/null
                ./sim_para.rb clean
                popd  >& /dev/null
                pushd vect >& /dev/null
                rm -rf ./*
                popd  >& /dev/null
                pushd exp >& /dev/null
                rm -rf ./*
                popd  >& /dev/null
            endif
        end
        cd $EVALUATE
    endif

    if ($flow == "NEWFUNC") then
        if ( ! -e $EVALUATE/scripts/newf_$FUNC.csh) then
            echo Function $FUNC is not implemented
        else
            setenv _LOG_FILE_ $EVALUATE/$OUTPUT_DIR/NewFunc_${FUNC}_report.txt
            foreach MOD ( $modlist  )
                echo "################# Running New func $FUNC for $MOD ... ##########################"
                setenv DEFAULT_TEST_CASE `cat ${EVALUATE}/setup/define_default_test_case/define_default_${mod}_test_case.txt`
                echo "now is $MOD"
                setenv mod `echo $MOD | tr '[A-Z]' '[a-z]'`

                csh -f $EVALUATE/scripts/newf_$FUNC.csh

                if ( $LEFT_NONE == 1 ) then
                    echo "LEFT NONE WAS SETTED, CLEANNING"
                    echo "***LEFT NONE***" >> $OUTPUT_DIR/NewFunc_report.txt
                    pushd du${mod}/make >& /dev/null
                    rm -f Makefile.prj
                    make clean #>& /dev/null
                    popd  >& /dev/null
                    pushd du${mod}/make_hub >& /dev/null
                    rm -f Makefile.prj
                    make clean #>& /dev/null
                    popd  >& /dev/null
                    pushd du${mod}_core/make >& /dev/null
                    rm -f Makefile.prj
                    make clean #>& /dev/null
                    popd  >& /dev/null
                    pushd du${mod}_core/make_hub >& /dev/null
                    rm -f Makefile.prj
                    make clean #>& /dev/null
                    popd  >& /dev/null
                    pushd du${mod}_core/make_nw >& /dev/null
                    rm -f Makefile.prj
                    make clean #>& /dev/null
                    popd  >& /dev/null
                    pushd du${mod}_core/make_nw_jeda >& /dev/null
                    rm -f Makefile.prj
                    make clean #>& /dev/null
                    popd  >& /dev/null
                    pushd du${mod}_core/make_nw_opt >& /dev/null
                    rm -f Makefile.prj
                    make clean #>& /dev/null
                    popd  >& /dev/null
                    pushd vect >& /dev/null
                    rm -rf ./*
                    popd  >& /dev/null
                    pushd exp >& /dev/null
                    rm -rf ./*
                    popd  >& /dev/null
                endif
            end
            cd $EVALUATE
        endif
    endif

    @ regression_flow ++
end

set REGRESSION_GLOBAL_END = `date '+%Y%m%d%H%M%S'`
echo "***Regression_INFO : regression global ended at $REGRESSION_GLOBAL_END." | tee -a ${COMMAND_LOG}

unsetenv ALWAYS_CONTINUE
unsetenv blm
unsetenv COMMAND_LOG
unsetenv DEFAULT_TEST_CASE
unsetenv EVALUATE
unsetenv FUNC
unsetenv INPUT_FILE
unsetenv LEFT_NONE
unsetenv _LOG_FILE_
unsetenv mod
unsetenv OUTPUT_DIR
unsetenv RESULT_DIR
unsetenv EN_TAP_DUMP

exit 0
