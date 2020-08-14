
Debugging
=========

When it runs, Nextflow creates a ``work`` directory where it stores the
outputs and the commands generated. It is a hash based 2-level in depth
directory structure.

When a particular process fails, you can get its directory in the trace file
and then got into in and check the files :file:`.command.err`, :file:`
.command.out` or :file:`.command.sh`.

In the working directory, you can also find the files that are used as input
(usually as symlinks) and the output files.
