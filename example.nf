

INPUT = Channel.of( 1, 2, 3)


process CreateInput {
    // create input files x.in and x2.in
	tag "Parse input ${input}"
	errorStrategy 'finish'

	input:
		val input from INPUT

	output:
		path("*.in") into FILES

	script:
        """
        touch ${input}.in ${input}2.in
        """
}

// Make a mapping from file to x-file
FILES
	.flatten()
	.map{it -> [it.baseName.split('\\.')[0], it]}
	.into{ FILES1; FILES2 }

VALUES_MAP = ['1': 100, '2': 200, '3': 300,
            '12': 1, '22': 2, '32': 3]

process Process {
    // Create files x.p with a value in them
	tag "Process ${input}"
	errorStrategy 'ignore'

	input:
		tuple val(x), path(input) from FILES1

	output:
		tuple val(x), path(output) into PROCESSED_FILES

	script:
		value = VALUES_MAP[x]
		output = "${x}.p"
		if (value)
			"""
			echo ${x} > ${output}
			"""
		else
			error "Invalid value. Check: $value"
}

process Combine {
    // Combine files that have the same key
    tag "Combine ${x}"
	errorStrategy 'ignore'

	input:
		tuple val(x), path(input1), path(input2) from FILES2.join(PROCESSED_FILES)

	output:
		tuple val(x), path(output) into COMBINATION

	script:
		output = "${x}.c"
        """
        cat ${input1} ${input2} > ${output}
        """
}

FINAL = COMBINATION.map{ it -> it[1] } //get only file names

process Merge {
    // Merge all files
    tag "Combine"
	errorStrategy 'ignore'

	input:
		path inputs from FINAL.collect() // wait for all

	output:
		path output into OUTPUT

	script:
		output = "out.txt"
        """
        cat ${inputs} > ${output}
        """
}
