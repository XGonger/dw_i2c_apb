#======================================#
# TCL script for log check             #
#======================================#
# check UVM_ERROR and UVM_FATAL
echo "Checking logs for UVM_ERROR and UVM_FATAL..."
set log_dir "regr_ucdb_*"
set problem_files {}  ;# all problem files

set log_dirs [glob -nocomplain regr_ucdb_*]
if {[llength $log_dirs] == 0} {
    echo "No regr_ucdb_* directories found."
    exit
}

echo "Checking logs for UVM_ERROR and UVM_FATAL..."
foreach log_dir $log_dirs {
    echo "Processing directory: $log_dir"
    foreach log_file [glob -nocomplain ${log_dir}/run_*.log] {
        set fp [open $log_file r]
        set error_count 0
        set fatal_count 0
        while {[gets $fp line] >= 0} {
            if {[regexp {^# UVM_ERROR\s*:\s*(\d+)} $line - error_num]} {
                set error_count $error_num
            } elseif {[regexp {^# UVM_FATAL\s*:\s*(\d+)} $line - fatal_num]} {
                set fatal_count $fatal_num
            }
        }
        close $fp

    if {$error_count > 0 || $fatal_count > 0} {
        lappend problem_files $log_file
    }
    }
}

# output all problem files
echo "Summary of files with UVM_ERROR or UVM_FATAL:"
if {[llength $problem_files] > 0} {
    foreach file $problem_files {
        echo ">>> $file"
    }
    echo "Total files with issues: [llength $problem_files]"
} else {
    echo "No files with UVM_ERROR or UVM_FATAL found."
}

# quit -f

